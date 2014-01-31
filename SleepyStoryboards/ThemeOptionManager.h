//
//  ThemeOptionManager.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/24/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

//  Responsible for managing the representation and data source methods of the Theme options

#import <Foundation/Foundation.h>

@interface ThemeOptionManager : NSObject

/**
 @brief Transforms the corresponding appThemeSelectionOption constant to a human readable string.
 This method name takes inspiration from __PRETTY_FUNCTION__.
 @param appThemeSelectionOption The AFThemeSelectionOption constant that represents the theme.
 @returns The human readable version of the theme's name.
 */
- (NSString *)prettyThemeName:(AFThemeSelectionOption)appThemeSelectionOption;

/**
 @brief Transforms a themeName to it's corresponding AFThemeSelectionOption constant
 @param themeName The NSString that represents the human readable version of the theme.
 @returns The AFThemeSelectionOption constant that corresponds to the themeName string.
 */
- (AFThemeSelectionOption)themeSelectionOptionForName:(NSString *)themeName;

/**
 @brief Creates and returns an array of human readable theme names sorted by their enumeration values.
 @returns An array of human readable theme names sorted by enumeration value (AFThemeSelectionOption).
 @sa AFThemeSelectionOption constants in SleepyTimeConstants.h
 */
- (NSArray *)themeNamesSortedByEnumeration;

@end
