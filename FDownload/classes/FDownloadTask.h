//
//  FDownloadTask.h
//  FDownload
//
//  Created by Apple on 19/11/21.
//

#import <Foundation/Foundation.h>

@class FDownload;
@class FDownloadTask;

typedef NS_ENUM(NSUInteger, FDownloadTaskState)
{
    FDownloadTaskStateNone,
    FDownloadTaskStateWaiting,
    FDownloadTaskStateRunning,
    FDownloadTaskStateSuspend,
    FDownloadTaskStateFinished,
    FDownloadTaskStateCanceled,
    FDownloadTaskStateFailured,
};

@protocol FDownloadTaskDelegate <NSObject>

@optional
- (void)taskStateDidChange:(FDownloadTask *)task;
- (void)taskProgressDidChange:(FDownloadTask *)task;

@end

@interface FDownloadTask : NSObject

+ (instancetype)taskWithContentURL:(NSURL *)contentURL
                             title:(NSString *)title
                           fileURL:(NSURL *)fileURL;

@property (nonatomic, strong) id <NSCoding> object;

@property (nonatomic, weak) FDownload * download;
@property (nonatomic, weak) id <FDownloadTaskDelegate> delegate;

@property (nonatomic, assign, readonly) FDownloadTaskState state;

@property (nonatomic, copy, readonly) NSURL * contentURL;
@property (nonatomic, copy, readonly) NSString * title;
@property (nonatomic, copy, readonly) NSURL * fileURL;

@property (nonatomic, assign, readonly) BOOL fileDidRemoved;
@property (nonatomic, assign, readonly) BOOL fileIsValid;

@property (nonatomic, assign) BOOL replaceHomeDirectoryIfNeed;      // default is YES;

@property (nonatomic, assign, readonly) float progress;
@property (nonatomic, assign, readonly) int64_t bytesWritten;
@property (nonatomic, assign, readonly) int64_t totalBytesWritten;
@property (nonatomic, assign, readonly) int64_t totalBytesExpectedToWrite;

// about resume
@property (nonatomic, strong, readonly) NSData * resumeInfoData;
@property (nonatomic, assign, readonly) int64_t resumeFileOffset;
@property (nonatomic, assign, readonly) int64_t resumeExpectedTotalBytes;

@property (nonatomic, strong, readonly) NSError * error;

@end
