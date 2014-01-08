//
//  ApplicationDelegateSlidingViewControllerDelegate.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/7/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JSSlidingViewController;

@protocol ApplicationDelegateSlidingViewControllerDelegate <NSObject>

@property (nonatomic, strong) JSSlidingViewController *slidingViewController;

@end
