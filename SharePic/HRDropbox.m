//
//  HRDropbox.m
//  SharePic
//
//  Created by Harsh Shah on 12/3/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRDropbox.h"

@implementation HRDropbox

+ (id)sharedDropbox {
    
    static HRDropbox *sharedDropbox = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDropbox = [[self alloc] init];
    });
    return sharedDropbox;
}

-(id) init {
    if (self = [super init]) {
        DBSession *dbSession = [[DBSession alloc]
                                initWithAppKey:HRDropBoxAppKey
                                appSecret:HRDropBoxAppSecret
                                root:kDBRootAppFolder];
        [DBSession setSharedSession:dbSession];
    }
    return self;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [[DBSession sharedSession] handleOpenURL:url];
}

- (BOOL)isLoggedIn {
    return [[DBSession sharedSession] isLinked];
}

- (void)loginWithController:(UIViewController *)viewController {
    [[DBSession sharedSession] linkFromController:viewController];
}

- (void)logout {
    [[DBSession sharedSession] unlinkAll];
}

@end
