//
//  ActionSheetPresenterDelegate.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/27/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFActionSheetConstants.h"
@class IBActionSheet;
@class ActionSheetPresenter;

/**
 @brief The ActionSheetPresenterDelegate defines a method for any delegate of ActionSheetPresenter class
 to adhere to. This is done in order to receive information on any interactions that occur on a given action
 sheet as well as the appropriate data needed.
 */
@protocol ActionSheetPresenterDelegate <NSObject>

@required
/**
 @brief A message sent to the delegate that informs it of which actionSheet is presented, the button index pressed and the necessary data needed.
 @param actionSheetPresenter The ActionSheetPresenter notifying the delegate of this information.
 @param buttonIndex The index of the button pressed.
 @param actionSheet The ActionSheet that is in the current context.
 @param info The dictionary representing any additional information to be passed to the delegate.
 */
- (void)actionSheetPresenter:(ActionSheetPresenter *)actionSheetPresenter
        clickedButtonAtIndex:(NSInteger)buttonIndex
              forActionSheet:(IBActionSheet *)actionSheet
                    andInfo:(NSDictionary *)info;

@end
