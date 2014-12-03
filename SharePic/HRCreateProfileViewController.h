//
//  HRCreateProfileViewController.h
//  SharePic
//
//  Created by Rakshit Pithadia on 12/3/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRCreateProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
