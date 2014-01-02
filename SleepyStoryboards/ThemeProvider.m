//
//  ThemeProvider.m
//  SleepCycleSeven
//
//  Created by Alexander Figueroa on 12/23/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import "ThemeProvider.h"
#import "BlueBeigeTheme.h"
#import "BlackGrayTheme.h"
#import "RedRoseTheme.h"

static NSMutableDictionary *themeDictionary;

@implementation ThemeProvider

+ (id <Theme>)theme
{
    // Grab theme name for user defaults
    NSInteger themeSelection = [[NSUserDefaults standardUserDefaults] integerForKey:AFAppTheme];
    
    // Grab the theme
    id <Theme> theme = [themeDictionary objectForKey:[@(themeSelection) stringValue]];
    
    if (!themeDictionary){
        // Lazy initialize dict if non-existent
        themeDictionary = [[NSMutableDictionary alloc] init];
    }
    
    if (!theme){
        // Apply appropriate theme
        switch (themeSelection) {
            case AFBlueBeigeTheme:
                theme = [[BlueBeigeTheme alloc] init];
                break;
            case AFBlackGrayTheme:
                theme = [[BlackGrayTheme alloc] init];
                break;
            case AFRedRoseTheme:
                theme = [[RedRoseTheme alloc] init];
                break;
            default:
                // Use default theme
                NSLog(@"Default theme called in %s", __PRETTY_FUNCTION__);
                theme = [[BlueBeigeTheme alloc] init];
                break;
        }
        
        [themeDictionary setValue:theme forKey:[@(themeSelection) stringValue]];
    }
    
    return theme;
}

@end
