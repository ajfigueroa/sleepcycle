//
//  AlarmCell.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/27/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmCell : UITableViewCell

/** 
 @brief Label that displays the human readable alarm time.
 */
@property (weak, nonatomic) IBOutlet UILabel *alarmTimeLabel;
/**
 @brief Label that displays the human readable alarm date.
 */
@property (weak, nonatomic) IBOutlet UILabel *alarmDateLabel;

@end
