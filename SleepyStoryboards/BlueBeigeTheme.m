//
//  BlueBeigeTheme.m
//  SleepCycleSeven
//
//  Created by Alexander Figueroa on 12/23/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "BlueBeigeTheme.h"
#import "UIColor+Colours.h"
#import "UINavigationBar+FlatUI.h"
#import "BOZPongRefreshControl.h"

@implementation BlueBeigeTheme
{}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.primaryColor = [UIColor blueberryColor];
        self.secondaryColor = [UIColor eggshellColor];
        self.textColor = [UIColor whiteColor];
        self.alternateSecondaryColor = [UIColor blueberryColor];
        self.alternateTextColor = [UIColor blackColor];
    }
    
    return self;
}

#pragma mark - Required Theme protocol methods
- (void)themeViewBackground:(UIView *)view
{
    // Configure the background color
    view.backgroundColor = self.secondaryColor;
}

- (void)themeNavigationBar:(UINavigationBar *)navBar
{
    // Theme the NavigationBar and Status Bar to the light theme.
    [super themeNavigationBar:navBar];
    [self themeStatusBar];
    
    // Set the navigation bar color
    [navBar configureFlatNavigationBarWithColor:self.primaryColor];
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

#pragma mark - Optional Theme Protocol Methods
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
    pongRefreshControl.foregroundColor = self.primaryColor;
    pongRefreshControl.backgroundColor = [UIColor black25PercentColor];
}

- (void)themeTableView:(UITableView *)tableView
{
    tableView.backgroundColor = [UIColor black25PercentColor];
}

@end
