//
//  RedRoseTheme.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/31/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "RedRoseTheme.h"
#import "UIColor+Colours.h"
#import "UINavigationBar+FlatUI.h"

@implementation RedRoseTheme
{}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.primaryColor = [UIColor crimsonColor];
        self.secondaryColor = [UIColor paleRoseColor];
        self.textColor = [UIColor whiteColor];
    }
    
    return self;
}

#pragma mark - Theme protocol methods
- (void)themeViewBackground:(UIView *)view
{
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

@end
