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

@end
