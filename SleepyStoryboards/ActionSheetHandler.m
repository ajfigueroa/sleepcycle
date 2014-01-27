//
//  ActionSheetHandler.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/27/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "ActionSheetHandler.h"
#import "SchedulerAPI.h"
#import "NSDate+SleepTime.h"

@interface ActionSheetHandler ()

@property (nonatomic, strong) NSArray *datePairs;

@end

@implementation ActionSheetHandler

- (void)actionSheetPresenter:(ActionSheetPresenter *)actionSheetPresenter
        clickedButtonAtIndex:(NSInteger)buttonIndex
              forActionSheet:(UIActionSheet *)actionSheet
                     withTag:(AFActionSheetTag)tag
                    andDates:(NSArray *)datePairs
{
    // The datePairs array should contain two dates.
    assert(datePairs.count == 2);
    
    if (buttonIndex != actionSheet.cancelButtonIndex)
        return;
    
    // Assign the date pair values
    self.datePairs = datePairs;
    
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
    NSDate *alarmTime = (NSDate *)self.datePairs[index];
    
    [[SchedulerAPI sharedScheduler] createAlarmNotificationForDate:[alarmTime zeroDateSeconds]];
}

#pragma mark - Reminder Preparation
- (void)performReminderActionForIndex:(AFActionSheetReminder)index
{
    // First zero seconds
    NSDate *reminderTargetTime = (NSDate *)self.datePairs[index];
    
    [[SchedulerAPI sharedScheduler] createReminderForDate:[reminderTargetTime zeroDateSeconds]];
}


@end
