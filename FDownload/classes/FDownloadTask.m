//
//  FDownloadTask.m
//  FDownload
//
//  Created by Apple on 20/11/21.
//

#import "FDownloadTask.h"
#import "FDownloadTaskPrivate.h"
#import "FDownloadImp.h"
#import "FDownloadTools.h"

@interface FDownloadTask ()

@property (nonatomic, copy) NSURL * realFileURL;

@end


@implementation FDownloadTask

+ (instancetype)taskWithContentURL:(NSURL *)contentURL title:(NSString *)title fileURL:(NSURL *)fileURL
{
    return [[self alloc] initWithContentURL:contentURL title:title fileURL:fileURL];
}

- (instancetype)initWithContentURL:(NSURL *)contentURL title:(NSString *)title fileURL:(NSURL *)fileURL

{
    if (self = [super init]) {
        self.contentURL = contentURL;
        self.title = title;
        self.fileURL = fileURL;
        self.replaceHomeDirectoryIfNeed = YES;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[FDownloadTask class]]) {
        return NO;
    }
    FDownloadTask * task = (FDownloadTask *)object;
    if ([self.contentURL.absoluteString isEqualToString:task.contentURL.absoluteString]) {
        return YES;
    }
    
    return NO;
}

@end
