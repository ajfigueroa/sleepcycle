//
//  ThemeFactory.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/21/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

// The ThemeFactory to provide themes to our view controller objects

#import <Foundation/Foundation.h>
#import "Theme.h"
#import "AFThemeConstants.h"

@interface ThemeFactory : NSObject

/**
 @brief Returns the current application's shared theme factory
 @sa Theme protocol in Theme.h
 @returns The current application's shared theme factory
 */
+ (instancetype)sharedThemeFactory;

/**
 @brief Asks the sharedThemeFactory to build a Theme object that corresponds to
 the themeKey constant provided.
 @param themeKey The AFThemeSelectionOption constant that corresponds to the desired theme.
 @sa AFThemeSelectionOption constants
 @returns An object that conforms to the Theme protocol to be used for theming UIControls and UIViews. Returns nil if themeKey is not valid.
 */
- (id <Theme>)buildThemeForKey:(AFThemeSelectionOption)themeKey;

/**
 @brief Asks the sharedThemeFactory to build a Theme object based off the persistent themeKey constant in NSUserDefaults.
 @returns An object that conforms to the Theme protocol to be used for theming UIControls and UIViews. Returns nil if the provided themeKey is not valid since this method calls: -[ThemeFactory buildThemeForKey:themeKey];
 */
- (id <Theme>)buildThemeForSettingsKey;

@end
