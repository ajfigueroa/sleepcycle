//
//  LightTheme.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/31/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//
//  The class is a semi-abstract method that should only be subclassed
//  Hence, the implementations for the <Theme> protocol are unimplemented and
//  must be done so by the child class.
//  The methods that are unimplemented are those that do not deal with theming of the
//  the nav and status bar

#import "LightTheme.h"

@implementation LightTheme

- (void)themeNavigationBar:(UINavigationBar *)navBar
{
    // Theme the navigation bar to conform to the Light content
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)themeViewBackground:(UIView *)view
{
    NSString *assertionMessage = [NSString stringWithFormat:@"%s: This is an abstract method and should be overridden", __PRETTY_FUNCTION__];
    NSAssert(NO, assertionMessage);
}

- (void)themeStatusBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
