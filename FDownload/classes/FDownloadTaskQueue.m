//
//  FDownloadTaskQueue.m
//  FDownload
//
//  Created by Apple on 20/11/21.
//

#import "FDownloadTaskQueue.h"
#import "FDownloadImp.h"
#import "FDownloadTaskPrivate.h"
#import "FDownloadTools.h"

@interface FDownloadTaskQueue ()

@property (nonatomic, strong) NSMutableArray <FDownloadTask *> * tasks;

@property (nonatomic, assign) NSTimeInterval archiveTimeInterval;
@property (nonatomic, copy) NSString * archiverPath;
@property (nonatomic, strong) NSCondition * condition;
@property (nonatomic, assign) BOOL closed;

@end

@implementation FDownloadTaskQueue

+ (instancetype)queueWithDownload:(FDownload *)download
{
    return [[self alloc] initWithDownload:download];
}

- (instancetype)initWithDownload:(FDownload *)download
{
    if (self = [super init]) {
        self->_download = download;
        self->_archiverPath = [FDownloadTools archiverFilePathWithIdentifier:download.identifier];
        self->_tasks = [NSKeyedUnarchiver unarchiveObjectWithFile:self.archiverPath];
        if (!self->_tasks) {
            self->_tasks = [NSMutableArray array];
        }
        self.condition = [[NSCondition alloc] init];
        [self resetQueue];
    }
    return self;
}

- (void)resetQueue
{
    [self.condition lock];
    for (FDownloadTask * obj in self.tasks) {
        obj.download = self.download;
        if (obj.state == FDownloadTaskStateRunning) {
            obj.state = FDownloadTaskStateWaiting;
        }
    }
    [self.condition unlock];
    [self tryArchive];
}

- (FDownloadTask *)taskForContentURL:(NSURL *)contentURL
{
    if (contentURL.absoluteString.length <= 0) return nil;
    [self.condition lock];
    FDownloadTask * task = nil;
    for (FDownloadTask * obj in self.tasks) {
        if ([obj.contentURL.absoluteString isEqualToString:contentURL.absoluteString]) {
            task = obj;
            break;
        }
    }
    [self.condition unlock];
    return task;
}

- (NSArray <FDownloadTask *> *)tasksForAll
{
    if (self.tasks.count > 0) {
        return [self.tasks copy];
    }
    return nil;
}

- (NSArray <FDownloadTask *> *)tasksForRunning
{
    [self.condition lock];
    NSMutableArray * temp = [NSMutableArray array];
    for (FDownloadTask * obj in self.tasks) {
        if (obj.state == FDownloadTaskStateRunning) {
            [temp addObject:obj];
        }
    }
    if (temp.count <= 0) {
        temp = nil;
    }
    [self.condition unlock];
    if (temp.count > 0) {
        return [temp copy];
    }
    return nil;
}

- (NSArray <FDownloadTask *> *)tasksForRunningOrWatting
{
    [self.condition lock];
    NSMutableArray * temp = [NSMutableArray array];
    for (FDownloadTask * obj in self.tasks) {
        if (obj.state == FDownloadTaskStateRunning || obj.state == FDownloadTaskStateWaiting) {
            [temp addObject:obj];
        }
    }
    if (temp.count <= 0) {
        temp = nil;
    }
    [self.condition unlock];
    if (temp.count > 0) {
        return [temp copy];
    }
    return nil;
}

- (NSArray <FDownloadTask *> *)tasksForState:(FDownloadTaskState)state
{
    [self.condition lock];
    NSMutableArray * temp = [NSMutableArray array];
    for (FDownloadTask * obj in self.tasks) {
        if (obj.state == state) {
            [temp addObject:obj];
        }
    }
    if (temp.count <= 0) {
        temp = nil;
    }
    [self.condition unlock];
    if (temp.count > 0) {
        return [temp copy];
    }
    return nil;
}

- (void)setTaskState:(FDownloadTask *)task state:(FDownloadTaskState)state
{
    if (!task) return;
    if (task.state == state) return;
    [self.condition lock];
    task.state = state;
    [self.condition unlock];
    [self tryArchive];
}

- (FDownloadTask *)downloadTaskSync
{
    if (self.closed) return nil;
    [self.condition lock];
    FDownloadTask * task;
    do {
        for (FDownloadTask * obj in self.tasks) {
            if (self.closed) {
                [self.condition unlock];
                return nil;
            }
            switch (obj.state) {
                case FDownloadTaskStateNone:
                case FDownloadTaskStateWaiting:
                    task = obj;
                    break;
                default:
                    break;
            }
            if (task) break;
        }
        if (!task) {
            [self.condition wait];
        }
    } while (!task);
    [self.condition unlock];
    return task;
}

- (void)addDownloadTask:(FDownloadTask *)task
{
    if (task) {
        [self addDownloadTasks:@[task]];
    }
}

- (void)addDownloadTasks:(NSArray <FDownloadTask *> *)tasks
{
    if (self.closed) return;
    if (tasks.count <= 0) return;
    [self.condition lock];
    BOOL needSignal = NO;
    for (FDownloadTask * obj in tasks) {
        if (![self.tasks containsObject:obj]) {
            obj.download = self.download;
            [self.tasks addObject:obj];
        }
        switch (obj.state) {
            case FDownloadTaskStateNone:
            case FDownloadTaskStateSuspend:
            case FDownloadTaskStateCanceled:
            case FDownloadTaskStateFailured:
                obj.state = FDownloadTaskStateWaiting;
                needSignal = YES;
                break;
            default:
                break;
        }
    }
    if (needSignal) {
        [self.condition signal];
    }
    [self.condition unlock];
    [self tryArchive];
}

- (void)addSuppendTask:(FDownloadTask *)task
{
    if (task) {
        [self addSuppendTasks:@[task]];
    }
}

- (void)addSuppendTasks:(NSArray <FDownloadTask *> *)tasks
{
    if (tasks.count <= 0) return;
    [self.condition lock];
    for (FDownloadTask * obj in tasks) {
        if (![self.tasks containsObject:obj]) {
            [self.tasks addObject:obj];
        }
        switch (obj.state) {
            case FDownloadTaskStateNone:
            case FDownloadTaskStateWaiting:
            case FDownloadTaskStateRunning:
                obj.state = FDownloadTaskStateSuspend;
                break;
            default:
                break;
        }
    }
    [self.condition unlock];
    [self tryArchive];
}

- (void)resumeAllTasks
{
    [self resumeTasks:self.tasks];
}

- (void)resumeTask:(FDownloadTask *)task
{
    if (task) {
        [self resumeTasks:@[task]];
    }
}

- (void)resumeTasks:(NSArray<FDownloadTask *> *)tasks
{
    if (self.closed) return;
    if (tasks.count <= 0) return;
    [self.condition lock];
    BOOL needSignal = NO;
    for (FDownloadTask * task in tasks) {
        switch (task.state) {
            case FDownloadTaskStateNone:
            case FDownloadTaskStateSuspend:
            case FDownloadTaskStateCanceled:
            case FDownloadTaskStateFailured:
                task.state = FDownloadTaskStateWaiting;
                needSignal = YES;
                break;
            default:
                break;
        }
    }
    if (needSignal) {
        [self.condition signal];
    }
    [self.condition unlock];
    [self tryArchive];
}

- (void)suspendAllTasks
{
    [self suspendTasks:self.tasks];
}

- (void)suspendTask:(FDownloadTask *)task
{
    if (task) {
        [self suspendTasks:@[task]];
    }
}

- (void)suspendTasks:(NSArray<FDownloadTask *> *)tasks
{
    if (tasks.count <= 0) return;
    [self.condition lock];
    for (FDownloadTask * task in tasks) {
        switch (task.state) {
            case FDownloadTaskStateNone:
            case FDownloadTaskStateWaiting:
            case FDownloadTaskStateRunning:
                task.state = FDownloadTaskStateSuspend;
                break;
            default:
                break;
        }
    }
    [self.condition unlock];
    [self tryArchive];
}

- (void)cancelAllTasks
{
    [self cancelTasks:self.tasks];
}

- (void)cancelTask:(FDownloadTask *)task
{
    if (task) {
        [self cancelTasks:@[task]];
    }
}

- (void)cancelTasks:(NSArray<FDownloadTask *> *)tasks
{
    if (tasks.count <= 0) return;
    [self.condition lock];
    NSMutableArray <FDownloadTask *> * temp = [NSMutableArray array];
    for (FDownloadTask * task in tasks) {
        if ([self.tasks containsObject:task]) {
            task.state = FDownloadTaskStateCanceled;
            [temp addObject:task];
        }
    }
    for (FDownloadTask * task in temp) {
        task.download = nil;
        [self.tasks removeObject:task];
    }
    [self.condition unlock];
    [self tryArchive];
}

- (void)deleteAllTaskFiles
{
    [self deleteTaskFiles:self.tasks];
}

- (void)deleteTaskFile:(FDownloadTask *)task
{
    if (task) {
        [self deleteTaskFiles:@[task]];
    }
}

- (void)deleteTaskFiles:(NSArray <FDownloadTask *> *)tasks
{
    if (tasks.count <= 0) return;
    [self.condition lock];
    for (FDownloadTask * task in tasks) {
        if ([self.tasks containsObject:task]) {
            [FDownloadTools removeFileWithFileURL:task.fileURL];
            task.fileDidRemoved = YES;
        }
    }
    [self.condition unlock];
    /*
    [self tryArchive];
     */
}

- (void)tryArchive
{
    NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (timeInterval > self.archiveTimeInterval) {
            [self archive];
        }
    });
}

- (void)archive
{
    [self.condition lock];
    [NSKeyedArchiver archiveRootObject:self.tasks toFile:self.archiverPath];
    self.archiveTimeInterval = [NSDate date].timeIntervalSince1970;
    [self.condition unlock];
}

- (void)invalidate
{
    if (self.closed) return;
    
    [self.condition lock];
    self.closed = YES;
    for (FDownloadTask * task in self.tasks) {
        switch (task.state) {
            case FDownloadTaskStateRunning:
                task.state = FDownloadTaskStateWaiting;
                break;
            default:
                break;
        }
    }
    [self.condition broadcast];
    [self.condition unlock];
    [self archive];
}

- (void)dealloc
{
    [self invalidate];
}

@end
