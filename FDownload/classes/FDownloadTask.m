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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.object = [aDecoder decodeObjectForKey:@"object"];
        self.state = [[aDecoder decodeObjectForKey:@"state"] unsignedIntegerValue];
        
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.contentURL = [aDecoder decodeObjectForKey:@"contentURL"];
        self.fileURL = [aDecoder decodeObjectForKey:@"fileURL"];
        self.replaceHomeDirectoryIfNeed = [[aDecoder decodeObjectForKey:@"replaceHomeDirectoryIfNeed"] boolValue];
        
        self.bytesWritten = [[aDecoder decodeObjectForKey:@"bytesWritten"] longLongValue];
        self.totalBytesWritten = [[aDecoder decodeObjectForKey:@"totalBytesWritten"] longLongValue];
        self.totalBytesExpectedToWrite = [[aDecoder decodeObjectForKey:@"totalBytesExpectedToWrite"] longLongValue];
        
        self.resumeInfoData = [aDecoder decodeObjectForKey:@"resumeInfoData"];
        self.resumeFileOffset = [[aDecoder decodeObjectForKey:@"resumeFileOffset"] longLongValue];
        self.resumeExpectedTotalBytes = [[aDecoder decodeObjectForKey:@"resumeExpectedTotalBytes"] longLongValue];
        
        self.error = [aDecoder decodeObjectForKey:@"error"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.object forKey:@"object"];
    [aCoder encodeObject:@(self.state) forKey:@"state"];
    
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.contentURL forKey:@"contentURL"];
    [aCoder encodeObject:self.fileURL forKey:@"fileURL"];
    [aCoder encodeObject:@(self.replaceHomeDirectoryIfNeed) forKey:@"replaceHomeDirectoryIfNeed"];
    
    [aCoder encodeObject:@(self.bytesWritten) forKey:@"bytesWritten"];
    [aCoder encodeObject:@(self.totalBytesWritten) forKey:@"totalBytesWritten"];
    [aCoder encodeObject:@(self.totalBytesExpectedToWrite) forKey:@"totalBytesExpectedToWrite"];
    
    [aCoder encodeObject:self.resumeInfoData forKey:@"resumeInfoData"];
    [aCoder encodeObject:@(self.resumeFileOffset) forKey:@"resumeFileOffset"];
    [aCoder encodeObject:@(self.resumeExpectedTotalBytes) forKey:@"resumeExpectedTotalBytes"];
    
    [aCoder encodeObject:self.error forKey:@"error"];
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

- (void)setBytesWritten:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    self.bytesWritten = bytesWritten;
    self.totalBytesWritten = totalBytesWritten;
    self.totalBytesExpectedToWrite = totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(taskProgressDidChange:)]) {
            [self.delegate taskProgressDidChange:self];
        }
        if ([self.download.delegate respondsToSelector:@selector(download:taskProgressDidChange:)]) {
            [self.download.delegate download:self.download taskProgressDidChange:self];
        }
    });
}

- (void)setResumeFileOffset:(int64_t)resumeFileOffset resumeExpectedTotalBytes:(int64_t)resumeExpectedTotalBytes
{
    self.resumeFileOffset = resumeFileOffset;
    self.resumeExpectedTotalBytes = resumeExpectedTotalBytes;
}

- (void)setState:(FDownloadTaskState)state
{
    if (_state != state) {
        _state = state;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(taskStateDidChange:)]) {
                [self.delegate taskStateDidChange:self];
            }
            if ([self.download.delegate respondsToSelector:@selector(download:taskStateDidChange:)]) {
                [self.download.delegate download:self.download taskStateDidChange:self];
            }
        });
    }
    if (_state != FDownloadTaskStateFailured) {
        self.error = nil;
    }
    if (_state == FDownloadTaskStateFinished) {
        self.resumeInfoData = nil;
        self.bytesWritten = 0;
        self.totalBytesWritten = self.totalBytesExpectedToWrite;
    }
    self.resumeFileOffset = 0;
    self.resumeExpectedTotalBytes = 0;
}

- (NSURL *)fileURL
{
    if (self.replaceHomeDirectoryIfNeed) {
        if (!self.realFileURL) {
            self.realFileURL = [FDownloadTools replacehHomeDirectoryForFileURL:_fileURL];
        }
        return self.realFileURL;
    } else {
        return _fileURL;
    }
}

- (BOOL)fileIsValid
{
    NSInteger fileSize = [FDownloadTools sizeWithFileURL:self.fileURL];
    if (fileSize > 0 && fileSize >= self.totalBytesExpectedToWrite) {
        return YES;
    }
    return NO;
}

- (float)progress
{
    if (self.totalBytesExpectedToWrite <= 0 || self.totalBytesWritten <= 0) {
        return 0;
    } else {
        return self.totalBytesWritten / (self.totalBytesExpectedToWrite * 1.0f);
    }
}

@end
