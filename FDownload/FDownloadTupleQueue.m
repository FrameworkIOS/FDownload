//
//  FDownloadTupleQueue.m
//  FDownload
//
//  Created by Apple on 20/11/21.
//

#import "FDownloadTupleQueue.h"
#import "FDownloadTask.h"
#import "FDownloadTaskPrivate.h"
#import "FDownloadTuple.h"

@interface FDownloadTupleQueue ()

@property (nonatomic, strong) NSLock * tupleLock;

@end

@implementation FDownloadTupleQueue

- (instancetype)init
{
    if (self = [super init]) {
        self->_tuples = [NSMutableArray array];
        self.tupleLock = [[NSLock alloc] init];
    }
    return self;
}

- (FDownloadTuple *)tupleWithDownloadTask:(FDownloadTask *)downloadTask
{
    [self.tupleLock lock];
    FDownloadTuple * tuple = nil;
    for (FDownloadTuple * obj in self.tuples) {
        if (obj.downloadTask == downloadTask) {
            tuple = obj;
            break;
        }
    }
    [self.tupleLock unlock];
    return tuple;
}

- (NSArray<FDownloadTuple *> *)tuplesWithDownloadTasks:(NSArray<FDownloadTask *> *)downloadTasks
{
    [self.tupleLock lock];
    NSMutableArray * temp = [NSMutableArray array];
    for (FDownloadTuple * obj in self.tuples) {
        if ([downloadTasks containsObject:obj.downloadTask]) {
            [temp addObject:obj];
        }
    }
    [self.tupleLock unlock];
    if (temp.count > 0) {
        return temp;
    } else {
        return nil;
    }
}

- (FDownloadTuple *)tupleWithDownloadTask:(FDownloadTask *)downloadTask sessionTask:(NSURLSessionDownloadTask *)sessionTask
{
    if (!downloadTask) {
        return nil;
    }
    FDownloadTuple * tuple = [self tupleWithDownloadTask:downloadTask];
    if (tuple) {
        return tuple;
    }
    [self.tupleLock lock];
    tuple = [FDownloadTuple tupleWithDownloadTask:downloadTask sessionTask:sessionTask];
    [self.tuples addObject:tuple];
    [self.tupleLock unlock];
    return tuple;
}

- (void)addTuple:(FDownloadTuple *)tuple
{
    [self.tupleLock lock];
    if (![self.tuples containsObject:tuple]) {
        [self.tuples addObject:tuple];
    }
    [self.tupleLock unlock];
}

- (void)removeTupleWithSesstionTask:(NSURLSessionTask *)sessionTask
{
    if (!sessionTask) return;
    
    [self.tupleLock lock];
    FDownloadTuple * tuple = nil;
    for (FDownloadTuple * obj in self.tuples) {
        if (obj.sessionTask == sessionTask) {
            tuple = obj;
            break;
        }
    }
    if (tuple) {
        [self.tuples removeObject:tuple];
    }
    [self.tupleLock unlock];
}

- (void)removeTuple:(FDownloadTuple *)tuple
{
    if (tuple) {
        [self removeTuples:@[tuple]];
    }
}

- (void)removeTuples:(NSArray<FDownloadTuple *> *)tuples
{
    if (tuples.count <= 0) return;
    [self.tupleLock lock];
    if (self.tuples == tuples) {
        [self.tuples removeAllObjects];
    } else {
        for (FDownloadTuple * obj in tuples) {
            if ([self.tuples containsObject:obj]) {
                [self.tuples removeObject:obj];
            }
        }
    }
    [self.tupleLock unlock];
}

- (void)cancelDownloadTask:(FDownloadTask *)downloadTask resume:(BOOL)resume completionHandler:(void(^)(FDownloadTuple * tuple))completionHandler
{
    FDownloadTuple * tuple = [self tupleWithDownloadTask:downloadTask];
    [self cancelTuple:tuple resume:resume completionHandler:completionHandler];
}

- (void)cancelDownloadTasks:(NSArray <FDownloadTask *> *)downloadTasks resume:(BOOL)resume completionHandler:(void(^)(NSArray <FDownloadTuple *> * tuples))completionHandler
{
    NSArray <FDownloadTuple *> * tuples = [self tuplesWithDownloadTasks:downloadTasks];
    [self cancelTuples:tuples resume:resume completionHandler:completionHandler];
}

- (void)cancelAllTupleResume:(BOOL)resume completionHandler:(void(^)(NSArray <FDownloadTuple *> * tuples))completionHandler
{
    [self cancelTuples:self.tuples resume:resume completionHandler:completionHandler];
}

- (void)cancelTuple:(FDownloadTuple *)tuple resume:(BOOL)resume completionHandler:(void(^)(FDownloadTuple * tuple))completionHandler
{
    if (tuple) {
        [self cancelTuples:@[tuple] resume:resume completionHandler:^(NSArray<FDownloadTuple *> * tuples) {
            if (completionHandler) {
                completionHandler(tuples.firstObject);
            }
        }];
    } else {
        [self cancelTuples:nil resume:resume completionHandler:^(NSArray<FDownloadTuple *> * tuples) {
            if (completionHandler) {
                completionHandler(tuples.firstObject);
            }
        }];
    }
}

- (void)cancelTuples:(NSArray <FDownloadTuple *> *)tuples resume:(BOOL)resume completionHandler:(void(^)(NSArray <FDownloadTuple *> * tuples))completionHandler
{
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("FDownload-Cancel-Queue", NULL);
    });
    
    [self.tupleLock lock];
    if (tuples.count <= 0) {
        dispatch_async(queue, ^{
            if (completionHandler) {
                completionHandler(nil);
            }
        });
        [self.tupleLock unlock];
        return;
    }
    if (resume) {
        dispatch_group_t group = dispatch_group_create();
        for (FDownloadTuple * obj in tuples) {
            if (obj.sessionTask.state == NSURLSessionTaskStateRunning || obj.sessionTask.state == NSURLSessionTaskStateSuspended) {
                dispatch_group_enter(group);
                [obj.sessionTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                    obj.downloadTask.resumeInfoData = resumeData;
                    dispatch_group_leave(group);
                }];
            }
        }
        dispatch_group_notify(group, queue, ^{
            if (completionHandler) {
                completionHandler(tuples);
            }
        });
    } else {
        for (FDownloadTuple * obj in tuples) {
            [obj.sessionTask cancel];
        }
        dispatch_async(queue, ^{
            if (completionHandler) {
                completionHandler(tuples);
            }
        });
    }
    [self.tupleLock unlock];
}

@end
