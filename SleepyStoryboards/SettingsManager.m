//
//  SettingsManager.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "SettingsManager.h"

@interface SettingsManager ()

@property (nonatomic, strong) UITableView *settingsTableView;

@end

@implementation SettingsManager
{}

- (instancetype)initWithSettingsTableView:(UITableView *)tableView
{
    self = [super init];
    
    if (self)
    {
        self.settingsTableView = tableView;
    }
    
    return self;
}

@end
