//
//  WebViewController.h
//  Hack
//
//  Created by Alexander Figueroa on 2013-10-13.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *forwardButton;

- (instancetype)initWithRequestURL:(NSURL *)requestURL;

@end
