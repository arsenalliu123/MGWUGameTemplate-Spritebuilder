//
//  Credit.m
//  Shootem
//
//  Created by River on 4/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Credit.h"

@implementation Credit

- (void) goBack{
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] popSceneWithTransition:transition];
}

@end
