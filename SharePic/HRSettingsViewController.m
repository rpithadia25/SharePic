//
//  HRSettingsViewController.m
//  SharePic
//
//  Created by Harsh Shah on 12/3/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRSettingsViewController.h"
#import "HRAbstractAccount.h"
#import "HRConstants.h"
#import "HRAbstractAccount.h"
#import "HRFlickr.h"
#import "HRDropbox.h"

@interface HRSettingsViewController ()
@property NSArray *supportedAccounts;
@end

@implementation HRSettingsViewController
@synthesize supportedAccounts = _supportedAccounts;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _supportedAccounts = [HRAbstractAccount supportedAccounts];
    
    self.clearsSelectionOnViewWillAppear = NO;
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:HRClose style:UIBarButtonItemStyleDone target:self action:@selector(close:)];
    self.navigationItem.rightBarButtonItem = closeButton;
    
    self.title = HRSettingsTitle;
}

- (void)close:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_supportedAccounts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HRSettingsCellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HRSettingsCellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    [switchView addTarget:self action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    
    cell.accessoryView = switchView;
    HRAbstractAccount *account = _supportedAccounts[indexPath.row];
    
    switchView.tag = indexPath.row;
    if ([account isLoggedIn]) {
        switchView.on = YES;
    }
    
    cell.textLabel.text = [account description];
    return cell;
}

- (void)stateChanged:(UISwitch *)sender {
    HRAbstractAccount *account = _supportedAccounts[sender.tag];
    if ([sender isOn]) {
        [account loginWithController:self];
    } else {
        [account logout];
    }
}

@end
