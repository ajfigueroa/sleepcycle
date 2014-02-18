//
//  AFSleepCycleConstants.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/17/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#ifndef SleepyStoryboards_AFSleepCycleConstants_h
#define SleepyStoryboards_AFSleepCycleConstants_h

/*
 The SelectedUserMode enum is used to keep track of the buttons entered by
 the user.
 */
typedef NS_ENUM(NSInteger, AFSelectedUserMode)
{
    /** The mode that calculates bed time based on input wake time */
    AFSelectedUserModeCalculateBedTime,
    /** The mode that calcualates wake time based on input bed time */
    AFSelectedUserModeCalculateWakeTime,
    /** The mode that calculates the bed time based on input wake time. This is specific
     for alarms using the seed time (wake time). */
    AFSelectedUserModeCalculateBedTimeWithAlarmTime
};

#endif
