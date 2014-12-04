//
//  HRProfileViewController.h
//  SharePic
//
//  Created by Rakshit Pithadia on 12/2/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRConstants.h"
#import "HRCreateProfileViewController.h"

@interface HRProfileViewController : UITableViewController<HRCreateProfileDelegate>

@property NSMutableArray *profiles;
- (IBAction)settingsButtonPressed:(id)sender;

@end
