//
//  SettingsAPI.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/24/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "SettingsAPI.h"
#import "SettingsPersistencyManager.h"

@interface SettingsAPI ()

@property (nonatomic, strong) SettingsPersistencyManager *persistencyManager;

@end

@implementation SettingsAPI

+ (instancetype)sharedSettingsAPI
{
    static SettingsAPI *sharedSettingsAPI = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSettingsAPI = [[SettingsAPI alloc] init];
    });
    
    return sharedSettingsAPI;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.persistencyManager = [[SettingsPersistencyManager alloc] init];
    }
    
    return self;
}

#pragma mark - Property Accessor Overrides
- (NSInteger)timeToFallAsleep
{
    return self.persistencyManager.timeToFallAsleep;
}

- (void)setTimeToFallAsleep:(NSInteger)timeToFallAsleep
{
    // Verify that the timeToFallAsleep is within the hour (60 minute) range
    assert(timeToFallAsleep >= 0 &&  timeToFallAsleep < 60);
    
    self.persistencyManager.timeToFallAsleep = timeToFallAsleep;
}

- (NSInteger)appTheme
{
    return self.persistencyManager.appTheme;
}

- (void)setAppTheme:(NSInteger)appTheme
{
    // Verify that the appTheme falls in range with valid appTheme enums
    assert(appTheme >= 0 && appTheme < AFAvailableThemesCount);
    
    self.persistencyManager.appTheme = appTheme;
}

- (BOOL)showBorder
{
    return self.persistencyManager.showBorder;
}

- (void)setShowBorder:(BOOL)showBorder
{
    self.persistencyManager.showBorder = showBorder;
}

- (BOOL)showEasterEgg
{
    return self.persistencyManager.showEasterEgg;
}

- (void)setShowEasterEgg:(BOOL)showEasterEgg
{
    self.persistencyManager.showEasterEgg = showEasterEgg;
}

#pragma mark - Persistency Methods
- (void)saveAllSettings
{
    // Call this method to confirm changes (will write to NSUserDefaults)
    [self.persistencyManager saveSettings];
}

@end
