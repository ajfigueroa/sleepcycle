//
//  SleepyTimeModel.h
//  SleepyTimeUpdate
//
//  Created by Alexander Figueroa on 11/20/2013.
//  Copyright (c) 2013 Alexander Figueroa. All rights reserved.
//
//  The SleepyTimeModel is responsible for storing our sleep or bed times as
//  the timeDataSource and updating the current value of it depending on the desired actions.

#import <Foundation/Foundation.h>
#import "SleepTimeModelProtocol.h"

@interface SleepyTimeModel : NSObject <SleepTimeModelProtocol>

@end
