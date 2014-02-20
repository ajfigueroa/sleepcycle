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
#import "IBActionSheet.h"

@interface ActionSheetHandler ()

@property (nonatomic, strong) NSArray *datePairs;

@end

@implementation ActionSheetHandler
{}

#pragma mark - ActionSheetPresenterDelegate Protocol
- (void)actionSheetPresenter:(ActionSheetPresenter *)actionSheetPresenter
        clickedButtonAtIndex:(NSInteger)buttonIndex
              forActionSheet:(IBActionSheet *)actionSheet
                     andInfo:(NSDictionary *)info
{
    // The info in this case should be a dictionary that contain two dates.
    assert(info.count == 2);
    
    if (actionSheet.hasCancelButton && buttonIndex == actionSheet.buttons.count - 1)
        return;
    
    switch (actionSheet.tag) {
        case AFActionSheetTagAlarm:
            // Assign the date pair values
            self.datePairs = @[info[@"Tomorrow"], info[@"Today"]];
            [self performAlarmActionForIndex:buttonIndex];
            break;
            
        case AFActionSheetTagReminder:
            self.datePairs = @[info[@"Today"], info[@"Tomorrow"]];
            [self performReminderActionForIndex:buttonIndex];
            break;
            
        default:
            NSLog(@"%s - Warning; Scheduler is running default case", __PRETTY_FUNCTION__);
            break;
        }
}

#pragma mark - Alarm Preparation
/**
 @brief Requests that the SchedulerAPI sets up an alarm for the time located at index, which corresponds
 to an AFActionSheetAlarm constant.
 @sa SchedulerAPI.h
 @param index The AFActionSheetAlarm constant that indicates which time to use off the Action Sheet
 */
- (void)performAlarmActionForIndex:(AFActionSheetAlarm)index
{
    // Zero the alarm seconds
    NSDate *alarmTime = (NSDate *)self.datePairs[index];
    
    [[SchedulerAPI sharedScheduler] createAlarmNotificationForDate:[alarmTime zeroedSeconds]];
}

#pragma mark - Reminder Preparation
/**
 @brief Requests that the SchedulerAPI sets up a reminder for the time located at index, which corresponds
 to an AFActionSheetReminder constant.
 @sa SchedulerAPI.h
 @param index The AFActionSheetReminder constant that indicates which time to use off the Action Sheet
 */
- (void)performReminderActionForIndex:(AFActionSheetReminder)index
{
    // First zero seconds
    NSDate *reminderTargetTime = (NSDate *)self.datePairs[index];
    
    [[SchedulerAPI sharedScheduler] createReminderForDate:[reminderTargetTime zeroedSeconds]];
}


@end
