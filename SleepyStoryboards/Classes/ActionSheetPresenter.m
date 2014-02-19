//
//  ActionSheetPresenter.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/27/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "ActionSheetPresenter.h"
#import "NSDate+SleepTime.h"
#import "SettingsAPI.h"
#import "ThemeFactory.h"

#define MINUTES_AS_SECONDS(x) (x * 60)
#define HOURS_AS_SECONDS(x) (x * 60 * 60)

@interface ActionSheetPresenter ()

/**
 @brief The desired date to trigger the alarm or reminder at.
 */
@property (nonatomic, strong) NSDate *desiredScheduledTime;

/**
 @brief The pair of alarm times where the order of dates are: Tomorrow and Today.
*/
@property (nonatomic, strong) NSArray *alarmTimesPair;

/**
 @brief The pair of reminder times where the order of dates are: Today and Tomorrow
 */
@property (nonatomic, strong) NSArray *reminderTimesPair;

@end

@implementation ActionSheetPresenter
{}

#pragma mark - Action Sheet Methods
- (IBActionSheet *)buildActionSheetForState:(AFSelectedUserMode)state andDate:(NSDate *)date
{
    IBActionSheet *actionSheet;
    
    switch (state) {
        case AFSelectedUserModeCalculateWakeTime:
            {
                NSDate *alarmTime = date;
                actionSheet = [self alarmActionSheetForWakeTime:alarmTime];
                actionSheet.tag = AFActionSheetTagAlarm;
            }
            break;
            
        case AFSelectedUserModeCalculateBedTime:
            {
                NSDate *reminderTime = date;
                actionSheet = [self reminderActionSheetForSleepTime:reminderTime];
                actionSheet.tag = AFActionSheetTagReminder;
            }
            break;
            
        case AFSelectedUserModeCalculateBedTimeWithAlarmTime:
            {
                NSDate *alarmTime = date;
                actionSheet = [self alarmActionSheetForWakeTime:alarmTime];
                actionSheet.tag = AFActionSheetTagAlarm;
            }
            break;
            
        default:
            NSLog(@"%s: Performing no action sheet display", __PRETTY_FUNCTION__);
            break;
    }

    return actionSheet;
}

#pragma mark - Custom Action Sheets for Modes
/**
 @brief Creates and returns the Action Sheet for an Alarm with the fire date of wakeTime.
 @param wakeTime The NSDate that represents the desired alarm wake up time.
 @returns An IBActionSheet configured with the alarm set to wakeTime and one (or two) versions of the date. One of them
 is set to Tomorrow and the other Today).
 */
- (IBActionSheet *)alarmActionSheetForWakeTime:(NSDate *)wakeTime
{
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Set Alarm for %@", nil),
                                                                        [wakeTime shortTime]];
    
    NSString *todayButtonTitle = [NSString stringWithFormat:NSLocalizedString(@"Today (%@)", nil),
                                                                            [wakeTime shortDate]];
    
    // Fast forward date by 24 hours
    NSDate *tomorrowsDate = [wakeTime dateByAddingTimeInterval:HOURS_AS_SECONDS(24)];
    NSString *tomorrowButtonTitle = [NSString stringWithFormat:NSLocalizedString(@"Tomorrow (%@)", nil),
                                                                             [tomorrowsDate shortDate]];
    
    // Present appropriate otherButtonTitles depending on date relative to current time
    IBActionSheet *actionSheet;
    
    if ([NSDate spansMultipleDaysForTime:wakeTime])
    {
        actionSheet = [[IBActionSheet alloc] initWithTitle:title
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:tomorrowButtonTitle, todayButtonTitle, nil];
    } else {
        actionSheet = [[IBActionSheet alloc] initWithTitle:title
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:tomorrowButtonTitle, nil];
    }
    
    // Theme actionSheet
    id <Theme> themeSetter = [[ThemeFactory sharedThemeFactory] buildThemeForSettingsKey];
    [themeSetter themeIBActionSheet:actionSheet];
    
    // Build the time pairs to send via notification
    self.alarmTimesPair = @[tomorrowsDate, wakeTime];
    
    return actionSheet;
}

/**
 @brief Creates and returns an Action Sheet used for a Reminder set to fire at the sleepTime subtract 
 the timeToFallAsleep. That is, the Reminder fire date is (sleepTime - timeToFallAsleep).
 @param sleepTime The time to set the reminder at prior to subtracting the timeToFallAsleep.
 @returns An IBActionSheet configured with the the reminder set to fire at (sleepTime - timeToFallAsleep) and one 
 (or two) versions of its date. One if set to Today and the other is set to Tomorrow.
 */
- (IBActionSheet *)reminderActionSheetForSleepTime:(NSDate *)sleepTime
{
    // Create date set back by the user defined time to fall asleep (default 14)
    NSInteger timeToFallAsleep = [[SettingsAPI sharedSettingsAPI] timeToFallAsleep];
    NSDate *earlierTime = [sleepTime dateByAddingTimeInterval:(-1 * (MINUTES_AS_SECONDS(timeToFallAsleep)))];
    
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Remind me to be in bed at %@", nil),
                                                                                [earlierTime shortTime]];
    
    NSString *todayButtonTitle = [NSString stringWithFormat:NSLocalizedString(@"Today - %@", nil),
                                                                          [earlierTime shortDate]];
    
    // Shift date by 24 hours forward
    NSDate *tomorrowsDate = [earlierTime dateByAddingTimeInterval:HOURS_AS_SECONDS(24)];
    NSString *tomorrowButtonTitle = [NSString stringWithFormat:NSLocalizedString(@"Tomorrow - %@", nil),
                                                                             [tomorrowsDate shortDate]];
    
    // Present appropriate otherButtonTitles depending on date relative to current time
    IBActionSheet *actionSheet;

    if ([NSDate spansMultipleDaysForTime:earlierTime])
    {
        actionSheet = [[IBActionSheet alloc] initWithTitle:title
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:todayButtonTitle, tomorrowButtonTitle, nil];
    } else {
        actionSheet = [[IBActionSheet alloc] initWithTitle:title
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:tomorrowButtonTitle, nil];
    }
    
    // Theme actionSheet
    id <Theme> themeSetter = [[ThemeFactory sharedThemeFactory] buildThemeForSettingsKey];
    [themeSetter themeIBActionSheet:actionSheet];
    
    // Set up reminder time pairs to send via notification
    self.reminderTimesPair = @[earlierTime, tomorrowsDate];
    
    return actionSheet;
}

#pragma mark - IBActionSheetDelegate
- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case AFActionSheetTagAlarm:
            [self.delegate actionSheetPresenter:self
                           clickedButtonAtIndex:buttonIndex
                                 forActionSheet:actionSheet
                                        andInfo:@{@"Tomorrow": (NSDate *)self.alarmTimesPair.firstObject,
                                                  @"Today": (NSDate *)self.alarmTimesPair.lastObject}];
            break;
            
        case AFActionSheetTagReminder:
            [self.delegate actionSheetPresenter:self
                           clickedButtonAtIndex:buttonIndex
                                 forActionSheet:actionSheet
                                        andInfo:@{@"Today": (NSDate *)self.reminderTimesPair.firstObject,
                                                  @"Tomorrow": (NSDate *)self.reminderTimesPair.lastObject}];
            break;
            
        default:
            break;
    }
    
}


@end
