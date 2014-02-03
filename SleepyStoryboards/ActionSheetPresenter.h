//
//  ActionSheetPresenter.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/27/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//
//  Responsible for presenting all action sheets and scheduling

#import <Foundation/Foundation.h>
#import "ActionSheetPresenterDelegate.h"
#import "IBActionSheet.h"

@interface ActionSheetPresenter : NSObject <IBActionSheetDelegate>

/**
 @brief The window to which present the action sheet upon.
 */
@property (nonatomic, strong) UIWindow *presenterWindow;

/**
 @brief The delegate object to receive information on any interactions that occur on a given action
 sheet as well as the appropriate data needed.
 */
@property (nonatomic, weak) id <ActionSheetPresenterDelegate> delegate;

/**
 @brief Initialize the presenterWindow property that the action sheets will present themselves upon.
 @sa -[UIActionSheet showInView:]
 */
- (instancetype)initWithPresenterWindow:(UIWindow *)presenterWindow;

/**
 @brief Creates an action sheet based on the given AFSelectedUserMode constant and seed date.
 @param state The AFSelectedUserMode constant that represents the applications mode.
 @sa AFSelectedUserMode constants and TimeSelectionViewController
 @param date The seed date that can either be a reminder time or alarm time.
 */
- (void)buildActionSheetForState:(AFSelectedUserMode)state andDate:(NSDate *)date;

@end
