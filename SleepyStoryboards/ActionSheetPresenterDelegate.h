//
//  ActionSheetPresenterDelegate.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/27/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionSheetConstants.h"

@class ActionSheetPresenter;

@protocol ActionSheetPresenterDelegate <NSObject>

@required
- (void)actionSheetPresenter:(ActionSheetPresenter *)actionSheetPresenter
        clickedButtonAtIndex:(NSInteger)buttonIndex
           forActionSheetTag:(AFActionSheetTag)tag;


@end
