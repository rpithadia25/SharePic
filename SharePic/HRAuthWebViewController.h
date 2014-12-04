//
//  HRAuthWebViewController.h
//  SharePic
//
//  Created by Harsh Shah on 12/4/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRAuthWebViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
+ (id)sharedAuthController;
- (void) completeFlickrAuthWithURL:(NSURL *)url;
@end
