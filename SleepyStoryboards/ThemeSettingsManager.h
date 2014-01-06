//
//  ThemeSettingsManager.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeSettingsManager : NSObject

// Current theme name
@property (nonatomic, strong) NSString *themeName;

- (NSString *)getDefaultApplicationTheme;
- (void)setDefaultApplicationTheme:(NSString *)newThemeName;
- (NSArray *)themeNamesSortedByIndex;


@end
