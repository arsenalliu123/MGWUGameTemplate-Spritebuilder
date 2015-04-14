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
    [audio preloadEffect:@"bgm.mp3"];

}

- (void)newGame {
    //reset played level
    NSUserDefaults *storeLevel = [NSUserDefaults standardUserDefaults];
    [storeLevel setValue:@"Sun1" forKey:@"level"];
    [storeLevel synchronize];
    
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:gameplayScene withTransition:transition];
}

- (void)resume {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:gameplayScene withTransition:transition];
}

- (void)highScore{
    CCScene *hsScene = [CCBReader loadAsScene:@"HighScore"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:hsScene withTransition:transition];
}

@end