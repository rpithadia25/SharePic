//
//  HRAccount.m
//  SharePic
//
//  Created by Rakshit Pithadia on 12/2/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRAbstractAccount.h"
#import "HRConstants.h"
#import "HRFlickr.h"
#import "HRDropbox.h"

#define mustOverride() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass", __PRETTY_FUNCTION__] userInfo:nil]

@implementation HRAbstractAccount

+(NSArray *)supportedAccounts {
    static NSArray *accounts;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accounts = @[[HRDropbox sharedDropbox],[HRFlickr sharedFlickr]];
    });
    return accounts;
}

- (BOOL)isLoggedIn {
    mustOverride();
}

- (void)loginWithController:(UIViewController *)viewController {
    mustOverride();
}

- (void)logout {
    mustOverride();
}

- (void)uploadPhotos:(NSArray *)photos {
    mustOverride();
}

- (NSString *) description {
    mustOverride();
}

- (NSString *)imageName {
    mustOverride();
}

#pragma mark User Defaults Encoder
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self forKey:[self description]];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self = [decoder decodeObjectForKey:[self description]];
    }
    return self;
}

@end
