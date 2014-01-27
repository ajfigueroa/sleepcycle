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

#define MINUTES_AS_SECONDS(x) (x * 60)
#define HOURS_AS_SECONDS(x) (x * 60 * 60)

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
    
    UIActionSheet *actionSheet;
    
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
            
        default:
            NSLog(@"%s: Performing no action sheet display", __PRETTY_FUNCTION__);
            break;
    }
    
    // Display action sheet
    [actionSheet showInView:self.presenterWindow];
}

#pragma mark - Custom Action Sheets for Modes
- (UIActionSheet *)alarmActionSheetForWakeTime:(NSDate *)wakeTime
{
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Set Alarm for %@", nil),
                                                                [wakeTime shortTimeLowerCase]];
    
    NSString *todayButtonTitle = [NSString stringWithFormat:NSLocalizedString(@"Today (%@)", nil),
                                                                            [wakeTime shortDate]];
    
    // Fast forward date by 24 hours
    NSDate *tomorrowsDate = [wakeTime dateByAddingTimeInterval:HOURS_AS_SECONDS(24)];
    NSString *tomorrowButtonTitle = [NSString stringWithFormat:NSLocalizedString(@"Tomorrow (%@)", nil),
                                                                             [tomorrowsDate shortDate]];
    
    // Present appropriate otherButtonTitles depending on date relative to current time
    UIActionSheet *actionSheet;
    
    if ([NSDate spansMultipleDaysForTime:wakeTime])
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:tomorrowButtonTitle, todayButtonTitle, nil];
    } else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:tomorrowButtonTitle, nil];
    }
    
    
    
    return actionSheet;
}

- (UIActionSheet *)reminderActionSheetForSleepTime:(NSDate *)sleepTime
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
    UIActionSheet *actionSheet;

    if ([NSDate spansMultipleDaysForTime:earlierTime])
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:todayButtonTitle, tomorrowButtonTitle, nil];
    } else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:tomorrowButtonTitle, nil];
    }
    
    return actionSheet;
}

#pragma mark - UIActionSheetDelegate
-  (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.delegate actionSheetPresenter:self
                   clickedButtonAtIndex:buttonIndex
                      forActionSheetTag:actionSheet.tag];
}


@end
