//
//  FDownloadImp.m
//  FDownload
//
//  Created by Apple on 20/11/21.
//

#import "FDownloadImp.h"
#import "FDownloadTaskCorrect.h"
#import "FDownloadTaskPrivate.h"
#import "FDownloadTaskQueue.h"
#import "FDownloadTuple.h"
#import "FDownloadTupleQueue.h"
#import "FDownloadTools.h"

#import <objc/message.h>
#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#elif TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#endif

@interface SGDownloadManager: NSObject

+ (instancetype)manager;

@property (nonatomic, strong) NSMutableArray <FDownload *> * downloads;

@end
