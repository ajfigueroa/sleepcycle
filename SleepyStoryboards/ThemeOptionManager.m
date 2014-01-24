//
//  ThemeOptionManager.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/24/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "ThemeOptionManager.h"

@interface ThemeOptionManager ()

// Maps the indicies (AFThemeSelectionOption) as a string to the Theme's readable names
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
- (NSMutableDictionary *)buildThemeIndexDictionary
{
    
}


@end
