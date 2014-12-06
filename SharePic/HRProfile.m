//
//  HRProfile.m
//  SharePic
//
//  Created by Rakshit Pithadia on 12/2/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRProfile.h"
#import "HRConstants.h"

@implementation HRProfile

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.profileName forKey:HRProfileNameEncodeKey];
    [aCoder encodeObject:self.accounts forKey:HRAccountsEncodeKey];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.profileName = [aDecoder decodeObjectForKey:HRProfileNameEncodeKey];
        self.accounts = [aDecoder decodeObjectForKey:HRAccountsEncodeKey];
    }
    return self;
}

@end
