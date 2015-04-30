#import "MainScene.h"

@implementation MainScene{
    CCButton *resumeButton;
}

- (void)didLoadFromCCB{
    NSUserDefaults *storeLevel = [NSUserDefaults standardUserDefaults];
    if ([storeLevel objectForKey:@"level"] == nil) {
        resumeButton.enabled = false;
    }
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio preloadEffect:@"shooting.m4a"];
    [audio preloadEffect:@"failure.mp3"];
    [audio preloadEffect:@"success.mp3"];
    for (int i=0; i<4; i++) {
        [audio preloadBg:[NSString stringWithFormat: @"%d.mp3", i]];
    }

}

- (void)newGame {
    //reset played level
    NSUserDefaults *storeLevel = [NSUserDefaults standardUserDefaults];
    [storeLevel setValue:nil forKey:@"level"];
    [storeLevel synchronize];
    
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] pushScene:gameplayScene withTransition:transition];
}

- (void)resumeGame {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] pushScene:gameplayScene withTransition:transition];
}

- (void)highScore{
    /*
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"http://rivo.me"];
    NSString *level = @"abcdefg";
    content.contentTitle = [NSString stringWithFormat: @"I've finished level %@ on Shootem!, how about you?", [level substringFromIndex:3]];
    content.imageURL = [NSURL URLWithString:@"arse"];
    content.contentDescription = @"Shootem! is yet another shooting game. The rest of it is for you to explore!";
    
    [FBSDKShareDialog
     showFromViewController:[CCDirector sharedDirector]
     withContent:content
     delegate:nil];
     */
    CCScene *hsScene = [CCBReader loadAsScene:@"HighScore"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] pushScene:hsScene withTransition:transition];
}

- (void)credits{
    CCScene *hsScene = [CCBReader loadAsScene:@"Credit"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] pushScene:hsScene withTransition:transition];
}

@end