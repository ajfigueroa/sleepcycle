//
//  ResultsViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SleepTimeModeller.h"
#import "AFSleepCycleConstants.h"

@interface ResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

/**
 @brief The model object that conforms to the SleepTimeModeller protocol that provides sleep time/wake time calculation data.
 */
@property (nonatomic, strong) id <SleepTimeModeller> model;

/**
 @brief The currently selected user mode (AFSelectedUserMode constant) that the ResultsViewController 
 is presenting data for.
 */
@property (nonatomic, assign) AFSelectedUserMode selectedUserMode;

/*
 @brief The currently selected time passed in from the previous controller. Acts as a reference to the
 seed time that populated the table view data.
 */
@property (nonatomic, strong) NSDate *selectedTime;


@end
