//
//  AFThemeConstants.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/17/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#ifndef SleepyStoryboards_AFThemeConstants_h
#define SleepyStoryboards_AFThemeConstants_h

/**
 @brief The current number of available themes.
 */
static NSInteger const AFAvailableThemesCount = 3;

typedef NS_ENUM(NSInteger, AFThemeSelectionOption)
{
    /** The Blue and Beige color scheme, referred to as Default */
    AFThemeSelectionOptionBlueBeigeTheme,
    /** The Black and Gray color scheme, referrred to as Dark */
    AFThemeSelectionOptionBlackGrayTheme,
    /** The Red and Rose color scheme, referred to as Red Rose*/
    AFThemeSelectionOptionRedRoseTheme
};

#endif
