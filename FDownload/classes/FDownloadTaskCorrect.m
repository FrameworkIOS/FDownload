//
//  FDownloadTaskCorrect.m
//  FDownload
//
//  Created by Apple on 19/11/21.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif

@implementation FDownloadTaskCorrect

+ (NSURLSessionDownloadTask *)downloadTaskWithSession:(NSURLSession *)session resumeData:(NSData *)resumeData
{
#if TARGET_OS_IOS
    float systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
    if (systemVersion >= 10.0 || systemVersion < 10.2)
        // TODO
        
#endif
        return [session downloadTaskWithResumeData:resumeData];
}


@end
