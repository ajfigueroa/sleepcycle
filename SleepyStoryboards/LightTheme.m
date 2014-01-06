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
#import "UINavigationBar+FlatUI.h"
#import "BOZPongRefreshControl.h"

@implementation LightTheme
{}

#pragma mark - Theme Protocol
- (void)themeNavigationBar:(UINavigationBar *)navBar
{
    // Theme the navigation bar to conform to the Light content
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    navBar.tintColor = [UIColor whiteColor];
    
    // Theme status bar for light content
    [self themeStatusBar];
    
    // Set the navigation bar color
    [navBar configureFlatNavigationBarWithColor:self.primaryColor];
}

- (void)themeViewBackground:(UIView *)view
{
    // Configure the background color
    view.backgroundColor = self.secondaryColor;
}

- (void)themeButton:(UIButton *)button withFont:(UIFont *)font
{
    button.backgroundColor = self.primaryColor;
    button.titleLabel.font = font;
    [button setTitleColor:self.textColor forState:UIControlStateNormal];
    [button setTitleColor:self.textColor forState:UIControlStateHighlighted];
}

- (void)themeLabel:(UILabel *)label withFont:(UIFont *)font
{
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.textColor;
    label.backgroundColor = [UIColor clearColor];
}

- (void)alternateThemeViewBackground:(UIView *)view
{
    // Configure view with alternate background cover
    view.backgroundColor = self.alternateSecondaryColor;
}

- (void)alternateThemeButton:(UIButton *)button withFont:(UIFont *)font
{
    button.backgroundColor = self.primaryColor;
    button.titleLabel.font = font;
    [button setTitleColor:self.alternateTextColor forState:UIControlStateNormal];
    [button setTitleColor:self.alternateTextColor forState:UIControlStateHighlighted];
}

- (void)themeRefreshControl:(UIView *)refreshControl
{
    BOZPongRefreshControl *pongRefreshControl = (BOZPongRefreshControl *)refreshControl;
    pongRefreshControl.foregroundColor = self.secondaryColor;
    pongRefreshControl.backgroundColor = self.primaryColor;
}

- (void)themeTableView:(UITableView *)tableView
{
    tableView.backgroundColor = self.primaryColor;
}

# pragma mark - Helper
- (void)themeStatusBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


@end
