//
//  ImageViewManager.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/22/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief The ImageViewManager protocol defines methods that must be implemented in order to provide
 UIImages to the various setting cells found in the MenuViewController storyboard.
 */
@protocol ImageViewManager <NSObject>

/**
 @brief Returns the image to be used for the Settings cell
 @returns The UIImage to be used in the Settings cell's imageView.
 */
- (UIImage *)settingsImage;

/**
 @brief Returns the image to be used for the Bed Time cell.
 @returns The UIImage to be used in the Bed Time cell's imageView.
 */
- (UIImage *)bedTimeImage;

/**
 @brief Returns the image to be used for the Wake Time cell.
 @returns The UIImage to be used in the Wake Time cell's imageView.
 */
- (UIImage *)wakeTimeImage;

/**
 @brief Returns the image to be used for the Alarm cell.
 @returns The UIImage to be used in the Alarm cell's imageView.
 */
- (UIImage *)alarmImage;

@end
