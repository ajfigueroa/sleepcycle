//
//  ImageViewManager.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/22/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageViewManager <NSObject>

- (UIImage *)settingsImage;
- (UIImage *)bedTimeImage;
- (UIImage *)wakeTimeImage;
- (UIImage *)alarmImage;

@end
