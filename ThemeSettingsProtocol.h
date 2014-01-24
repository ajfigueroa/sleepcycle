//
//  ThemeSettingsProtocol.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/24/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ThemeSettingsProtocol <NSObject>

// Theme Accessor Methods
- (NSString *)getDefaultApplicationTheme;
- (void)setDefaultApplicationTheme:(NSString *)newThemeName;

// Sorting Theme Names
- (NSArray *)themeNamesSortedByIndex;

@end
