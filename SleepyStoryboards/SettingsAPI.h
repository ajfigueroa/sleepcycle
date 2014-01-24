//
//  SettingsAPI.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/24/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//
//  SettingsAPI is making use of the Facade Pattern to handle all setting related
//  state changes

#import <Foundation/Foundation.h>

@interface SettingsAPI : NSObject

// Interface for Settings properties of the same name
@property (nonatomic) NSInteger timeToFallAsleep;
@property (nonatomic) NSInteger appTheme;
@property (nonatomic) BOOL showBorder;
@property (nonatomic) BOOL showEasterEgg;

+ (instancetype)sharedSettingsAPI;

- (void)saveAllSettings;

@end
