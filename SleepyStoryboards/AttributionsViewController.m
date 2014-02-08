//
//  AttributionsViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/6/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "AttributionsViewController.h"

@interface AttributionsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *attributionTextView;

@end

@implementation AttributionsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self buildAttributionsText];
}

- (void)buildAttributionsText
{
    NSString *text = @"\nLIBRARIES\n\n"
                     @"FlatUIKit\n"
                     @"https://github.com/grouper/flatuikit\n\n"
                     @"IBActionSheet\n"
                     @"https://github.com/ianb821/IBActionSheet\n\n"
                     @"SVProgressHUD\n"
                     @"https://github.com/samvermette/SVProgressHUD\n\n"
                     @"JSSlidingViewController\n"
                     @"https://github.com/jaredsinclair/JSSlidingViewController\n\n"
                     @"BOZPongRefreshControl\n"
                     @"https://github.com/boztalay/BOZPongRefreshControl\n\n"
                     @"Colors-for-iOS\n"
                     @"https://github.com/bennyguitar/Colours\n\n"
                     @"------------------------------------------------------------"
                     @"\n\nICONS\n\n"
                     @"Moon, Sun, Clock, Settings, and List\n"
                     @"http://somerandomdude.com/work/iconic/\n\n"
                     @"------------------------------------------------------------"
                     @"\n\nSOUNDS\n\n"
                     @"Alarm Sound was made by Joe DeShon\n"
                     @"http://www.freesound.org/people/joedeshon/\n\n"
                     @"------------------------------------------------------------"
                     @"\n\nICONS and SOUNDS under Creative Commons License\n"
                     @"http://creativecommons.org/licenses/by/3.0/\n\n";
    
    self.attributionTextView.text = NSLocalizedString(text, nil);
    self.attributionTextView.textAlignment = NSTextAlignmentCenter;
    self.attributionTextView.font = [UIFont fontWithName:@"Futura" size:[UIFont labelFontSize]];
    self.attributionTextView.textContainerInset = UIEdgeInsetsZero;
    self.attributionTextView.editable = NO;
    self.attributionTextView.dataDetectorTypes = UIDataDetectorTypeAll;
}

@end
