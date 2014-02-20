//
//  AttributionsViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 2/6/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "AttributionsViewController.h"
#import "WebViewController.h"

@interface AttributionsViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *attributionTextView;

@property (nonatomic, strong) WebViewController *webViewController;

@end

@implementation AttributionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildAttributionsText];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Assign self as the delegate of the textView
    self.attributionTextView.delegate = self;
}

- (void)buildAttributionsText
{
    NSString *text = @"\nLibraries\n\n"
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
                     @"\n\nIcons\n\n"
                     @"Moon, Sun, Clock, Settings, and List\n"
                     @"http://somerandomdude.com/work/iconic/\n\n"
                     @"------------------------------------------------------------"
                     @"\n\nSounds\n\n"
                     @"Alarm Sound was made by Joe DeShon\n"
                     @"http://www.freesound.org/people/joedeshon/\n\n"
                     @"------------------------------------------------------------"
                     @"\n\nIcons and Sounds under Creative Commons License\n"
                     @"http://creativecommons.org/licenses/by/3.0/\n\n";
    
    self.attributionTextView.text = NSLocalizedString(text, nil);
    self.attributionTextView.textAlignment = NSTextAlignmentCenter;
    self.attributionTextView.font = [UIFont fontWithName:@"Futura" size:[UIFont labelFontSize]];
    self.attributionTextView.textContainerInset = UIEdgeInsetsZero;
    self.attributionTextView.editable = NO;
    self.attributionTextView.dataDetectorTypes = UIDataDetectorTypeAll;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    // Initialize the webView with the URL
    self.webViewController = [[WebViewController alloc] initWithRequestURL:URL];
    
    // Push the view onto the stack
    [self.navigationController pushViewController:self.webViewController animated:YES];
    
    // Return no as we will handle this
    return NO;
}

@end
