//
//  FDownloadImp.h
//  FDownload
//
//  Created by Apple on 20/11/21.
//

#import <Foundation/Foundation.h>
#import <TargetConditionals.h>
#import "FDownloadTask.h"


NS_ASSUME_NONNULL_BEGIN


extern NSString * const FDownloadDefaultIdentifier;


@class FDownload;

@protocol FDownloadDelegate <NSObject>

@optional;
- (void)downloadDidCompleteAllRunningTasks:(FDownload *)download;
- (void)download:(FDownload *)download taskStateDidChange:(FDownloadTask *)task;
- (void)download:(FDownload *)download taskProgressDidChange:(FDownloadTask *)task;

@end


@interface FDownload : NSObject


+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)download;
+ (instancetype)downloadWithIdentifier:(NSString *)identifier;


- (void)run;
- (void)invalidate;
- (void)invalidateAsync:(BOOL)async;


@property (nonatomic, copy, readonly) NSString * identifier;
@property (nonatomic, strong, readonly) NSURLSessionConfiguration * sessionConfiguration;

@property (nonatomic, weak) id <FDownloadDelegate> delegate;
@property (nonatomic, assign) NSUInteger maxConcurrentOperationCount;


- (nullable FDownloadTask *)taskForContentURL:(NSURL *)contentURL;
- (nullable NSArray <FDownloadTask *> *)tasksForAll;
- (nullable NSArray <FDownloadTask *> *)tasksForRunningOrWatting;
- (nullable NSArray <FDownloadTask *> *)tasksForState:(FDownloadTaskState)state;


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

- (void)cancelAllTasksAndDeleteFiles;
- (void)cancelTaskAndDeleteFile:(FDownloadTask *)task;
- (void)cancelTasksAndDeleteFiles:(NSArray <FDownloadTask *> *)tasks;


#if TARGET_OS_IOS || TARGET_OS_TV
+ (void)handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler;
#endif


@end


NS_ASSUME_NONNULL_END
