//
//  HRAccount.m
//  SharePic
//
//  Created by Rakshit Pithadia on 12/2/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRAccount.h"
#import "HRConstants.h"

@implementation HRAccount

+(NSArray *)supportedAccounts {
    static NSArray *accounts;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accounts = @[HRFlickr, HRDropbox];
    });
    return accounts;
}

@end
