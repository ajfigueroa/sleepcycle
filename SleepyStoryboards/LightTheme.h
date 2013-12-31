//
//  LightTheme.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/31/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//
//  Provide the base class to use for themes that are light in theme (status + nav bar)

#import <Foundation/Foundation.h>
#import "Theme.h"

@interface LightTheme : NSObject <Theme>

// Primary refers to navigation bar color and buttons
@property (nonatomic, strong) UIColor *primaryColor;
// Secondary refers to background views
@property (nonatomic, strong) UIColor *secondaryColor;
@property (nonatomic, strong) UIColor *textColor;

// Theme the status bar, if it complements the navigation bar
- (void)themeStatusBar;

@end
