//
//  SliderMenuApplicationDelegate.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/3/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief A protocol that an ApplicationDelegate must adhere to in order to handle
 the responsibilities of having a Sliding Menu. The required methods
 allow the delegate to manage the toggling of the slider, the locking/unlocking of
 the slider, and setting/getting of the frontViewController
 */
@protocol SliderMenuApplicationDelegate <NSObject, UIApplicationDelegate>

- (void)toggleSlider;
- (void)lockSlider;
- (void)unlockSlider;

- (UIViewController *)frontViewController;
- (void)setFrontViewController:(UIViewController *)viewController;

@end
