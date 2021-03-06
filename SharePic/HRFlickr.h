//
//  HRFlickr.h
//  SharePic
//
//  Created by Harsh Shah on 12/3/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HRAbstractAccount.h"


@interface HRFlickr : HRAbstractAccount

+ (id)sharedFlickr;
- (void)completeLoginWithURL:(NSURL *)url;

@end
