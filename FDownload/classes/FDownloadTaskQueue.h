//
//  FDownloadTaskQueue.h
//  FDownload
//
//  Created by Apple on 20/11/21.
//

#import <Foundation/Foundation.h>
#import "FDownloadTask.h"

@class FDownload;

NS_ASSUME_NONNULL_BEGIN

@interface FDownloadTaskQueue : NSObject

+ (instancetype)queueWithDownload:(FDownload *)download;

@property (nonatomic, weak, readonly) FDownload * download;

- (nullable FDownloadTask *)taskForContentURL:(NSURL *)contentURL;
- (nullable NSArray <FDownloadTask *> *)tasksForAll;
- (nullable NSArray <FDownloadTask *> *)tasksForRunning;
- (nullable NSArray <FDownloadTask *> *)tasksForRunningOrWatting;
- (nullable NSArray <FDownloadTask *> *)tasksForState:(FDownloadTaskState)state;

- (void)setTaskState:(FDownloadTask *)task state:(FDownloadTaskState)state;

- (nullable FDownloadTask *)downloadTaskSync;
- (void)addDownloadTask:(FDownloadTask *)task;
- (void)addDownloadTasks:(NSArray <FDownloadTask *> *)tasks;

- (void)addSuppendTask:(FDownloadTask *)task;
- (void)addSuppendTasks:(NSArray <FDownloadTask *> *)tasks;

- (void)resumeAllTasks;
- (void)resumeTask:(FDownloadTask *)task;
- (void)resumeTasks:(NSArray <FDownloadTask *> *)tasks;

- (void)suspendAllTasks;
- (void)suspendTask:(FDownloadTask *)task;
- (void)suspendTasks:(NSArray <FDownloadTask *> *)tasks;

- (void)cancelAllTasks;
- (void)cancelTask:(FDownloadTask *)task;
- (void)cancelTasks:(NSArray <FDownloadTask *> *)tasks;

- (void)deleteAllTaskFiles;
- (void)deleteTaskFile:(FDownloadTask *)task;
- (void)deleteTaskFiles:(NSArray <FDownloadTask *> *)tasks;

- (void)invalidate;
- (void)archive;

@end

NS_ASSUME_NONNULL_END
