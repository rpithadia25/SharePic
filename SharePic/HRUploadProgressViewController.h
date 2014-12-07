//
//  HRUploadProgressViewController.h
//  SharePic
//
//  Created by Harsh Shah on 12/4/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRAbstractAccount.h"
#import "HRProfile.h"

@interface HRUploadProgressViewController : UITableViewController <HRUploadProgressNotificationDelegate, UITableViewDelegate>
@property HRProfile *currentProfile;
@property NSInteger imageCount;
@end
