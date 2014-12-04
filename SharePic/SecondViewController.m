//
//  SecondViewController.m
//  SharePic
//
//  Created by Harsh Shah on 11/30/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "SecondViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "HRFlickr.h"

@interface SecondViewController ()
@property HRFlickr *flickr;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flickr = [HRFlickr sharedFlickr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)flickrLoginPressed:(id)sender {
    
}

- (IBAction)dropboxLoginPressed:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    } else {
        NSLog(@"Dropbox logged in");
    }
}

@end
