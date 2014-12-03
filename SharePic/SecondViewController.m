//
//  SecondViewController.m
//  SharePic
//
//  Created by Harsh Shah on 11/30/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "SecondViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface SecondViewController ()
@property (nonatomic, retain) FKDUNetworkOperation *authOp;
@property (nonatomic, retain) FKDUNetworkOperation *checkAuthOp;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)flickrLoginPressed:(id)sender {
    
    self.checkAuthOp = [[FlickrKit sharedFlickrKit] checkAuthorizationOnCompletion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSLog(@"Flickr logged in");
            } else {
                // Begin the authentication process
                self.authOp = [[FlickrKit sharedFlickrKit] beginAuthWithCallbackURL:[NSURL URLWithString:HRFlickrCallbackURL] permission:FKPermissionWrite completion:^(NSURL *flickrLoginPageURL, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!error) {
                            [[UIApplication sharedApplication] openURL:flickrLoginPageURL];
                        } else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [alert show];
                        }
                    });
                }];

            }
        });		
    }];
    
}

- (IBAction)dropboxLoginPressed:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    } else {
        NSLog(@"Dropbox logged in");
    }
}

@end
