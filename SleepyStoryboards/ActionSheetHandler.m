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
