//
//  FDownloadTuple.h
//  FDownload
//
//  Created by Apple on 20/11/21.
//

#import <Foundation/Foundation.h>

@class FDownloadTask;

@interface FDownloadTuple : NSObject

+ (instancetype)tupleWithDownloadTask:(FDownloadTask *)downloadTask sessionTask:(NSURLSessionDownloadTask *)sessionTask;

@property (nonatomic, strong) FDownloadTask * downloadTask;
@property (nonatomic, strong) NSURLSessionDownloadTask * sessionTask;

@end
