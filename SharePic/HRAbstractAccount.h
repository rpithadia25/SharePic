//
//  HRAccount.h
//  SharePic
//
//  Created by Rakshit Pithadia on 12/2/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HRUploadProgressNotificationDelegate <NSObject>
- (void)imageUploadedToAccount:(NSString *)accountName;
- (void)uploadCompleteToAccount:(NSString *)accountName;
- (void)errorUploadingImageToAccount:(NSString *)accountName;
@end

@interface HRAbstractAccount : NSObject

@property NSInteger totalImages;
@property NSInteger uploadedImagesCount;
@property id <HRUploadProgressNotificationDelegate> delegate;
@property BOOL isError;

+ (NSArray *) supportedAccounts;
- (BOOL)isLoggedIn;
- (void)loginWithController:(UIViewController *)viewController;
- (void)logout;
- (void)uploadPhotos:(NSArray *)photos;
- (NSString *)description;
- (NSString *)imageName;
- (void)uploadInBackground;
- (NSDictionary *) toNSDistionary;

@end
