//
//  AFActionSheetConstants.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/17/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#ifndef SleepyStoryboards_AFActionSheetConstants_h
#define SleepyStoryboards_AFActionSheetConstants_h

typedef NS_ENUM(NSInteger, AFActionSheetTag)
{
    /** The tag to be attached to an action sheet that sets up reminders */
    AFActionSheetTagReminder,
    /** The tag to be attached to an action sheet that sets up alarms */
    AFActionSheetTagAlarm
};

/*
 The following AFActionSheetReminder and AFActionSheetAlarm represent the order at which
 dates for today and tomorrow come in. They are different for both and this is to keep track
 of the differences.
 */
typedef NS_ENUM(NSInteger, AFActionSheetReminder)
{
    AFActionSheetReminderToday,
    AFActionSheetReminderTomorrow
};

typedef NS_ENUM(NSInteger, AFActionSheetAlarm)
{
    AFActionSheetAlarmTomorrow,
    AFActionSheetAlarmToday
};

#endif
