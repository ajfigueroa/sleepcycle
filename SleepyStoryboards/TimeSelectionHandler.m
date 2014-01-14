//
//  TimeSelectionHandler.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/12/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "TimeSelectionHandler.h"
#import "NSDate+SleepTime.h"

#define MINUTES_AS_SECONDS(x) (x * 60)
#define HOURS_AS_SECONDS(x) (x * 60 * 60)

@interface TimeSelectionHandler ()

@property (nonatomic, strong) UIWindow *window;

@end

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
        }
            break;
            
        case AFSelectedUserModeCalculateBedTime:
        {
            NSString *title  = [NSString stringWithFormat:@"Set a reminder to be in bed at %@", [date stringShortTime]];
            actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                      delegate:nil
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Today", @"Tomorrow", nil];
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
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:todayButtonTitle, tomorrowButtonTitle, nil];
    
    return actionSheet;
}

@end
