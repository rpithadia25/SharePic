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
#import "HRAuthWebViewController.h"
#import "NSString_Extra.h"

@interface HRFlickr()
@property (nonatomic, retain) FKDUNetworkOperation *checkAuthOp;
@property (nonatomic, retain) FKDUNetworkOperation *authOp;
@property (nonatomic, retain) FKDUNetworkOperation *completeAuthOp;
@property (nonatomic, retain) FKDUNetworkOperation *uploadOp;
@end

@implementation HRFlickr
@synthesize uploadedImagesCount = _uploadedImagesCount, totalImages = _totalImages;
@synthesize delegate = _delegate;


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

- (void)loginWithController:(UIViewController *)viewController {
    HRAuthWebViewController *authView = [HRAuthWebViewController sharedAuthController];
    [viewController.navigationController pushViewController:authView animated:YES];
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

- (void)uploadPhotos:(NSArray *)photos {
    _totalImages = [photos count];
    _uploadedImagesCount = 0;
    int imageNumber = 0;
    NSString *date = [NSString dateTime];
    for (UIImage *image in photos) {
        NSString *imageTitle = [NSString stringWithFormat:@"%@_Image%d", date, ++imageNumber];
        NSDictionary *uploadArgs = @{@"title": imageTitle, @"description": @"A Photo via Share-a-Pic App", @"is_public": @"0", @"is_friend": @"0", @"is_family": @"0", @"hidden": @"2"};
        
        self.uploadOp = [[FlickrKit sharedFlickrKit] uploadImage:image args:uploadArgs completion:^(NSString *imageID, NSError *error) {
            if (error) {
                if (_delegate != nil) {
                    [_delegate errorUploadingImageToAccount:[self description]];
                }
            } else {
                _uploadedImagesCount++;
                if (_delegate != nil) {
                    if (_uploadedImagesCount == _totalImages) {
                        [_delegate uploadCompleteToAccount:[self description]];
                    } else {
                        [_delegate imageUploadedToAccount:[self description]];
                    }
                }
            }
        }];
    }
}

- (NSString *)description {
    return HRFlickrString;
}

- (NSString *)imageName {
    return [NSString stringWithFormat:@"%@.png", HRFlickrString];
}


@end