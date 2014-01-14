//
//  TimeSelectionHandler.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/12/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "TimeSelectionHandler.h"
#import "NSDate+SleepTime.h"
#import "SettingsManager.h"

#define MINUTES_AS_SECONDS(x) (x * 60)
#define HOURS_AS_SECONDS(x) (x * 60 * 60)

@interface TimeSelectionHandler ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic) AFSelectedUserMode selectedUserMode;
@property (nonatomic, strong) NSDate *reminderTime;
@property (nonatomic, strong) NSDate *alarmTime;

@end

typedef NS_ENUM(NSInteger, ActionSheetMode)
{
    ActionSheetModeReminder,
    ActionSheetModeAlarm
};

typedef NS_ENUM(NSInteger, ActionSheetReminder)
{
    ActionSheetReminderToday,
    ActionSheetReminderTomorrow
};

typedef NS_ENUM(NSInteger, ActionSheetAlarm)
{
    ActionSheetAlarmTomorrow,
    ActionSheetAlarmToday
};

@implementation TimeSelectionHandler

- (instancetype)initWithWindow:(UIWindow *)window
{
    self = [super init];
    
    if (self)
    {
        self.window = window;
        
        if (!self.eventStore)
            self.eventStore = [[EKEventStore alloc] init];
    }
    
    return self;
}

#pragma mark - Action Sheet Methods
- (void)buildActionSheetForState:(AFSelectedUserMode)state andDate:(NSDate *)date
{
    UIActionSheet *actionSheet;
    
    switch (state) {
        case AFSelectedUserModeCalculateWakeTime:
        {
            actionSheet = [self alarmActionSheetForWakeTime:date];
            actionSheet.tag = ActionSheetModeAlarm;
            self.alarmTime = date;
        }
            break;
            
        case AFSelectedUserModeCalculateBedTime:
        {
            actionSheet = [self reminderActionSheetForSleepTime:date];
            actionSheet.tag = ActionSheetModeReminder;
            self.reminderTime = date;
        }
            break;
            
        default:
            NSLog(@"%s: Performing no action sheet display", __PRETTY_FUNCTION__);
            break;
    }
    
    // Display action sheet
    [actionSheet showInView:self.window];
}

- (UIActionSheet *)alarmActionSheetForWakeTime:(NSDate *)wakeTime
{
    NSString *title = [NSString stringWithFormat:@"Set Alarm for %@", [wakeTime stringShortTime]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    NSString *todayButtonTitle = [NSString stringWithFormat:@"Today (%@)", [wakeTime stringUsingFormatter:dateFormatter]];
    
    // Shift date by 24 hours forward
    NSDate *tomorrowsDate = [wakeTime dateByAddingTimeInterval:HOURS_AS_SECONDS(24)];
    NSString *tomorrowButtonTitle = [NSString stringWithFormat:@"Tomorrow (%@)", [tomorrowsDate stringUsingFormatter:dateFormatter]];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:tomorrowButtonTitle, todayButtonTitle, nil];
    
    return actionSheet;
}

- (UIActionSheet *)reminderActionSheetForSleepTime:(NSDate *)sleepTime
{
    // Create date set back by the user defined time to fall asleep (default 14)
    NSInteger timeToFallAsleep = [[SettingsManager sharedSettings] timeToFallAsleep];
    NSDate *earlierTime = [sleepTime dateByAddingTimeInterval:(-1 * (MINUTES_AS_SECONDS(timeToFallAsleep)))];
    
    NSString *title = [NSString stringWithFormat:@"Remind me to be in bed at %@", [earlierTime stringShortTime]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    NSString *todayButtonTitle = [NSString stringWithFormat:@"Today - %@", [earlierTime stringUsingFormatter:dateFormatter]];
    
    // Shift date by 24 hours forward
    NSDate *tomorrowsDate = [earlierTime dateByAddingTimeInterval:HOURS_AS_SECONDS(24)];
    NSString *tomorrowButtonTitle = [NSString stringWithFormat:@"Tomorrow - %@", [tomorrowsDate stringUsingFormatter:dateFormatter]];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:todayButtonTitle, tomorrowButtonTitle, nil];
    
    return actionSheet;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex){
        switch (actionSheet.tag) {
            case ActionSheetModeAlarm:
                NSLog(@"Alarm Action Sheet");
                break;
            case ActionSheetModeReminder:
                [self performReminderActionForIndex:buttonIndex];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Reminder Set Up
- (void)performReminderActionForIndex:(ActionSheetReminder)index
{
    // First zero seconds
    NSDate *reminderTargetTime;
    
    if (index == ActionSheetReminderTomorrow)
    {
        // Offset by 24 hours
        reminderTargetTime = [self.reminderTime dateByAddingTimeInterval:HOURS_AS_SECONDS(24)];
    }
    else {
        NSInteger timeToFallAsleep = [[SettingsManager sharedSettings] timeToFallAsleep];
        reminderTargetTime = [self.reminderTime dateByAddingTimeInterval:(-1 * (MINUTES_AS_SECONDS(timeToFallAsleep)))];
    }
    
    [self addReminderForTime:[reminderTargetTime zeroDateSeconds]];
}

- (void)addReminderForTime:(NSDate *)reminderTime
{
    [self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        
        if (granted)
        {
            EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
            reminder.title = @"You should be in bed now!";
            reminder.timeZone = [NSTimeZone defaultTimeZone];
            reminder.notes = [NSString stringWithFormat:@"SleepCycle here!\nYou should be in bed now so that when you fall asleep, you'll wake up at your desired time of %@", [self.destinationTime stringShortTime]];
            
            EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:reminderTime];
            [reminder addAlarm:alarm];
            
            EKCalendar *defaultReminderList = [self.eventStore defaultCalendarForNewReminders];
            [reminder setCalendar:defaultReminderList];
            
            NSError *error = nil;
            BOOL success = [self.eventStore saveReminder:reminder commit:YES error:&error];
            
            if (!success)
                NSLog(@"Error saving reminder: %@", error.localizedDescription);
            
            
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
            UIAlertView *deniedAlertView = [[UIAlertView alloc] initWithTitle:@"I'm sorry, Dave." message:@"I'm afraid I can't do that.\nTo turn Reminders back on, go to:\nSettings > Privacy > Reminders\nand enable SleepCycle!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [deniedAlertView show];
        }
    }];
}

@end
