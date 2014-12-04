//
//  HRFlickr.h
//  SharePic
//
//  Created by Harsh Shah on 12/3/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HRFlickr : NSObject

+ (id)sharedFlickr;
//- (void)isLoggedInOnCompletion:(completion)completionHandler;
- (BOOL)isLoggedIn;
- (void)loginWithController:(UIViewController *)viewController;
- (void)completeLoginWithURL:(NSURL *)url;
- (void)logout;
@end
