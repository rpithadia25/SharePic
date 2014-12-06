//
//  HRProfile.m
//  SharePic
//
//  Created by Rakshit Pithadia on 12/2/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRProfile.h"

@implementation HRProfile

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.profileName forKey:@"profileName"];
    [aCoder encodeObject:self.accounts forKey:@"accounts"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.profileName = [aDecoder decodeObjectForKey:@"profileName"];
        self.accounts = [aDecoder decodeObjectForKey:@"accounts"];
    }
    return self;
}

@end
