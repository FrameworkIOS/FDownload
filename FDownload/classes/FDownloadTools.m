//
//  FDownloadTools.m
//  FDownload
//
//  Created by Apple on 20/11/21.
//

#import "FDownloadTools.h"

static NSString * HomeDirectoryRegexPattern = @"(\\w*-){4}(\\w*)";

@implementation FDownloadTools

+ (NSString *)archiverDirectoryPath
{
    NSString * documentsPath = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject;
    NSString * archiverDirectoryPath = [documentsPath stringByAppendingPathComponent:@"SGDownloadArchive"];
    BOOL isDirectory;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:archiverDirectoryPath isDirectory:&isDirectory];
    if (!result || !isDirectory) {
        [[NSFileManager defaultManager] createDirectoryAtPath:archiverDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return archiverDirectoryPath;
}

+ (NSString *)archiverFilePathWithIdentifier:(NSString *)identifier
{
    return [[self archiverDirectoryPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archive", identifier]];
}

+ (NSString *)replacehHomeDirectoryForFilePath:(NSString *)filePath
{
    if (!fileURL) return nil;
    
    NSString * path = [self replacehHomeDirectoryForFilePath:fileURL.path]
    return [NSURL fileURLwithpath:path];
}

@end

