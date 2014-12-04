//
//  HRFlickr.m
//  SharePic
//
//  Created by Harsh Shah on 12/3/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRFlickr.h"
#import "FlickrKit.h"
#import "HRConstants.h"

@interface HRFlickr()
@property (nonatomic, retain) FKDUNetworkOperation *checkAuthOp;
@property (nonatomic, retain) FKDUNetworkOperation *authOp;
@property (nonatomic, retain) FKDUNetworkOperation *completeAuthOp;
@end

@implementation HRFlickr

+ (id)sharedFlickr {
    static HRFlickr *sharedFlickr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFlickr = [[self alloc] init];
    });
    return sharedFlickr;
}

- (id)init{
    if (self = [super init]) {
        [[FlickrKit sharedFlickrKit] initializeWithAPIKey:HRFlickrApiKey sharedSecret:HRFlickrSecretKey];
        self.checkAuthOp = [[FlickrKit sharedFlickrKit] checkAuthorizationOnCompletion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
            // just a call to initialize FlickKit
        }];
    }
    return self;
}

- (BOOL)isLoggedIn {
    return [FlickrKit sharedFlickrKit].isAuthorized;
}

- (void)login {
    self.authOp = [[FlickrKit sharedFlickrKit] beginAuthWithCallbackURL:[NSURL URLWithString:HRFlickrCallbackURL] permission:FKPermissionWrite completion:^(NSURL *flickrLoginPageURL, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [[UIApplication sharedApplication] openURL:flickrLoginPageURL];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:HRError message:error.localizedDescription delegate:nil cancelButtonTitle:HROk otherButtonTitles: nil];
                [alert show];
            }
        });
    }];
}

- (void)completeLoginWithURL:(NSURL *)url {
    self.completeAuthOp = [[FlickrKit sharedFlickrKit] completeAuthWithURL:url completion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSLog(@"Flickr %@ Logged in", userName);
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:HRError message:error.localizedDescription delegate:nil cancelButtonTitle:HROk otherButtonTitles: nil];
                [alert show];
            }
        });
    }];
}

- (void)logout {
    [[FlickrKit sharedFlickrKit] logout];
}

@end