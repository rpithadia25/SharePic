//
//  HRFlickr.h
//  SharePic
//
//  Created by Harsh Shah on 12/3/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^completion)(BOOL isLoggedIn);

@interface HRFlickr : NSObject

+ (id)sharedFlickr;
//- (void)isLoggedInOnCompletion:(completion)completionHandler;
- (BOOL)isLoggedIn;
- (void)login;
- (void)completeLoginWithURL:(NSURL *)url;
- (void)logout;
@end
