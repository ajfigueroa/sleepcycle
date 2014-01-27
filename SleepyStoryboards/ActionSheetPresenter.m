//
//  ActionSheetPresenter.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/27/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "ActionSheetPresenter.h"

typedef NS_ENUM(NSInteger, AFActionSheetType)
{
    AFActionSheetTypeSelectedTimeAlarm
};

@implementation ActionSheetPresenter

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

}

#pragma mark - ActionSheet Presentation Methods
- (void)postAlarmActionSheetForSelectedTime
{
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Set Alarm for %@", nil)];
    NSString *cancelTitle = NSLocalizedString(@"Nevermind", nil);
    
    // Create actionsheet with tag
    UIActionSheet *selectedTimeAlarmActionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                                              delegate:self
                                                                     cancelButtonTitle:cancelTitle
                                                                destructiveButtonTitle:nil
                                                                     otherButtonTitles:nil];
    
    selectedTimeAlarmActionSheet.tag = AFActionSheetTypeSelectedTimeAlarm;
}


@end
