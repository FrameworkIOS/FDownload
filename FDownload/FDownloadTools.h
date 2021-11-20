//
//  FDownloadTools.h
//  FDownload
//
//  Created by Apple on 20/11/21.
//

#import <Foundation/Foundation.h>

@interface FDownloadTools : NSObject

+ (NSString *)archiverDirectoryPath;
+ (NSString *)archiverFilePathWithIdentifier:(NSString *)identifier;

+ (NSURL *)replacehHomeDirectoryForFileURL:(NSURL *)fileURL;
+ (NSString *)replacehHomeDirectoryForFilePath:(NSString *)filePath;

+ (NSInteger)sizeWithFileURL:(NSURL *)fileURL;
+ (NSError *)removeFileWithFileURL:(NSURL *)fileURL;

@end
