//
//  FirstViewController.m
//  SharePic
//
//  Created by Harsh Shah on 11/30/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRProfileDetailViewController.h"
#import "AGIPCToolbarItem.h"
#import "HRFlickr.h"
#import "HRDropbox.h"
#import "HRUploadProgressViewController.h"

#define kHRImageViewTag 100
#define kHRAccountImageViewTag 101
#define kHRTableViewRows 2
#define kHRCollectionViewSections 1

@interface HRProfileDetailViewController () {
    AGImagePickerController *imagePicker;
    NSMutableArray *selectedPhotos;
}
@end

@implementation HRProfileDetailViewController
@synthesize currentAlbum = _currentAlbum;
@synthesize gridView = _gridView;
@synthesize albumDescriptionTable = _albumDescriptionTable;
@synthesize currentProfile = _currentProfile;
@synthesize accountImageView = _accountImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentAlbum = [HRAlbum new];
    _gridView.delegate = self;
    _accountImageView.delegate = self;
    _albumDescriptionTable.scrollEnabled = NO;
}

- (void)setProfile:(id)profile {
    if (_currentProfile != profile) {
        _currentProfile = profile;

        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (_currentProfile) {
        self.title = _currentProfile.profileName;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) agImagePickerController:(AGImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    HRPatternViewCell *cell = [[HRPatternViewCell alloc]init];
    CGRect workingFrame = _gridView.frame;
    workingFrame.origin.x = 0;

    for (UIView *v in [_gridView subviews]) {
        [v removeFromSuperview];
    }

    for(ALAsset *asset in info) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        UIImage *image = [UIImage imageWithCGImage:[representation fullResolutionImage]];
        [images addObject:[self compressForUpload:image :0.5]];
        [cell.patternImageView setContentMode:UIViewContentModeScaleAspectFit];
        cell.patternImageView.frame = workingFrame;
        [_gridView addSubview:cell.patternImageView];
        workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
    }
    _currentAlbum.photos = [images mutableCopy];
    [_gridView setPagingEnabled:YES];
    [_gridView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
    [_gridView reloadData];
}

- (UIImage *)compressForUpload:(UIImage *)original :(CGFloat)scale {
    // Calculate new size given scale factor.
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

- (IBAction)launchPicker {
    
    imagePicker = [[AGImagePickerController alloc]initWithDelegate:self];
    //TODO: For denoting maximum image count reached, try for buzzing(hmmm) effect.
    imagePicker.maximumNumberOfPhotosToBeSelected = HRMaximumImageCount;
    [self presentViewController:imagePicker animated:YES completion:nil];
    // Show saved photos on top
    imagePicker.shouldShowSavedPhotosOnTop = NO;
    imagePicker.shouldChangeStatusBarStyle = YES;
    imagePicker.selection = _currentAlbum.photos;
    
    // Custom toolbar items
    AGIPCToolbarItem *selectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"+ Select All" style:UIBarButtonItemStylePlain target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return YES;
    }];
    AGIPCToolbarItem *flexible = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] andSelectionBlock:nil];
    AGIPCToolbarItem *selectOdd = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"+ Select Odd" style:UIBarButtonItemStylePlain target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return !(index % 2);
    }];
    AGIPCToolbarItem *deselectAll = [[AGIPCToolbarItem alloc] initWithBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"- Deselect All" style:UIBarButtonItemStylePlain target:nil action:nil] andSelectionBlock:^BOOL(NSUInteger index, ALAsset *asset) {
        return NO;
    }];
    imagePicker.toolbarItemsForManagingTheSelection = @[selectAll, flexible, selectOdd, flexible, deselectAll];
    
}

#pragma mark Collection View Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return kHRCollectionViewSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (collectionView == _gridView) {
        return _currentAlbum.photos.count;
    } else {
        return _currentProfile.accounts.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == _gridView) {
        HRPatternViewCell *cell = (HRPatternViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HRPatternCell forIndexPath:indexPath];
        UIImageView *imageView = (UIImageView *) [cell viewWithTag:kHRImageViewTag];
        imageView.image = [_currentAlbum.photos objectAtIndex:indexPath.row];
        return cell;
    } else {
        HRAccountImageCell *cell = (HRAccountImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HRAccountCell forIndexPath:indexPath];
        UIImageView *imageView = (UIImageView *) [cell viewWithTag:kHRAccountImageViewTag];
        NSString *imageName = [_currentProfile.accounts[indexPath.row] imageName];
        imageView.image = [UIImage imageNamed:imageName];
        return cell;
    }
    return nil;
}

#pragma mark Album Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kHRTableViewRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HRAlbumDescriptionCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HRAlbumDescriptionCell];
    }
    
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    
    UITextField *albumDetailsTextField = [[UITextField alloc] initWithFrame:CGRectMake(150, 7, screenRect.size.width - 150, 30)];
    
    albumDetailsTextField.delegate = self;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    albumDetailsTextField.adjustsFontSizeToFitWidth = YES;
    if ([indexPath row] == 0) {
        albumDetailsTextField.placeholder = HRAlbumNamePlaceholder;
        albumDetailsTextField.keyboardType = UIKeyboardTypeDefault;
        albumDetailsTextField.returnKeyType = UIReturnKeyDone;
        albumDetailsTextField.tag = 0;
    }else{
        albumDetailsTextField.placeholder = HRAlbumDescriptionPlaceholder;
        albumDetailsTextField.keyboardType = UIKeyboardTypeDefault;
        albumDetailsTextField.returnKeyType = UIReturnKeyDone;
        albumDetailsTextField.tag = 1;
    }
    
    albumDetailsTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    albumDetailsTextField.clearButtonMode = UITextFieldViewModeAlways;
    [albumDetailsTextField setEnabled:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:albumDetailsTextField];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = HRAlbumName;
    } else {
        cell.textLabel.text = HRAlbumDescription;
    }
    if ([cell.textLabel.text isEqualToString:HRAlbumName]) {
        cell.detailTextLabel.text = _currentAlbum.name;
    }
    if ([cell.textLabel.text isEqualToString:HRAlbumDescription]) {
        cell.detailTextLabel.text = _currentAlbum.albumDescription;
    }
    
    return cell;
}

#pragma mark Touch methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self saveTextFields:textField];
}

-(void) saveTextFields: (UITextField *) textField {
    if (textField.tag == 0) {
        _currentAlbum.name = textField.text;
    } else {
        _currentAlbum.albumDescription = textField.text;
    }
}

#pragma mark IBActions

- (IBAction)uploadButtonPressed:(id)sender {
    if ([_currentAlbum.name length] != 0 && [_currentAlbum.albumDescription length] != 0) {
        HRUploadProgressViewController *progressUpdateViewController = [[UIStoryboard storyboardWithName:HRStoryboardMain bundle:nil] instantiateViewControllerWithIdentifier:HRUploadPregressStoryboardIdentifier];

        for (HRAbstractAccount *account in _currentProfile.accounts) {
            [account uploadPhotos:[_currentAlbum photos]];
            [account setDelegate:progressUpdateViewController];
        }
        
        [progressUpdateViewController setCurrentProfile:_currentProfile];
        [progressUpdateViewController setImageCount:[[_currentAlbum photos] count]];
        [self.navigationController pushViewController:progressUpdateViewController animated:YES];
    }
}
@end
