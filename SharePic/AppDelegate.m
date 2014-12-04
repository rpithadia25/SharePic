//
//  AppDelegate.m
//  SharePic
//
//  Created by Harsh Shah on 11/30/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "AppDelegate.h"
#import "HRConstants.h"
#import "HRFlickr.h"
#import <DropboxSDK/DropboxSDK.h>
#import "HRSelectProfileViewController.h"
#import "HRAuthWebViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [HRFlickr sharedFlickr];
    //dropbox
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:HRDropBoxAppKey
                            appSecret:HRDropBoxAppSecret
                            root:kDBRootAppFolder]; 
    [DBSession setSharedSession:dbSession];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    HRSelectProfileViewController *mainController = (HRSelectProfileViewController *) self.window.rootViewController;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *defaultValues = [NSMutableArray arrayWithArray:mainController.profiles];
    [defaults setObject:[defaultValues objectAtIndex:0] forKey:HRUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
        }
        return YES;
    }
    
    if (NSOrderedSame == [[url scheme] caseInsensitiveCompare:HRAppName]) {
        [[HRAuthWebViewController sharedAuthController] completeFlickrAuthWithURL:url];
        return YES;
    }
    
    return NO;
}


@end
