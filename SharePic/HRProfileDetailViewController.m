//
//  FirstViewController.m
//  SharePic
//
//  Created by Harsh Shah on 11/30/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRProfileDetailViewController.h"

@interface HRProfileDetailViewController ()
@property (nonatomic, retain) FKImageUploadNetworkOperation *uploadOp;
@end

@implementation HRProfileDetailViewController
@synthesize currentAlbum = _currentAlbum;
@synthesize gridView = _gridView;
@synthesize chosenImages = _chosenImages;
@synthesize albumDescriptionTable = _albumDescriptionTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    _chosenImages = [NSMutableArray new];
    _currentAlbum = [HRAlbum new];
    _gridView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)launchPicker {
    
    ELCImagePickerController *imagePicker = [[ELCImagePickerController alloc] initImagePicker];
    //TODO: put everything in constants, remove comments
    
    imagePicker.maximumImagesCount = 10; //Set the maximum number of images to select to 10
    imagePicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    imagePicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    imagePicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
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
    
    _chosenImages = [images mutableCopy];
    
    [_gridView setPagingEnabled:YES];
    [_gridView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
    
    [_gridView reloadData];
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Collection View Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _chosenImages.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HRPatternViewCell *cell = (HRPatternViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HRPatternCell forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *) [cell viewWithTag:100];
    
    imageView.image = [_chosenImages objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark Album Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HRAlbumDescriptionCell];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HRAlbumDescriptionCell];
    }
    /////////////////
    UITextField *albumDetailsTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
    
    // [self.albumDetailsTextField addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
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

- (IBAction)uploadButtonPressed:(id)sender {
    if (![_currentAlbum.name length] == 0 && ![_currentAlbum.albumDescription length] == 0) {
        NSLog(@"%@",_currentAlbum.name);
        NSLog(@"%@",_currentAlbum.albumDescription);
        
        int imageNumber = 0;
        for (UIImage *image in _chosenImages) {
            NSString *imageTitle = [NSString stringWithFormat:@"Image %d", ++imageNumber];
            NSDictionary *uploadArgs = @{@"title": imageTitle, @"description": @"A Photo via Share-a-Pic App", @"is_public": @"0", @"is_friend": @"0", @"is_family": @"0", @"hidden": @"2"};
            
            self.uploadOp = [[FlickrKit sharedFlickrKit] uploadImage:image args:uploadArgs completion:^(NSString *imageID, NSError *error) {
                if (error) {
                    NSLog(@"Could not upload");
                } else {
                    NSString *msg = [NSString stringWithFormat:@"Uploaded image ID %@", imageID];
                    NSLog(@"%@ uploaded", msg);
                }
            }];
        }
    }
}


@end
