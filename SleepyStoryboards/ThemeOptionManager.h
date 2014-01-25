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

// Methods for comprehending theme options
- (NSString *)prettyThemeName:(AFThemeSelectionOption)appThemeSelectionOption;
- (AFThemeSelectionOption)themeSelectionOptionForName:(NSString *)themeName;

// Sorted theme names (by AFThemeSelectionOption)
- (NSArray *)themeNamesSortedByEnumeration;

@end
