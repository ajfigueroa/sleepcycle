//
//  ActionSheetPresenter.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/27/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//
//  Responsible for presenting all action sheets and scheduling

#import <Foundation/Foundation.h>

@protocol ActionSheetPresenterDelegate;

@interface ActionSheetPresenter : NSObject <UIActionSheetDelegate>

// The window on which to present the action sheet unto
@property (nonatomic, weak) UIWindow *presenterWindow;
// The delegate to notify of selections between various action sheets
@property (nonatomic, weak) id <ActionSheetPresenterDelegate> delegate;

// Action Sheet Builder
- (void)buildActionSheetForState:(AFSelectedUserMode)state andDate:(NSDate *)date;

@end

@protocol ActionSheetPresenterDelegate <NSObject>

@required
- (void)actionSheetPresenter:(ActionSheetPresenter *)actionSheetPresenter clickedButtonAtIndex:(NSInteger)buttonIndex forActionSheetTag:(NSInteger)tag;

@end