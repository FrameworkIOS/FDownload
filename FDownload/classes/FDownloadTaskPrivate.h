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
@property (nonatomic, copy) BOOL fileDidRemoved;

@property (nonatomic, strong) NSError * error;

@end
