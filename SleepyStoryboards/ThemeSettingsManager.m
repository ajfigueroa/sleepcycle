//
//  ThemeSettingsManager.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "ThemeSettingsManager.h"
#import "SettingsSelectionConstants.h"
#import "SettingsManager.h"

@interface ThemeSettingsManager ()

// Maps the indices (AFThemeSelectionOption) as a string to the themes
@property (nonatomic, strong) NSMutableDictionary *themeIndexDictionary;

@end

@implementation ThemeSettingsManager

- (instancetype)init
{
    self = [super init];
    
    if (self && !self.themeIndexDictionary)
        self.themeIndexDictionary = [self buildThemeIndexDictionary];
    
    return self;
}

#pragma mark - Helper Function
- (NSMutableDictionary *)buildThemeIndexDictionary
{
    NSMutableDictionary *themeDictionary = [NSMutableDictionary dictionary];
    
    // Map the string version of indices to theme name values
    for (int i = 0; i < AFAvailableThemesCount; i++)
    {
        [themeDictionary setObject:[self themeNameForIndex:i] forKey:[@(i) stringValue]];
    }
    
    return themeDictionary;
}

- (NSString *)themeNameForIndex:(AFThemeSelectionOption)option
{
    // Get the readable representation of the themes
    switch (option) {
        case AFThemeSelectionOptionBlueBeigeTheme:
            return NSLocalizedString(@"Default", nil);
            break;
            
        case AFThemeSelectionOptionBlackGrayTheme:
            return NSLocalizedString(@"Dark", nil);
            break;
        
        case AFThemeSelectionOptionRedRoseTheme:
            return NSLocalizedString(@"Red Rose", nil);
            break;
        
        default:
            return @"";
            break;
    }
}

#pragma mark - Theme Settings Protocol Methods
- (NSString *)getDefaultApplicationTheme
{
    // Access the user defaults selected theme from the NSUserDefaults
    AFThemeSelectionOption option = (AFThemeSelectionOption)[[SettingsManager sharedSettings] appTheme];
    
    return (NSString *)[self.themeIndexDictionary objectForKey:[@(option) stringValue]];
}

- (void)setDefaultApplicationTheme:(NSString *)newThemeName
{
    // Find first key where newThemeName exists in themeIndexDictionary
    NSArray *validIndices = [self.themeIndexDictionary allKeysForObject:newThemeName];
    
    if (validIndices.count > 0)
    {
        // Update the default theme
        NSInteger option = [(NSString *)validIndices.firstObject integerValue];
        [[SettingsManager sharedSettings] setAppTheme:option];
        
        // Post Theme change notification
        [[NSNotificationCenter defaultCenter] postNotificationName:AFThemeHasChangedNotification object:nil];
    }
}

- (NSArray *)themeNamesSortedByIndex
{
    // Return all keys and sort alphabetically
    NSArray *sortedKeys = [[self.themeIndexDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *sortedValues = [NSMutableArray array];

    for (NSString *key in sortedKeys)
    {
        [sortedValues addObject:[self.themeIndexDictionary objectForKey:key]];
    }
    
    return (NSArray *)sortedValues;
}

@end
