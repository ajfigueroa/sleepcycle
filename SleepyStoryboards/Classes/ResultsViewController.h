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
 @brief The model object that conforms to the SleepTimeModeller protocol that provides sleep time/wake time
 calculation data.
 */
@property (nonatomic, strong) id <SleepTimeModeller> model;

/**
 
 */
@property (nonatomic, assign) AFSelectedUserMode selectedUserMode;
// The time passed in from the datePicker of the TimeSelectionViewController (aka Destination Time)
@property (nonatomic, strong) NSDate *selectedTime;

@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (weak, nonatomic) IBOutlet UILabel *resultsInformationLabel;

// Add Alarm for the current selectedTime property
- (IBAction)addSelectedTimeAlarm:(id)sender;

@end
