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
