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

static NSMutableDictionary *themeDictionary;

@implementation ThemeProvider

+ (id <Theme>)theme
{
    // Grab theme name for user defaults
    NSString *themeName = [[NSUserDefaults standardUserDefaults] valueForKey:kAppTheme];
    
    // Grab the theme
    id <Theme> theme = [themeDictionary objectForKey:themeName];
    
    if (!themeDictionary){
        // Lazy initialize dict if non-existent
        themeDictionary = [[NSMutableDictionary alloc] init];
    }
    
    if (!theme){
        // Apply appropriate theme
        if ([themeName isEqualToString:kBlueBeigeTheme]){
            theme = [[BlueBeigeTheme alloc] init];
        }
        else if ([themeName isEqualToString:kBlackGrayTheme]){
            theme = [[BlackGrayTheme alloc] init];
        }
        else{
            // Use default theme
            NSLog(@"Default theme called in %s", __PRETTY_FUNCTION__);
            theme = [[BlueBeigeTheme alloc] init];
        }
        
        [themeDictionary setValue:theme forKey:themeName];
    }
    
    return theme;
}

@end
