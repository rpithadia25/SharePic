//
//  HRCreateProfileViewController.h
//  SharePic
//
//  Created by Rakshit Pithadia on 12/3/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRProfile.h"
#import "HRAccount.h"

@protocol HRCreateProfileDelegate
- (void)HRCreateProfileViewWasDismissedWithProfile: (HRProfile *) profile;
@end

@interface HRCreateProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>

-(void) callBackDelegate: (id <HRCreateProfileDelegate>) delegate;

@property id <HRCreateProfileDelegate> delegate;
@property HRProfile *profile;
@property (strong, nonatomic) IBOutlet UITextField *profileNameField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *selectedAccounts;

@end
