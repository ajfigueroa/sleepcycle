//
//  ResultsViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SleepyTimeModel.h"

@interface ResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (weak, nonatomic) IBOutlet UILabel *resultsInformationLabel;

@property (nonatomic, strong) SleepyTimeModel *model;
@property (nonatomic) AFSelectedUserMode selectedUserMode;

@end
