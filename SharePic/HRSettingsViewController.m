//
//  HRSettingsViewController.m
//  SharePic
//
//  Created by Harsh Shah on 12/3/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRSettingsViewController.h"
#import "HRAccount.h"
#import "HRConstants.h"
#import "HRFlickr.h"
#import "HRDropbox.h"

#define kFlickrSwitchTag 100
#define kDropboxSwitchTag 101

@interface HRSettingsViewController ()
@property NSArray *supportedAccounts;
@property HRFlickr *flickr;
@property HRDropbox *dropbox;
@end

@implementation HRSettingsViewController
@synthesize supportedAccounts = _supportedAccounts;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _supportedAccounts = [HRAccount supportedAccounts];
    self.flickr = [HRFlickr sharedFlickr];
    self.dropbox = [HRDropbox sharedDropbox];
    
    self.clearsSelectionOnViewWillAppear = NO;
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:HRClose style:UIBarButtonItemStyleDone target:self action:@selector(close:)];
    self.navigationItem.rightBarButtonItem = closeButton;
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
    NSString *account =_supportedAccounts[indexPath.row];
    
    if ([account isEqualToString:HRFlickrString]) {
        switchView.tag = kFlickrSwitchTag;
        if ([self.flickr isLoggedIn]) {
            switchView.on = YES;
        }
    } else if ([account isEqualToString:HRDropboxString]){
        switchView.tag = kDropboxSwitchTag;
        if ([self.dropbox isLoggedIn]) {
            switchView.on = YES;
        }
    }
    
    cell.textLabel.text = account;
    return cell;
}

- (void)stateChanged:(UISwitch *)sender {
    if (sender.tag == kFlickrSwitchTag) {
        if ([sender isOn]) {
            [self.flickr loginWithController:self];
        } else {
            [self.flickr logout];
        }
    } else if (sender.tag == kDropboxSwitchTag) {
        if ([sender isOn]) {
            [self.dropbox loginWithController:self];
        } else {
            [self.dropbox logout];
        }
    }
}

@end
