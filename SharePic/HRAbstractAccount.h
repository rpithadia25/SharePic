//
//  HRAccount.h
//  SharePic
//
//  Created by Rakshit Pithadia on 12/2/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HRAbstractAccount : NSObject
+ (NSArray *) supportedAccounts;
- (BOOL)isLoggedIn;
- (void)loginWithController:(UIViewController *)viewController;
- (void)logout;
- (void)uploadPhotos:(NSArray *)photos;
- (NSString *)description;
- (NSString *)imageName;

@end
