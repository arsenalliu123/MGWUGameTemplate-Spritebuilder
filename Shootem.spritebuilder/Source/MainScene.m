#import "MainScene.h"

@implementation MainScene{
    CCButton *resumeButton;
}

- (void)didLoadFromCCB{
    NSUserDefaults *storeLevel = [NSUserDefaults standardUserDefaults];
    if ([storeLevel objectForKey:@"level"] == nil) {
        resumeButton.enabled = false;
    }

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