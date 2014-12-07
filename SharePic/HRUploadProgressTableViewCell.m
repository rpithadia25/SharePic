//
//  HRUploadProgressTableViewCell.m
//  SharePic
//
//  Created by Harsh Shah on 12/5/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRUploadProgressTableViewCell.h"

@implementation HRUploadProgressTableViewCell
@synthesize accountImage = _accountImage;
@synthesize uploadProgress = _uploadProgress;
@synthesize errorLabel = _errorLabel;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
