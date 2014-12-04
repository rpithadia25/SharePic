//
//  HRAuthWebViewController.m
//  SharePic
//
//  Created by Harsh Shah on 12/4/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRAuthWebViewController.h"
#import "FlickrKit.h"
#import "HRFlickr.h"
#import "HRConstants.h"

@interface HRAuthWebViewController ()
@property (nonatomic, retain) FKDUNetworkOperation *authOp;
@end

@implementation HRAuthWebViewController
@synthesize webView = _webView;

+ (id)sharedAuthController {
    static HRAuthWebViewController *sharedAuthController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAuthController = [[self alloc] init];
    });
    return sharedAuthController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Begin the authentication process
    self.authOp = [[FlickrKit sharedFlickrKit] beginAuthWithCallbackURL:[NSURL URLWithString:HRFlickrCallbackURL] permission:FKPermissionWrite completion:^(NSURL *flickrLoginPageURL, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:flickrLoginPageURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
                [_webView loadRequest:urlRequest];
            } else {
                /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];*/
                NSLog(@"Error");
            }
        });		
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.authOp cancel];
    [super viewWillDisappear:animated];
}

- (void) completeFlickrAuthWithURL:(NSURL *)url {
    [[HRFlickr sharedFlickr] completeLoginWithURL:url];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Web View

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL];
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
        NSLog(@"%@", url);
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
            return NO;
        }
    }
    return YES;
}

@end
