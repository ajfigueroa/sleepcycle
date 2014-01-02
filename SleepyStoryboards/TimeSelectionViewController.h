//
//  TimeSelectionViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/31/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"

@interface TimeSelectionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *timeSelectionDatePicker;
@property (weak, nonatomic) IBOutlet FUIButton *confirmTimeButton;
@property (weak, nonatomic) IBOutlet FUIButton *sleepNowButton;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@end
