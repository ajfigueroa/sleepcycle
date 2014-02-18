//
//  WebViewController.h
//  Hack
//
//  Created by Alexander Figueroa on 2013-10-13.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

/**
 @brief Initializes the WebViewController with the request URL
 @param requestURL The NSURL that the WebViewController is to load.
 @returns An instance of this view controller.
 */
- (instancetype)initWithRequestURL:(NSURL *)requestURL;

@end
