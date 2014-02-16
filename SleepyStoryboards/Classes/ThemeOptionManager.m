//
//  ThemeOptionManager.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/24/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "ThemeOptionManager.h"

@interface ThemeOptionManager ()

// Maps the indices (AFThemeSelectionOption) as a string to the Theme's readable names
@property (nonatomic, strong) NSMutableDictionary *themeIndexDictionary;

@end

@implementation ThemeOptionManager

- (instancetype)init
{
    self = [super init];
    
    if (self && !self.themeIndexDictionary)
        self.themeIndexDictionary = [self buildThemeIndexDictionary];
    
    return self;
}

#pragma mark - Helpers
/**
 @brief Creates and maps the human readable versions of themeNames to their enumeration value as a string
 @note Creates dictionary of mapping: {enumerationAsString: themeName}
 @returns A NSMutableDictionary that contains the mapping of themeNames to their enumeration constants.
 */
- (NSMutableDictionary *)buildThemeIndexDictionary
{
    NSMutableDictionary *themeDictionary = [NSMutableDictionary dictionary];
    
    // Map the string version of indices to theme name values
    for (NSInteger i = 0; i < AFAvailableThemesCount; i++)
    {
        // Cast the integer value to an NSInteger and set the string version as they key
        NSString *key = [@(i) stringValue];
        NSString *obj = [self themeNameForIndex:i];
        
        themeDictionary[key] = obj;
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

#pragma mark - Theme Public Methods
- (NSString *)prettyThemeName:(AFThemeSelectionOption)appThemeSelectionOption
{
    NSString *key = [@(appThemeSelectionOption) stringValue];
    return (NSString *)self.themeIndexDictionary[key];
}

- (AFThemeSelectionOption)themeSelectionOptionForName:(NSString *)themeName
{
    // Find all the keys where themeName exists in themeIndexDictionary
    NSArray *validIndices = [self.themeIndexDictionary allKeysForObject:themeName];
    
    assert(validIndices.count > 0);
    
    // Returns the integer value of the index that corresponds to themeName
    return [(NSString *)validIndices.firstObject integerValue];
}

- (NSArray *)themeNamesSortedByEnumeration
{
    // Return an array of theme names sorted by their index (AFThemeSelectionOption)
    NSArray *sortedKeys = [self.themeIndexDictionary.allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *sortedValues = [NSMutableArray arrayWithCapacity:sortedKeys.count];
    
    [sortedKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        sortedValues[idx] = (NSString *)self.themeIndexDictionary[(NSString *)obj];
    }];
    
    return (NSArray *)sortedValues;
}

@end
