//
//  SettingsViewController.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/2/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsAPI.h"
#import "ThemeFactory.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "AFNotificationConstants.h"
#import "AFSegueIdentifierConstants.h"

typedef NS_ENUM(NSInteger, AFSettingsHeader)
{
    AFSettingsHeaderAppearance,
    AFSettingsHeaderBehaviour,
    AFSettingsHeaderSupport
};

typedef NS_ENUM(NSInteger, AFSettingsSupportSection)
{
    AFSettingsSupportSectionAbout,
    AFSettingsSupportSectionFeedback,
    AFSettingsSupportSectionAttributions
};

@interface SettingsViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *themeSelectionLabel;

@property (nonatomic, weak) IBOutlet UILabel *minutesLabel;

@property (nonatomic, weak) IBOutlet UISlider *minutesSlider;

// UISwitch Outlets
@property (weak, nonatomic) IBOutlet UISwitch *showBorderSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *showPingPongSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *showStartInfoSwitch;

/**
 @brief The corresponding target for the left bar button "Done" that notifies the delegate to
 dismiss this object.
 */
- (IBAction)done:(id)sender;

@end

@implementation SettingsViewController

#pragma mark - View Management
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self applyTheme];
    [self updateAllSettings];

    // Set the table view to scroll up to the top left corner on appearance
    [self.tableView scrollRectToVisible:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f) animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Register the minutes slider to update the label
    [self.minutesSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Register for Theme Change Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:AFThemeHasChangedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    // Commit any unsaved changes in case the user confirms full disappear of view
    [self commitMinutesSliderValue];
    
    // Commit current state of toggle buttons
    [[SettingsAPI sharedSettingsAPI] setShowBorder:self.showBorderSwitch.on];
    [[SettingsAPI sharedSettingsAPI] setShowEasterEgg:self.showPingPongSwitch.on];
    [[SettingsAPI sharedSettingsAPI] saveAllSettings];
}


#pragma mark - Theme Management
- (void)applyTheme
{
    id <Theme> themeSetter = [[ThemeFactory sharedThemeFactory] buildThemeForSettingsKey];
    
    [themeSetter themeNavigationBar:self.navigationController.navigationBar];
    [themeSetter themeSwitch:self.showBorderSwitch];
    [themeSetter themeSwitch:self.showPingPongSwitch];
    [themeSetter themeSwitch:self.showStartInfoSwitch];
    [themeSetter themeSlider:self.minutesSlider];
    
}

#pragma mark - ThemeSelectionViewControllerDelegate
- (void)themeSelectionViewController:(ThemeSelectionViewController *)controller
                      didSelectTheme:(NSString *)themeName
{
    [self updateThemeSelectionLabel];
    [[SettingsAPI sharedSettingsAPI] setAppThemeName:themeName];
}

#pragma mark - Settings Management
- (void)updateThemeSelectionLabel
{
    // Update the label based on the current theme inside the manager
    self.themeSelectionLabel.text = [[SettingsAPI sharedSettingsAPI] appThemeName];
}


- (void)updateShowPingPongEasterEggSetting
{
    self.showPingPongSwitch.on = [[SettingsAPI sharedSettingsAPI] showEasterEgg];
}

- (void)updateShowBorderSetting
{
    self.showBorderSwitch.on = [[SettingsAPI sharedSettingsAPI] showBorder];
}

- (void)updateMinuteSlider
{
    NSInteger minutesToFallAsleep = [[SettingsAPI sharedSettingsAPI] timeToFallAsleep];
    self.minutesSlider.value = minutesToFallAsleep;
    
    [self updateMinutesLabel:minutesToFallAsleep];
}

- (void)commitMinutesSliderValue
{
    // Update the settings manager with the new minutes value
    [[SettingsAPI sharedSettingsAPI] setTimeToFallAsleep:(NSInteger)self.minutesSlider.value];
}

- (void)updateMinutesLabel:(NSInteger)minutes
{
    if (minutes <= 1)
        self.minutesLabel.text = [NSString stringWithFormat:@"%ld minute", (long)minutes];
    else
        self.minutesLabel.text = [NSString stringWithFormat:@"%ld minutes", (long)minutes];
}

- (void)updateAllSettings
{
    // Update all settings based on their initialization methods
    [self updateThemeSelectionLabel];
    [self updateShowPingPongEasterEggSetting];
    [self updateShowBorderSetting];
    [self updateMinuteSlider];
}

#pragma mark - Target Action Methods
- (void)sliderValueChanged:(UISlider *)slider
{
    [self updateMinutesLabel:(NSInteger)slider.value];
}

- (IBAction)done:(id)sender
{
    // Inform delegate that business is done.
    [self.delegate settingsViewControllerDidFinish:self];
}


#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:AFThemeSelectionSegue])
    {
        ThemeSelectionViewController *themeSelectionViewController = (ThemeSelectionViewController *)segue.destinationViewController;
        themeSelectionViewController.delegate = self;
        themeSelectionViewController.themeName = [[SettingsAPI sharedSettingsAPI] appThemeName];
        themeSelectionViewController.themes = [[SettingsAPI sharedSettingsAPI] themeNames];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case AFSettingsHeaderSupport:
            [self configureSupportSectionOption:indexPath.row];
            break;
            
        default:
            break;
    }
}

#pragma mark - Support Settings Method
- (void)configureSupportSectionOption:(NSInteger)option
{
    switch (option) {
        case AFSettingsSupportSectionFeedback:
            [self buildFeedbackMailComposer];
            break;
            
        default:
            break;
    }
}

#pragma mark - MFMailComposer Builder
- (void)buildFeedbackMailComposer
{
    // Verify the user can send mail
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        composer.mailComposeDelegate = self;
        
        // Set up subject line
        [composer setSubject:NSLocalizedString(@"Feedback to your favourite neighbourhood developer!", nil)];
        
        // Set up recepients
        [composer setToRecipients:@[@"alexjfigueroa+feedback@gmail.com"]];
        
        [self presentViewController:composer animated:YES completion:nil];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - End of Life
- (void)dealloc
{
    // Remove observer so notification is not sent to null object
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Deregister the minutes slider to update the label
    [self.minutesSlider removeTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
}

@end
