//
//  ResultsViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SleepTimeModelProtocol.h"
#import "ApplicationSlidingViewControllerProtocol.h"

@interface ResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) id <SleepTimeModelProtocol> model;
@property (nonatomic, weak) id <ApplicationSlidingViewControllerProtocol> applicationDelegate;
@property (nonatomic) AFSelectedUserMode selectedUserMode;
@property (nonatomic, strong) NSDate *selectedTime;

@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (weak, nonatomic) IBOutlet UILabel *resultsInformationLabel;

@end
