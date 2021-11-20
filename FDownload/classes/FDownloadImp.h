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

@class FDownload

#if TARGET_OS_IOS || TARGET_OS_TV

+ (void)handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler;

#endif

NS_ASSUME_NONNULL_END
