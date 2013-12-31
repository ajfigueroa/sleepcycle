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

@implementation BlueBeigeTheme
{}

#pragma mark - Theme protocol methods
- (void)themeViewBackground:(UIView *)view
{
    // Configure the background color
    view.backgroundColor = [UIColor eggshellColor];
}

- (void)themeNavigationBar:(UINavigationBar *)navBar
{
    // Theme the NavigationBar and Status Bar to the light theme.
    [super themeNavigationBar:navBar];
    [self themeStatusBar];
    
    // Set the navigation bar color
    [navBar configureFlatNavigationBarWithColor:[UIColor blueberryColor]];
}

@end
