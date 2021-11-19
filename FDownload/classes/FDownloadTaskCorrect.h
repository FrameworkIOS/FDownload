//
//  FDownloadTaskCorrect.h
//  FDownload
//
//  Created by Apple on 19/11/21.
//

#import <Foundation/Foundation.h>

@interface FDownloadTaskCorrect : NSObject

+ (NSURLSessionDownloadTask *)downloadTaskWithSession:(NSURLSession *)session resumeData:(NSData *)resumeData;

@end
