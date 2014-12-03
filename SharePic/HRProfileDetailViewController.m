//
//  FirstViewController.m
//  SharePic
//
//  Created by Harsh Shah on 11/30/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRProfileDetailViewController.h"
#define kOFFSET_FOR_KEYBOARD 80.0
@interface HRProfileDetailViewController ()
@property (nonatomic, retain) FKImageUploadNetworkOperation *uploadOp;
@end

@implementation HRProfileDetailViewController
@synthesize currentAlbum = _currentAlbum;
@synthesize gridView = _gridView;
@synthesize albumDescriptionTable = _albumDescriptionTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentAlbum = [HRAlbum new];
    _gridView.delegate = self;
    _albumDescriptionTable.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)launchPicker {
    
    ELCImagePickerController *imagePicker = [[ELCImagePickerController alloc] initImagePicker];
    
    imagePicker.maximumImagesCount = HRMaximumImageCount;
    imagePicker.returnsOriginalImage = HRReturnOriginalImage;
    imagePicker.returnsImage = HRReturnsImage;
    imagePicker.onOrder = HRDisplayOrder;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    imagePicker.imagePickerDelegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    HRPatternViewCell *cell = [[HRPatternViewCell alloc]init];
    
    for (UIView *v in [_gridView subviews]) {
        [v removeFromSuperview];
    }
    
    CGRect workingFrame = _gridView.frame;
    workingFrame.origin.x = 0;
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
                
                [cell.patternImageView setContentMode:UIViewContentModeScaleAspectFit];
                cell.patternImageView.frame = workingFrame;
                [_gridView addSubview:cell.patternImageView];
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                [images addObject:image];
                [cell.patternImageView setContentMode:UIViewContentModeScaleAspectFit];
                cell.patternImageView.frame = workingFrame;
                [_gridView addSubview:cell.patternImageView];
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Unknown asset type");
        }
    }
    
    _currentAlbum.photos = [images mutableCopy];
    
    [_gridView setPagingEnabled:YES];
    [_gridView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
    [_gridView reloadData];
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Collection View Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return HRCollectionViewSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _currentAlbum.photos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HRPatternViewCell *cell = (HRPatternViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HRPatternCell forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *) [cell viewWithTag:HRImageViewTag];
    imageView.image = [_currentAlbum.photos objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark Album Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return HRTableViewRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HRAlbumDescriptionCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HRAlbumDescriptionCell];
    }
    
    UITextField *albumDetailsTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
    
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
    }else{
        _currentAlbum.albumDescription = textField.text;
    }
}

#pragma mark IBActions

- (IBAction)uploadButtonPressed:(id)sender {
    if (![_currentAlbum.name length] == 0 && ![_currentAlbum.albumDescription length] == 0) {
        NSLog(@"%@",_currentAlbum.name);
        NSLog(@"%@",_currentAlbum.albumDescription);
        NSDictionary *uploadArgs = @{@"rakshit": @"Test Photo", @"description": @"A Test Photo via photoshareapp", @"is_public": @"0", @"is_friend": @"0", @"is_family": @"0", @"hidden": @"2"};
        self.uploadOp = [[FlickrKit sharedFlickrKit] uploadImage:[_currentAlbum.photos objectAtIndex:0] args:uploadArgs completion:^(NSString *imageID, NSError *error) {
            if (error) {
                NSLog(@"Could not upload");
            } else {
                NSString *msg = [NSString stringWithFormat:@"Uploaded image ID %@", imageID];
                NSLog(@"%@ uploaded", msg);
            }
        }];

    }
    
}

@end
