//
//  FirstViewController.h
//  SharePic
//
//  Created by Harsh Shah on 11/30/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <DropboxSDK/DropboxSDK.h>
#import "ELCImagePickerDemoAppDelegate.h"
#import "ELCImagePickerDemoViewController.h"
#import "HRAlbum.h"
#import "HRPatternViewCell.h"
#import "HRConstants.h"
#include "FlickrKit.h"

@interface HRProfileDetailViewController : UIViewController <ELCImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DBRestClientDelegate>

@property HRAlbum                                       *currentAlbum;
@property (strong, nonatomic) IBOutlet UICollectionView *gridView;
@property (strong, nonatomic) IBOutlet UITableView      *albumDescriptionTable;

- (IBAction)launchPicker;
- (IBAction)uploadButtonPressed:(id)sender;

@end

