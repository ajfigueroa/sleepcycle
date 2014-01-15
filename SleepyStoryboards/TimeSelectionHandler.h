//
//  TimeSelectionHandler.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/12/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>
@import EventKit;

@interface TimeSelectionHandler : NSObject <UIActionSheetDelegate>

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic, strong) NSDate *destinationTime;

- (instancetype)initWithWindow:(UIWindow *)window;
- (void)buildActionSheetForState:(AFSelectedUserMode)state andDate:(NSDate *)date;
- (BOOL)validReminderTime:(NSDate *)candidateReminderTime;

@end
