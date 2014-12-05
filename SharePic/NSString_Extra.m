//
//  NSString_Extra.m
//  SharePic
//
//  Created by Harsh Shah on 12/4/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "NSString_Extra.h"
#import "HRConstants.h"

@implementation NSString (NSString_Extra)

+ (NSString *)dateTime {
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:HRDateTimeFormat];
    
    dateString = [formatter stringFromDate:[NSDate date]];

    return dateString;
}

@end
