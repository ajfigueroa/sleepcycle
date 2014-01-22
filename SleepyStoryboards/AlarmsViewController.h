//
//  AlarmsViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/9/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationSlidingViewControllerProtocol.h"

@interface AlarmsViewController : UITableViewController

@property (nonatomic, weak) id <ApplicationSlidingViewControllerProtocol> applicationDelegate;

- (IBAction)toggleSlider:(id)sender;

@end
