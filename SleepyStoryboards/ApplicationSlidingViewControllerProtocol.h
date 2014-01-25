//
//  ApplicationSlidingViewControllerProtocol.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/22/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JSSlidingViewController;

@protocol ApplicationSlidingViewControllerProtocol <NSObject, UIApplicationDelegate>

@property (nonatomic, strong) JSSlidingViewController *slidingViewController;

- (void)toggleSlider;
- (void)lockSlider;
- (void)unlockSlider;

@end
