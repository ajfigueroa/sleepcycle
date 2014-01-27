//
//  ActionSheetPresenter.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/27/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//
//  Responsible for presenting all action sheets and control delegation

#import <Foundation/Foundation.h>

@interface ActionSheetPresenter : NSObject <UIActionSheetDelegate>

@property (nonatomic, weak) UIWindow *presenterWindow;

@end
