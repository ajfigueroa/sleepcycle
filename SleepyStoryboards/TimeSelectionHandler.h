//
//  TimeSelectionHandler.h
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/12/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeSelectionHandler : NSObject <UIActionSheetDelegate>

- (instancetype)initWithWindow:(UIWindow *)window;
- (void)buildActionSheetForState:(AFSelectedUserMode)state andDate:(NSDate *)date;

@end
