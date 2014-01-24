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
    if (self)
    {
        if (!self.themeIndexDictionary) {
            self.themeIndexDictionary = [self buildThemeIndexDictionary];
        }
        
        self.themeName = [self getDefaultApplicationTheme];
    }
    
    return self;
}

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
    // Access the user defaults selected theme
    AFThemeSelectionOption option = (AFThemeSelectionOption)[[SettingsManager sharedSettings] appTheme];
    
    return (NSString *)[self.themeIndexDictionary objectForKey:[@(option) stringValue]];
}

- (void)setDefaultApplicationTheme:(NSString *)newThemeName
{
    NSArray *validIndices = [self.themeIndexDictionary allKeysForObject:newThemeName];
    
    // If count is > 0, we'll set the first instance as the default theme
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
    NSArray *sortedKeys = [[self.themeIndexDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *sortedValues = [NSMutableArray array];
    
    for (NSString *key in sortedKeys)
    {
        [sortedValues addObject:[self.themeIndexDictionary objectForKey:key]];
    }
    
    return (NSArray *)sortedValues;
}

@end
