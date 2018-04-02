//
//  SettingsPersistencyManager.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/24/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsPersistencyManager : NSObject

// Setting States
@property (nonatomic, assign) NSInteger timeToFallAsleep;

@property (nonatomic, assign) NSInteger appTheme;

@property (nonatomic, assign) BOOL showBorder;

@property (nonatomic, assign) BOOL showEasterEgg;

@property (nonatomic, assign) BOOL showInfoAtLaunch;

@property (nonatomic, assign) BOOL appJustLaunched;

// Save all settings to local defaults
- (void)saveSettings;

@end
