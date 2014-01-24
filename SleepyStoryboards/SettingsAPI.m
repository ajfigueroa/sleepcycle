//
//  SettingsAPI.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/24/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "SettingsAPI.h"
#import "SettingsPersistencyManager.h"

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




@end
