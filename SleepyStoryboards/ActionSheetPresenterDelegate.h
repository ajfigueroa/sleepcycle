//
//  ActionSheetPresenterDelegate.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/27/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionSheetConstants.h"
@class IBActionSheet;
@class ActionSheetPresenter;

/**
 @brief The ActionSheetPresenterDelegate defines a method for any delegate of ActionSheetPresenter class
 to adhere to. This is done in order to receive information on any interactions that occur on a given action
 sheet as well as the appropriate time data needed.
 */
@protocol ActionSheetPresenterDelegate <NSObject>

@required
/**
 @brief A message sent to the delegate that informs it of which actionSheet is presented, the button index pressed and the necessary date's needed.
 @param actionSheetPresenter The ActionSheetPresenter notifying the delegate of this information.
 @param buttonIndex The index of the button pressed.
 @param actionSheet The ActionSheet that is in the current context.
 @param tag The AFActionSheetConstant that uniquely identifies the action sheet.
 @param datePairs The pair of NSDate data that represents two times separated by 24 hours.
 */
- (void)actionSheetPresenter:(ActionSheetPresenter *)actionSheetPresenter
        clickedButtonAtIndex:(NSInteger)buttonIndex
              forActionSheet:(IBActionSheet *)actionSheet
                     withTag:(AFActionSheetTag)tag
                    andDates:(NSArray *)datePairs;

@end
