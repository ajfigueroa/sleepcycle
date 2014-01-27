//
//  FSAlertView.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/27/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//
//  Credit goes to Wolfgang Schreurs stackoverflow.com/questions/11739832/two-uialertview-consecutively-in-didfinishlaunchingwithoptions

#import "FSAlertView.h"

@interface FSAlertView () <UIAlertViewDelegate>

@property (nonatomic, copy) void (^dismissHandler)(NSInteger buttonIndex);

@end

static BOOL currentlyPresenting;

@implementation FSAlertView

- (void)showWithDismissHandler:(void (^)(NSInteger buttonIndex))dismissHandler
{
    self.dismissHandler = dismissHandler;
    self.delegate = self;
    
    if (!currentlyPresenting)
        [self show];
        currentlyPresenting = YES;
}

// Alert View Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.dismissHandler)
            self.dismissHandler(buttonIndex);
    });
    
    currentlyPresenting = NO;
}

@end
