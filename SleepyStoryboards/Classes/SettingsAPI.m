//
//  SettingsAPI.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/24/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "SettingsAPI.h"
#import "SettingsPersistencyManager.h"
#import "ThemeOptionManager.h"
#import "AFThemeConstants.h"
#import "AFNotificationConstants.h"

@interface SettingsAPI ()

@property (nonatomic, strong) SettingsPersistencyManager *persistencyManager;

@property (nonatomic, strong) ThemeOptionManager *themeOptionManager;

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
        self.themeOptionManager = [[ThemeOptionManager alloc] init];
    }
    
    return self;
}

#pragma mark - Persistency Property Accessor Overrides
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

// The AppTheme's enumeration
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

- (BOOL)showInfoAtLaunch
{
    return self.persistencyManager.showInfoAtLaunch;
}

- (void)setShowInfoAtLaunch:(BOOL)showInfoAtLaunch
{
    self.persistencyManager.showInfoAtLaunch = showInfoAtLaunch;
}

- (BOOL)appJustLaunched
{
    return self.persistencyManager.appJustLaunched;
}

- (void)setAppJustLaunched:(BOOL)appJustLaunched
{
    self.persistencyManager.appJustLaunched = appJustLaunched;
}

#pragma mark - Persistency Methods
- (void)saveAllSettings
{
    // Call this method to confirm changes (writes to NSUserDefaults)
    [self.persistencyManager saveSettings];
}

#pragma mark - ThemeOptionManager Methods
- (NSString *)appThemeName
{
    // The AppTheme enumeration's string representation
    return [self.themeOptionManager prettyThemeName:self.persistencyManager.appTheme];
}

- (void)setAppThemeName:(NSString *)newAppThemeName
{
    // Grab the enumeration of the string representation of the newAppThemeName
    // and store in persistencyManager as the enum value
    AFThemeSelectionOption themeSelectionOption = [self.themeOptionManager themeSelectionOptionForName:newAppThemeName];
    
    self.persistencyManager.appTheme = themeSelectionOption;
    
    // Post AFThemeHasChangedNotification
    [[NSNotificationCenter defaultCenter] postNotificationName:AFThemeHasChangedNotification object:nil];

}

- (NSArray *)themeNames
{
    // Grab the list of themeNames in their human readable form
    return [self.themeOptionManager themeNamesSortedByEnumeration];
}

@end
