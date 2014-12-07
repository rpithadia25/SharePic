//
//  HRUploadProgressViewController.m
//  SharePic
//
//  Created by Harsh Shah on 12/4/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRUploadProgressViewController.h"
#import "HRConstants.h"
#import "HRUploadProgressTableViewCell.h"

@interface HRUploadProgressViewController()
@property float delta;
@property NSMutableArray *completedAccounts;
@property UIButton *doneButton;
@end

@implementation HRUploadProgressViewController
@synthesize currentProfile = _currentProfile;
@synthesize imageCount = _imageCount;
@synthesize delta = _delta;
@synthesize completedAccounts = _completedAccounts;
@synthesize doneButton = _doneButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.title = HRUploadingTitle;
    _completedAccounts = [[NSMutableArray alloc] init];
    _delta = (1.0 / _imageCount);
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_doneButton setTitle:@"Images Uploaded, Click here." forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(doneWithUpload:) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton sizeToFit];
    _doneButton.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneWithUpload:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_currentProfile.accounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // we wont be having more than 7 accounts its okay to create new cells everytime
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:HRUploadProgressCellNib owner:self options:nil];
    HRUploadProgressTableViewCell *cell = [nib objectAtIndex:0];
    
    HRAbstractAccount *account = _currentProfile.accounts[indexPath.row];
    NSString *imageName = [account imageName];
    UIImage *image = [UIImage imageNamed:imageName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.accountImage setImage:image];
    [cell.uploadProgress setProgress:0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSIndexPath *)findIndexPathForAccount:(NSString *)accountName {
    NSInteger section = 0;
    NSInteger row = 0;
    for (HRAbstractAccount *account in [_currentProfile accounts]) {
        if ([[account description] isEqualToString:accountName]) {
            break;
        }
        row++;
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _doneButton.center = footerView.center;
    [footerView addSubview:_doneButton];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100.0f;
}

#pragma mark - Upload progress notification methods
- (void)uploadCompleteToAccount:(NSString *)accountName {
    dispatch_async(dispatch_get_main_queue(), ^{
        HRUploadProgressTableViewCell *cell = (HRUploadProgressTableViewCell *)[self.tableView cellForRowAtIndexPath:[self findIndexPathForAccount:accountName]];
        [cell.uploadProgress setProgress:1.0 animated:YES];
        [_completedAccounts addObject:accountName];
        if ([self isUploadComplete]) {
            _doneButton.hidden = NO;
        }
    });
}

- (BOOL)isUploadComplete {
    if ([_completedAccounts count] == [_currentProfile.accounts count]) {
        return YES;
    }
    return NO;
}

- (void)imageUploadedToAccount:(NSString *)accountName {
    dispatch_async(dispatch_get_main_queue(), ^{
        HRUploadProgressTableViewCell *cell = (HRUploadProgressTableViewCell *)[self.tableView cellForRowAtIndexPath:[self findIndexPathForAccount:accountName]];
        
        float currentProgress = cell.uploadProgress.progress;
        [cell.uploadProgress setProgress:(currentProgress + _delta) animated:YES];
    });
}

- (void)errorUploadingImageToAccount:(NSString *)accountName {
    dispatch_async(dispatch_get_main_queue(), ^{
        HRUploadProgressTableViewCell *cell = (HRUploadProgressTableViewCell *)[self.tableView cellForRowAtIndexPath:[self findIndexPathForAccount:accountName]];
        cell.errorLabel.hidden = NO;
        [_completedAccounts addObject:accountName];
        cell.uploadProgress.progressTintColor = [UIColor redColor];
        [cell.uploadProgress setProgress:1.0 animated:YES];
        [_completedAccounts addObject:accountName];
        if ([self isUploadComplete]) {
            _doneButton.hidden = NO;
        }
    });
}

@end
