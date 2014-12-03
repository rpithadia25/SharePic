//
//  Constants.m
//  PhotoShareApp
//
//  Created by Rakshit Pithadia on 11/30/14.
//  Copyright (c) 2014 Rakshit Pithadia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRConstants.h"


NSString *const HRAlbumName = @"Album Name";
NSString *const HRAlbumDescription = @"Description";

NSString *const HRPatternCell = @"HRPatternCell";
NSString *const HRAlbumDescriptionCell = @"HRAlbumDescriptionCell";

NSString *const HRAlbumNamePlaceholder = @"Enter Album Name";
NSString *const HRAlbumDescriptionPlaceholder = @"Enter Description";

NSString *const HRAppName = @"SharePic";
NSString *const FlickrBaseAuthenticationURL = @"http://flickr.com/services/auth/?";
NSString *const FlickrApiKey = @"500422a15f9a413791a73c123d219b2a";
NSString *const FlickrPermission = @"write";
NSString *const FlickrSecretKey = @"4144818e19bd4ce4";
NSString *const FlickrMethodGetToken = @"flickr.auth.getToken";
NSString *const FlickrBaseApiRequestURL = @"http://flickr.com/services/rest/?";
NSString *const HRFlickrCallbackURL = @"SharePic://auth";

NSInteger const HRMaximumImageCount = 10;
BOOL const HRReturnOriginalImage = YES;
BOOL const HRReturnsImage = YES;
BOOL const HRDisplayOrder = YES;
NSInteger const HRTableViewRows = 2;
NSInteger const HRCollectionViewSections = 1;
NSInteger const HRImageViewTag = 100;
NSString *const HRProfileCell = @"ProfileCell";