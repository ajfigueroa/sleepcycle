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

// The desired scheduled time
@property (nonatomic, strong) NSDate *desiredScheduledTime;

// Keep a reference to the pairs of Reminder and Alarm Times (prone to overwrites)
@property (nonatomic, strong) NSArray *alarmTimesPair;
@property (nonatomic, strong) NSArray *reminderTimesPair;

@end

@implementation ActionSheetPresenter
{}

- (instancetype)initWithPresenterWindow:(UIWindow *)presenterWindow
{
    self = [super init];
    
    if (self)
    {
        // Ensure a window exists to load action sheets unto
        self.presenterWindow = presenterWindow;
    }
    
    return self;
}

#pragma mark - Action Sheet Methods
- (void)buildActionSheetForState:(AFSelectedUserMode)state andDate:(NSDate *)date
{
    // Ensure the presenter window exists prior to loading actionsheet
    assert(self.presenterWindow != nil);
    
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
    
    // Display action sheet
    [actionSheet showInView:self.presenterWindow];
}

#pragma mark - Custom Action Sheets for Modes
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

#pragma mark - UIActionSheetDelegate
-  (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case AFActionSheetTagAlarm:
            [self.delegate actionSheetPresenter:self
                           clickedButtonAtIndex:buttonIndex
                                 forActionSheet:actionSheet
                                        withTag:actionSheet.tag
                                       andDates:self.alarmTimesPair];
            break;
            
        case AFActionSheetTagReminder:
            [self.delegate actionSheetPresenter:self
                           clickedButtonAtIndex:buttonIndex
                                 forActionSheet:actionSheet
                                        withTag:actionSheet.tag
                                       andDates:self.reminderTimesPair];
            break;
            
        default:
            break;
    }
    
}


@end
