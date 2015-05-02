//
//  HighScore.m
//  Shootem
//
//  Created by River on 4/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "HighScore.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@implementation HighScore{
    CCLabelTTF *_high;
    NSString *level;
    CCButton *shareButton;
}

- (void) didLoadFromCCB{
    level = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"];
    if(level == nil){
        shareButton.enabled = false;
        _high.string = @"NEVER";
    }
    else{
        _high.string = [NSString stringWithFormat:@"Level %@", [level substringFromIndex:3]];
    }
}

- (void) goBack{
    CCScene *mainmenu = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:mainmenu withTransition:transition];
}

- (void) sharing{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"http://rivo.me"];
    content.contentTitle = [NSString stringWithFormat: @"I've finished level %@ on Shootem!, how about you?", [level substringFromIndex:3]];
    content.contentDescription = @"Shootem! is yet another shooting game. The rest of it is for you to explore!";
    
    [FBSDKShareDialog showFromViewController:[CCDirector sharedDirector]
                                 withContent:content
                                    delegate:nil];
}

@end
