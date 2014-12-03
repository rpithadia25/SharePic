//
//  HRProfileViewController.h
//  SharePic
//
//  Created by Rakshit Pithadia on 12/2/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRConstants.h"
#import "HRProfile.h"

@interface HRProfileViewController : UITableViewController

@property HRProfile *profile;
@property NSMutableArray *profiles;

@end
