//
//  HRDropbox.h
//  SharePic
//
//  Created by Harsh Shah on 12/3/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "HRConstants.h"
#import "HRAbstractAccount.h"

@interface HRDropbox : HRAbstractAccount

+ (id)sharedDropbox;
- (BOOL)handleOpenURL:(NSURL *)url;

@end
