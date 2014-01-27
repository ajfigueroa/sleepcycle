//
//  ActionSheetConstants.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/27/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#ifndef SleepyStoryboards_ActionSheetConstants_h
#define SleepyStoryboards_ActionSheetConstants_h

typedef NS_ENUM(NSInteger, AFActionSheetTag)
{
    AFActionSheetTagReminder,
    AFActionSheetTagAlarm
};

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
