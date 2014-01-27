//
//  ActionSheetHandler.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/27/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "ActionSheetHandler.h"
#import "SchedulerAPI.h"

@implementation ActionSheetHandler

- (void)actionSheetPresenter:(ActionSheetPresenter *)actionSheetPresenter
        clickedButtonAtIndex:(NSInteger)buttonIndex
              forActionSheet:(UIActionSheet *)actionSheet
                     withTag:(AFActionSheetTag)tag
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
        return;
    
    switch (actionSheet.tag) {
        case AFActionSheetTagAlarm:
            [self performAlarmActionForIndex:buttonIndex];
            break;
            
        case AFActionSheetTagReminder:
            [self performReminderActionForIndex:buttonIndex];
            break;
            
        default:
            NSLog(@"%s: %@", __PRETTY_FUNCTION__, @"Default case");
            break;
        }
}

#pragma mark - Alarm Preparation
- (void)performAlarmActionForIndex:(AFActionSheetAlarm)index
{
    // Zero the alarm seconds
    NSDate *alarmTime = self.alarmTime;
    
    if (index == AFActionSheetAlarmTomorrow)
        alarmTime = [self.alarmTime dateByAddingTimeInterval:HOURS_AS_SECONDS(24)];
    
    [self addAlarmForTime:[alarmTime zeroDateSeconds]];
}

@end
