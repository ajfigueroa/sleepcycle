//
//  EmptyTableViewBackground.m
//  SleepyStoryboards
//
//  Created by Alexander Figueroa on 1/28/2014.
//  Copyright (c) 2014 Alexander Figueroa. All rights reserved.
//

#import "EmptyTableViewBackground.h"

@implementation EmptyTableViewBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Grab message to display when table is empty
        NSString *emptyTableMessage = NSLocalizedString(@"You have no alarms set.", nil);
        
        // Initialize the emptyTableMessageLabel with no frame
        self.emptyTableMessageLabel = [[UILabel alloc] init];
        
        // Given the desired font, calculate how to place it in the center
        UIFont *labelFont = [UIFont fontWithName:@"Futura" size:[UIFont buttonFontSize] + 2];
        CGSize labelSizeWithFont = [emptyTableMessage sizeWithAttributes:@{NSFontAttributeName: labelFont}];
        
        self.emptyTableMessageLabel.frame = (CGRect){
            .origin.x = self.center.x - labelSizeWithFont.width / 2.0f,
            .origin.y = self.center.y - labelSizeWithFont.height / 2.0f,
            .size.width = labelSizeWithFont.width,
            .size.height = labelSizeWithFont.height
        };
        
        self.emptyTableMessageLabel.text = emptyTableMessage;
        self.emptyTableMessageLabel.font = labelFont;
        self.emptyTableMessageLabel.textAlignment = NSTextAlignmentCenter;
        
        // Add to subview
        [self addSubview:self.emptyTableMessageLabel];
        
    }
    return self;
}


@end
