//
//  TimeSelectionHandler.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/12/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "TimeSelectionHandler.h"
#import "NSDate+SleepTime.h"

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

- (void)buildActionSheetForState:(AFSelectedUserMode)state andDate:(NSDate *)date
{
    UIActionSheet *actionSheet;
    
    switch (state) {
        case AFSelectedUserModeCalculateWakeTime:
        {
            NSString *title = [NSString stringWithFormat:@"Set Alarm for %@", [date stringShortTime]];
            actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                      delegate:nil
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Today", @"Tomorrow", nil];
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

@end
