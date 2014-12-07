//
//  HRUploadProgressTableViewCell.h
//  SharePic
//
//  Created by Harsh Shah on 12/5/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRUploadProgressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *accountImage;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgress;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end
