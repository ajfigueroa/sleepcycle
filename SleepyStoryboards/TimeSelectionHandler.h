//
//  TimeSelectionHandler.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/12/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//
//  Responsible for handling all Reminder and LocalNotification requests

#import <Foundation/Foundation.h>

@interface TimeSelectionHandler : NSObject <UIActionSheetDelegate>

@property (nonatomic, strong) NSDate *destinationTime;
@property (nonatomic, weak) UIWindow *presenterWindow;

- (void)buildActionSheetForState:(AFSelectedUserMode)state andDate:(NSDate *)date;

@end
