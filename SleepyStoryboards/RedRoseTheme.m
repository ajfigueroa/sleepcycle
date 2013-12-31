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

#pragma mark - Theme protocol methods
- (void)themeViewBackground:(UIView *)view
{
    view.backgroundColor = [UIColor paleRoseColor];
}

- (void)themeNavigationBar:(UINavigationBar *)navBar
{
    // Theme the NavigationBar and Status Bar to the light theme.
    [super themeNavigationBar:navBar];
    [self themeStatusBar];
    
    // Set the navigation bar color
    [navBar configureFlatNavigationBarWithColor:[UIColor crimsonColor]];
}
@end
