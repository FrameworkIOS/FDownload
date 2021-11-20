//
//  FDownloadTaskQueue.h
//  FDownload
//
//  Created by Apple on 20/11/21.
//

#import <Foundation/Foundation.h>
#import "FDownloadTask.h"

@class FDownload

NS_ASSUME_NONNULL_BEGIN

@interface FDownloadTaskQueue : NSObject

+ (instancetype)queueWithDownload: (FDownload *)download;

@property (nonatomic, weak, readonly) FDownload * download;

- (void)setTaskState:(FDownloadTask *)task state:(FDownloadTask)

NS_ASSUME_NONNULL_END

