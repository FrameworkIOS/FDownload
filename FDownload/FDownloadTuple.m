//
//  FDownloadTuple.m
//  FDownload
//
//  Created by Apple on 20/11/21.
//

#import "FDownloadTuple.h"

@implementation FDownloadTuple

+ (instancetype)tupleWithDownloadTask:(FDownloadTask *)downloadTask sessionTask:(NSURLSessionDownloadTask *)sessionTask
{
    return [[self alloc] initWithDownloadTask:downloadTask sessionTask:sessionTask];
}

- (instancetype)initWithDownloadTask:(FDownloadTask *)downloadTask sessionTask:(NSURLSessionDownloadTask *)sessionTask
{
    if (self = [super init]) {
        self.downloadTask = downloadTask;
        self.sessionTask = sessionTask;
    }
    return self;
}

@end
