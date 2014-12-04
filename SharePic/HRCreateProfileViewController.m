//
//  HRCreateProfileViewController.m
//  SharePic
//
//  Created by Rakshit Pithadia on 12/3/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRCreateProfileViewController.h"
#import "HRConstants.h"

@interface HRCreateProfileViewController ()

@end

@implementation HRCreateProfileViewController
@synthesize delegate = _delegate;


-(void) callBackDelegate: (id <HRCreateProfileDelegate>) delegate {
    _delegate = delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = HRCreateProfileTitle;
    _profile = [[HRProfile alloc]init];
    _profileNameField.delegate = self;
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kRowProfileName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kSectionProfileName;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return HRProfileName;
    }
    if(section == 1) {
        return HRSelectAccounts;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HRProfileNameCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HRProfileNameCellIdentifier];
        }
        CGRect screenRect = [[UIScreen mainScreen]bounds];
        _profileNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, screenRect.size.width - 10, 30)];
        _profileNameField.delegate = self;
        _profileNameField.adjustsFontSizeToFitWidth = YES;
        _profileNameField.placeholder = HRProfileNameFieldPlaceholder;
        _profileNameField.keyboardType = UIKeyboardTypeDefault;
        _profileNameField.returnKeyType = UIReturnKeyDone;
        _profileNameField.tag = 0;
        _profileNameField.clearButtonMode = UITextFieldViewModeAlways;
        _profileNameField.autocorrectionType = UITextAutocorrectionTypeNo;
        _profileNameField.clearButtonMode = UITextFieldViewModeAlways;
        [_profileNameField setEnabled:YES];
        [cell.contentView addSubview:_profileNameField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HRProfileNameCellIdentifier];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(IBAction)saveButtonPressed {
    NSString *profileName = _profileNameField.text;
    if (![profileName length] == 0) {
        _profile.profileName = _profileNameField.text;
        [self.delegate HRCreateProfileViewWasDismissedWithProfile: _profile];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
