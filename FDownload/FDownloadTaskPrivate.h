//
//  FDownloadTaskPrivate.h
//  FDownload
//
//  Created by Apple on 20/11/21.
//

#import <Foundation/Foundation.h>
#import "FDownloadTask.h"

@interface FDownloadTask ()

@property (nonatomic, assign) FDownloadTaskState state;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSURL * contentURL;
@property (nonatomic, copy) NSURL * fileURL;
@property (nonatomic, assign) BOOL fileDidRemoved;

@property (nonatomic, assign) int64_t bytesWritten;
@property (nonatomic, assign) int64_t totalBytesWritten;
@property (nonatomic, assign) int64_t totalBytesExpectedToWrite;

@property (nonatomic, strong) NSData * resumeInfoData;
@property (nonatomic, assign) int64_t resumeFileOffset;
@property (nonatomic, assign) int64_t resumeExpectedTotalBytes;

@property (nonatomic, strong) NSError * error;

- (void)setBytesWritten:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;
- (void)setResumeFileOffset:(int64_t)resumeFileOffset resumeExpectedTotalBytes:(int64_t)resumeExpectedTotalBytes;

@end
