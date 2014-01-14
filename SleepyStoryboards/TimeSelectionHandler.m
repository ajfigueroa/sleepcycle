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

@end

static NSInteger const ReminderActionSheet = 0;
static NSInteger const AlarmActionSheet = 1;

@implementation TimeSelectionHandler

- (instancetype)initWithWindow:(UIWindow *)window
{
    self = [super init];
    
    if (self)
    {
        self.window = window;
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
            actionSheet.tag = AlarmActionSheet;
        }
            break;
            
        case AFSelectedUserModeCalculateBedTime:
        {
            actionSheet = [self reminderActionSheetForSleepTime:date];
            actionSheet.tag = ReminderActionSheet;
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
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    NSString *todayButtonTitle = [NSString stringWithFormat:@"Today (%@)", [earlierTime stringUsingFormatter:dateFormatter]];
    
    // Shift date by 24 hours forward
    NSDate *tomorrowsDate = [earlierTime dateByAddingTimeInterval:HOURS_AS_SECONDS(24)];
    NSString *tomorrowButtonTitle = [NSString stringWithFormat:@"Tomorrow (%@)", [tomorrowsDate stringUsingFormatter:dateFormatter]];
    
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
    switch (actionSheet.tag) {
        case AlarmActionSheet:
            NSLog(@"Alarm Action Sheet");
            break;
        case ReminderActionSheet:
            NSLog(@"Reminder Action Sheet");
            break;
            
        default:
            break;
    }
}

@end
