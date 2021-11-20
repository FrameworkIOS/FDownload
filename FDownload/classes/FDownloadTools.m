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
    
    return archiverDirectoryPath;
}

@end

