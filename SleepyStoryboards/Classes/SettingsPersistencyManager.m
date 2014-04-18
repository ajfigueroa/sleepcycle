//
//  SettingsPersistencyManager.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/24/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "SettingsPersistencyManager.h"
#import "AFUserDefaultKeyConstants.h"

@implementation SettingsPersistencyManager

- (instancetype)init
{
    self = [super init];
    
    // Read in all settings values upon initialization
    if (self)
        [self loadAllSettings];
    
    return self;
}

#pragma mark - Public Save Method
- (void)saveSettings
{
    [self commitAllSettings];
}

#pragma mark - Settings Read and Write
- (void)loadAllSettings
{
    // Read in all current values from NSUserDefaults
    _timeToFallAsleep = [self readIntegerValueForKey:AFTimeToFallAsleepInMinutes];
    _appTheme = [self readIntegerValueForKey:AFAppTheme];
    _showEasterEgg = [self readBoolValueForKey:AFShowEasterEgg];
    _showBorder = [self readBoolValueForKey:AFShowDatePickerBorder];
    _showInfoAtLaunch = [self readBoolValueForKey:AFShowInfoAtLaunch];
    _appJustLaunched = [self readBoolValueForKey:AFAppJustLaunched];
}

- (void)commitAllSettings
{
    // Write all settings to the NSUserDefaults
    [self writeIntegerToDefaultsValue:_timeToFallAsleep forKey:AFTimeToFallAsleepInMinutes];
    [self writeIntegerToDefaultsValue:_appTheme forKey:AFAppTheme];
    [self writeBoolToDefaultsValue:_showBorder forKey:AFShowDatePickerBorder];
    [self writeBoolToDefaultsValue:_showEasterEgg forKey:AFShowEasterEgg];
    [self writeBoolToDefaultsValue:_showInfoAtLaunch forKey:AFShowInfoAtLaunch];
    [self writeBoolToDefaultsValue:_appJustLaunched forKey:AFAppJustLaunched];
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
