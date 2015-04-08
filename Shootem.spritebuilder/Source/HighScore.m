//
//  HighScore.m
//  Shootem
//
//  Created by River on 4/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "HighScore.h"

@implementation HighScore{
    CCLabelTTF *_high;
}

- (void) didLoadFromCCB{
    NSString *level = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"];
    _high.string = level;
}

@end
