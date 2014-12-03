//
//  Header.h
//  PhotoShareApp
//
//  Created by Harsh Shah on 10/24/14.
//  Copyright (c) 2014 Harsh Shah. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface HRAlbum : NSObject

@property NSString *name;
@property NSString *albumDescription;
@property NSMutableArray *photos;

@end