//
//  BlackOverlayImageViewManager.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/22/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "BlackOverlayImageViewManager.h"

@implementation BlackOverlayImageViewManager

- (UIImage *)settingsImage
{
    return [UIImage imageNamed:@"settings.png"];
}

- (UIImage *)bedTimeImage
{
    return [UIImage imageNamed:@"moonicon.png"];
}

- (UIImage *)wakeTimeImage
{
    return [UIImage imageNamed:@"sunicon.png"];
}

- (UIImage *)alarmImage
{
    return [UIImage imageNamed:@"alarmclock.png"];
}

@end
