//
//  SettingsManager.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/7/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "SettingsManager.h"

@implementation SettingsManager

+ (instancetype)sharedSettings
{
    static SettingsManager *sharedSettings = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSettings = [[SettingsManager alloc] init];
    });
    
    return sharedSettings;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self updateAllSettings];
    }
    
    return self;
}

#pragma mark - Initializaiton
- (void)updateAllSettings
{
    _timeToFallAsleep = [self readIntegerValueForKey:AFTimeToFallAsleepInMinutes];
    _appTheme = [self readIntegerValueForKey:AFAppTheme];
    _showBorder = [self readBoolValueForKey:AFShowDatePickerBorder];
    _showEasterEgg = [self readBoolValueForKey:AFShowEasterEgg];
}

#pragma mark - NSUserDefaults helpers
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

- (BOOL)verfiyKey:(NSString *)key
{
    // Returns a bool indiciationg if the key is in the set of legal defaults keys
    NSSet *keySet = [[NSSet alloc] initWithArray:@[AFTimeToFallAsleepInMinutes, AFAppTheme, AFShowDatePickerBorder, AFShowEasterEgg]];
    return [keySet containsObject:key];
}

#pragma mark - Modified Accessor Methods
- (void)setTimeToFallAsleep:(NSInteger)timeToFallAsleep
{
    _timeToFallAsleep = timeToFallAsleep;
    [self writeIntegerToDefaultsValue:_timeToFallAsleep forKey:AFTimeToFallAsleepInMinutes];
}

- (void)setAppTheme:(NSInteger)appTheme
{
    _appTheme = appTheme;
    [self writeIntegerToDefaultsValue:_appTheme forKey:AFAppTheme];
}

- (void)setShowBorder:(BOOL)showBorder
{
    _showBorder = showBorder;
    [self writeBoolToDefaultsValue:_showBorder forKey:AFShowDatePickerBorder];
    
    // Due to this method affecting how the view will appear directly, post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:AFThemeHasChangedNotification object:nil];
}

- (void)setShowEasterEgg:(BOOL)showEasterEgg
{
    _showEasterEgg = showEasterEgg;
    [self writeBoolToDefaultsValue:_showEasterEgg forKey:AFShowEasterEgg];
}

#pragma mark - Public Methods
- (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    BOOL validKey = [self verfiyKey:defaultName];
    
    if (validKey)
    {
        // Write the value after confirming the key is valid
        [self writeBoolToDefaultsValue:value forKey:defaultName];
    }
}

@end
