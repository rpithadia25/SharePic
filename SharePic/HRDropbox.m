//
//  HRDropbox.m
//  SharePic
//
//  Created by Harsh Shah on 12/3/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRDropbox.h"
#import "NSString_Extra.h"

#define kCompressionQuality 0.8

@interface HRDropbox()
@property (nonatomic, strong) DBRestClient *restClient;
@end

@implementation HRDropbox
@synthesize uploadedImagesCount = _uploadedImagesCount, totalImages = _totalImages;
@synthesize delegate = _delegate;
@synthesize isError = _isError;


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
        self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        self.restClient.delegate = self;
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

- (void)uploadPhotos:(NSArray *)photos {
    _totalImages = [photos count];
    _uploadedImagesCount = 0;
    _isError = NO;
    int imageNumber = 0;
    NSString *date = [NSString dateTime];
    for (UIImage *image in photos) {
        NSData *data = UIImageJPEGRepresentation(image, kCompressionQuality);
        NSString *filename = [NSString stringWithFormat:@"%@_Image%d.jpeg", date, ++imageNumber];
        NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *localPath = [localDir stringByAppendingPathComponent:filename];
        [data writeToFile:localPath atomically:YES];
        NSString *destDir = @"/";
        [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
    }
}

-(NSString *)description {
    return HRDropboxString;
}

-(NSString *)imageName {
    return [NSString stringWithFormat:@"%@.png", HRDropboxString];
}

-(void)restClient:(DBRestClient*)client uploadProgress:(CGFloat)progress forFile:(NSString *)destPath from:(NSString *)srcPath {
    NSLog(@"Dropbox %.2f",progress);
}

#pragma mark - Dropbox upload call back methods

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    _uploadedImagesCount++;
    if (_delegate != nil) {
        if (_uploadedImagesCount == _totalImages) {
            [_delegate uploadCompleteToAccount:[self description]];
        } else {
            [_delegate imageUploadedToAccount:[self description]];
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!_isError) {
                if (_uploadedImagesCount == _totalImages) {
                    NSString *alertMessage = [NSString stringWithFormat:HRImageUploadSuccessAlert, [self description]];
                    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:nil cancelButtonTitle:HRStringOk otherButtonTitles:nil, nil];
                    [errorAlert show];
                }
            }
        });

    }
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    if (_delegate != nil) {
        _isError = YES;
        [_delegate errorUploadingImageToAccount:[self description]];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!_isError) {
                _isError = YES;
                NSString *alertMessage = [NSString stringWithFormat:HRImageUploadErrorAlert, [self description]];
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:nil cancelButtonTitle:HRStringOk otherButtonTitles:nil, nil];
                [errorAlert show];
            }
        });
    }
}

-(void)uploadInBackground {
    _delegate = nil;
}

@end
