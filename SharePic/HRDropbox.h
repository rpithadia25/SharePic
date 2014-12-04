//
//  HRDropbox.h
//  SharePic
//
//  Created by Harsh Shah on 12/3/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "HRConstants.h"

@interface HRDropbox : NSObject

+ (id)sharedDropbox;
- (BOOL)isLoggedIn;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)loginWithController:(UIViewController *)viewController;
- (void)logout;

@end
