//
//  SettingsPersistencyManager.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/24/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "SettingsPersistencyManager.h"

@implementation SettingsPersistencyManager

- (void)updateAllSettings
{
    _timeToFallAsleep = [self readIntegerValueForKey:AFTimeToFallAsleepInMinutes];
    _appTheme = [self readIntegerValueForKey:AFAppTheme];
    _showEasterEgg = [self readBoolValueForKey:AFShowEasterEgg];
    _showBorder = [self readBoolValueForKey:AFShowDatePickerBorder];
}

#pragma mark - NSUserDefaults Helpers
- (NSInteger)readIntegerValueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

- (void)writeIntegerToDefaultsValue:(NSInteger)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)readBoolValueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)writeBoolToDefaultsValue:(BOOL)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
