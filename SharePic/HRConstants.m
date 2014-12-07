//
//  Constants.m
//  PhotoShareApp
//
//  Created by Rakshit Pithadia on 11/30/14.
//  Copyright (c) 2014 Rakshit Pithadia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRConstants.h"


NSString *const HRPatternCell = @"HRPatternCell";

NSString *const HRAppName = @"SharePic";
NSString *const HRFlickrApiKey = @"500422a15f9a413791a73c123d219b2a";
NSString *const HRFlickrSecretKey = @"4144818e19bd4ce4";
NSString *const HRFlickrCallbackURL = @"SharePic://auth";

NSString *const HRDropBoxAppKey = @"l00snssp2vqeghc";
NSString *const HRDropBoxAppSecret = @"b1wyb12i1pbk2cl";

NSInteger const HRMaximumImageCount = 15;
BOOL const HRReturnOriginalImage = YES;
BOOL const HRReturnsImage = YES;
BOOL const HRDisplayOrder = YES;
NSInteger const HRImageViewTag = 100;
NSString *const HRProfileCell = @"ProfileCell";

NSString *const HRCreateProfileTitle = @"Create Profile";
NSString *const HRProfileName = @"Profile Name";
NSString *const HRSelectAccounts = @"Select Accounts";
NSString *const HRProfileNameCellIdentifier = @"ProfileName";
NSString *const HRProfileNameFieldPlaceholder = @"Enter Profile Name";

NSString *const HRFlickrString = @"Flickr";
NSString *const HRDropboxString = @"Dropbox";

NSString *const HRProfileDetailsSegueIdentifier = @"profileDetails";

NSString *const HRCreateProfileStoryBoardIdentifier = @"HRCreateProfile";
NSString *const HRStoryboardMain = @"Main";
NSString *const HRBackButtonLabel = @"Back";

NSString *const HRUserDefaultsKey = @"Profiles";

NSString *const HRAccountCell = @"HRAccountImageCell";

NSString *const HRSettingsCellIdentifier = @"SettingsCellIdentifier";
NSString *const HRSettingsStoryboardIdentifier = @"SettingsIdentifier";

NSString *const HRUploadPregressStoryboardIdentifier = @"UploadProgress";

NSString *const HRClose = @"Close";
NSString *const HRError = @"Error";
NSString *const HROk = @"Ok";
NSString *const HRRunInBackground = @"Hide";

NSString *const HRImagesUploaded = @"Images Uploaded, Click here.";

NSString *const HRDateTimeFormat = @"MM-dd-yy_HH:mm";

NSString *const HRUploadingTitle = @"Uploading...";
NSString *const HRUploadProgressCellIdentifier = @"UploadProgressCell";

NSString *const HRUploadProgressCellNib = @"HRUploadProgressTableViewCell";

NSString *const HRImagePickerAlertMessage = @"Please select only %lu images";
NSString *const HRImagePickerAlertTitle = @"Cannot select image";
NSString *const HRAlertCancelButton = @"Okay";

NSString *const HRProfileNameEncodeKey = @"profileName";
NSString *const HRAccountsEncodeKey = @"accounts";

NSString *const HRSettingsTitle = @"Manage Accounts";

NSString *const HRJSONKeyProfileName = @"profileName";
NSString *const HRJSONKeyAccountName = @"accountName";
NSString *const HRJSONKeyAccounts = @"accounts";

NSString *const HRMinimumImageCountAlertMessage = @"Please Select at least 1 image";
NSString *const HRUploadButtonAlertTitle = @"No images selected";

