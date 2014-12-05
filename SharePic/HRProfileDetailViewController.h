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
#import "HRAlbum.h"
#import "HRPatternViewCell.h"
#import "HRConstants.h"
#include "FlickrKit.h"
#import "HRProfile.h"
#import "HRAccountImageCell.h"
#import "AGImagePickerController.h"

@interface HRProfileDetailViewController : UIViewController <UINavigationControllerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DBRestClientDelegate, AGImagePickerControllerDelegate>

@property HRProfile                                     *currentProfile;
@property HRAlbum                                       *currentAlbum;
@property (strong, nonatomic) IBOutlet UICollectionView *gridView;
@property (strong, nonatomic) IBOutlet UITableView      *albumDescriptionTable;
@property (strong, nonatomic) IBOutlet UICollectionView *accountImageView;
@property (strong, nonatomic) IBOutlet UIButton         *selectImagesButton;

- (IBAction)launchPicker;
- (IBAction)uploadButtonPressed:(id)sender;

@end

