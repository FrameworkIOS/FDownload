//
//  AppDelegate.m
//  FDownloadIOS
//
//  Created by Apple on 20/11/21.
//

#import "AppDelegate.h"
#import <FDownload/FDownload.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(nonnull void (^)(void))completionHandler
{
    [FDownload handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];
}

@end
