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
    NSString *text = @"\nFlatUIKit\n"
                     @"https://github.com/grouper/flatuikit\n";
    
    self.attributionTextView.text = NSLocalizedString(text, nil);
    self.attributionTextView.textAlignment = NSTextAlignmentCenter;
    self.attributionTextView.font = [UIFont fontWithName:@"Futura" size:[UIFont labelFontSize]];
    self.attributionTextView.textContainerInset = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    self.attributionTextView.editable = NO;
    self.attributionTextView.dataDetectorTypes = UIDataDetectorTypeAll;
}

@end
