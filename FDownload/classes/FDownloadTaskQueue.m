//
//  FDownloadTaskQueue.m
//  FDownload
//
//  Created by Apple on 20/11/21.
//

#import "FDownloadTaskQueue.h"
#import "FDownloadImp.h"
#import "FDownloadTaskPrivate.h"
#import "FDownloadTools.h"

@interface FDownloadTaskQueue ()

@property (nonatomic, strong) NSMutableArray <FDownloadTask *> * tasks;

@property (nonatomic, assign) NSTimeInterval archiveTimeInterval;
@property (nonatomic, copy) NSString * archiverPath;
@property (nonatomic, strong) NSCondition * condition;
@property (nonatomic, assign) BOOL closed;

@end
