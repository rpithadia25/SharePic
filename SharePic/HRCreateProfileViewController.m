//
//  HRCreateProfileViewController.m
//  SharePic
//
//  Created by Rakshit Pithadia on 12/3/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRCreateProfileViewController.h"
#import "HRConstants.h"
#define kSectionProfileName 0
#define kSectionSelectAccounts 1

@interface HRCreateProfileViewController () {
    NSArray *supportedAccounts;
}

@end

@implementation HRCreateProfileViewController
@synthesize delegate = _delegate;
@synthesize selectedAccounts = _selectedAccounts;

-(void) callBackDelegate: (id <HRCreateProfileDelegate>) delegate {
    _delegate = delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = HRCreateProfileTitle;
    _tableView.scrollEnabled = NO;
    _profile = [[HRProfile alloc]init];
    _profileNameField.delegate = self;
    _tableView.allowsMultipleSelection = YES;
    supportedAccounts = [HRAbstractAccount supportedAccounts];
    _selectedAccounts = [[NSMutableArray alloc]init];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kSectionProfileName) {
        return 1;
    }
    if (section == kSectionSelectAccounts) {
        return 2;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == kSectionProfileName) {
        return HRProfileName;
    }
    if(section == kSectionSelectAccounts) {
        return HRSelectAccounts;
    }
    return nil;
}
    
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == kSectionProfileName) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HRProfileNameCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HRProfileNameCellIdentifier];
        }
        CGRect screenRect = [[UIScreen mainScreen]bounds];
        _profileNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, screenRect.size.width - 10, 45)];
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
        cell.textLabel.text = [supportedAccounts[indexPath.row] description];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == kSectionSelectAccounts) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [_selectedAccounts addObject:supportedAccounts[indexPath.row]];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [_selectedAccounts removeObject:supportedAccounts[indexPath.row]];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(IBAction)saveButtonPressed {
    NSString *profileName = _profileNameField.text;
    if ([profileName length] != 0 && [_selectedAccounts count] != 0) {
        _profile.profileName = _profileNameField.text;
        _profile.accounts = [NSArray arrayWithArray:_selectedAccounts];
        [self.delegate HRCreateProfileViewWasDismissedWithProfile: _profile];
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([profileName length] == 0) {
        UIAlertView *profileNameFieldIsBlankAlert = [[UIAlertView alloc]initWithTitle:@"" message:HRProfileNameTextFieldIsBlankAlertMessage delegate:nil cancelButtonTitle:HRStringOk otherButtonTitles:nil , nil];
        [profileNameFieldIsBlankAlert show];
    } else {
        UIAlertView *noAccountSelectedAlert = [[UIAlertView alloc]initWithTitle:@"" message:HRNoAccountSelectedAlertMessage delegate:nil cancelButtonTitle:HRStringOk otherButtonTitles:nil , nil];
        [noAccountSelectedAlert show];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [_profileNameField resignFirstResponder];
    return NO;
}

@end
