//
//  SettingsManager.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/7/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//  Manage, read and write all the internal settings of the app.

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

// Internal Settings State
@property (nonatomic) NSInteger timeToFallAsleep;
@property (nonatomic) BOOL showBorder;
@property (nonatomic) BOOL showEasterEgg;
@property (nonatomic) NSInteger appTheme;

+ (instancetype)sharedSettings;

@end
