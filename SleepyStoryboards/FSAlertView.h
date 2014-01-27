//
//  FSAlertView.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/27/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//
//  Custom Alert View implementation to be able to maintain isPresenting state

#import <UIKit/UIKit.h>

@interface FSAlertView : UIAlertView

- (void)showWithDismissHandler:(void (^)(NSInteger buttonIndex))dismissHandler;

@end
