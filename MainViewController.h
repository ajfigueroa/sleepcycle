//
//  MainViewController.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 12/30/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"

@interface MainViewController : UIViewController

// Manage the theming of the view
@property (nonatomic, strong) id <Theme> themeSetter;
@property (weak, nonatomic) IBOutlet UISegmentedControl *themeSegmentedControl;


@end
