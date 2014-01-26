//
//  SettingsAPI.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/24/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//
//  SettingsAPI is making use of the Facade Pattern to handle all setting related
//  state changes

#import <Foundation/Foundation.h>

@interface SettingsAPI : NSObject

// Interface for Settings properties of the same name
@property (nonatomic, assign) NSInteger timeToFallAsleep;
@property (nonatomic, assign) NSInteger appTheme;
@property (nonatomic, assign) BOOL showBorder;
@property (nonatomic, assign) BOOL showEasterEgg;

+ (instancetype)sharedSettingsAPI;

- (NSString *)appThemeName;
- (void)setAppThemeName:(NSString *)newAppThemeName;
- (NSArray *)themeNames;
- (void)saveAllSettings;

@end
