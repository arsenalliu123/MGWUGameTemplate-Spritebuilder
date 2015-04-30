//
//  Gameplay.m
//  Shootem
//
//  Created by River on 2/18/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "Planet.h"
#import "Sun.h"
#import "Popup.h"


static NSString * const kFirstLevel = @"Sun1";
static NSString *selectedLevel = @"Sun1";

@implementation Gameplay{
    CCPhysicsNode *_physicsNode;
    Planet *_planet;
    Sun *_sun;
    CCLabelTTF *_scorelabel;
    CCLabelTTF *_requirelabel;
    CCLabelTTF *_levelDisplay;
    int _scoreval;
    int _scorereq;
    bool isPoped;
    float rotateSpeed1;
    float rotateSpeed2;
}

#pragma mark - loading

//load from CCB file
- (void)didLoadFromCCB{
    
    //load the last played level
    NSString *tmpLevel;
    NSUserDefaults *loadLevel = [NSUserDefaults standardUserDefaults];
    tmpLevel = [loadLevel stringForKey:@"level"];
    
    if(tmpLevel != nil){
        selectedLevel = tmpLevel;
    }
    else{
        selectedLevel = kFirstLevel;
    }
    [loadLevel setValue:selectedLevel forKey:@"level"];
    
    //NSLog(selectedLevel);
    
    _sun = (Sun *)[CCBReader load:selectedLevel owner:self];
    CGPoint planetPosition = ccp(360, 160);
    _sun.position = [_physicsNode convertToNodeSpace:planetPosition];
    [_physicsNode addChild:_sun];
    
    //let the sun rotate!
    //TODO: more complicated levels
    
    int currentLevel = [self getLevel:selectedLevel];

    float time1 = 1.8;
    float time2 = 0.6;
    
    CCAction *action1 = [CCActionRotateBy actionWithDuration:time1 angle:time1*_sun.rotateSpeed1];
    action1.tag = 1;
    CCAction *action2 = [CCActionRotateBy actionWithDuration:time2 angle:time2*_sun.rotateSpeed2];
    action2.tag = 2;
    
    NSArray *actionArray = @[action1,action2];
    id sequence = [CCActionSequence actionWithArray:actionArray];
    CCAction *action = [CCActionRepeatForever actionWithAction:sequence];
    [_sun runAction:action];
    
    /*
    action.tag = 1;
    CCActionRepeatForever *a = (CCActionRepeatForever *)[_sun getActionByTag:1];
    CCActionSequence *b = (CCActionSequence *)a.innerAction;
     */
    _scoreval = 0;
    _scorereq = _sun.requirement;
    _requirelabel.string = [NSString stringWithFormat:@"%d", _scorereq];
    _scorelabel.string = [NSString stringWithFormat:@"%d", _scoreval];
    _levelDisplay.string = [NSString stringWithFormat:@"%d", [self getLevel:selectedLevel]];
    
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playBg:[NSString stringWithFormat: @"%d.mp3", currentLevel%4] loop:TRUE];
    
    isPoped = false;
    
    //start user interaction NOW
    self.userInteractionEnabled = TRUE;
    _physicsNode.collisionDelegate = self;
    return;
}


#pragma mark - Touch Handle

//touch handler
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    if(!isPoped){
        /*add the planet to screen*/
        _planet = (Planet *)[CCBReader load:@"Planet"];
        CGPoint planetPosition = ccp(50, 160);
        _planet.position = [_physicsNode convertToNodeSpace:planetPosition];
        _planet.scale = 0.28;
        [_physicsNode addChild:_planet];
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        // play sound effect
        [audio playEffect:@"shooting.m4a"];
        // load particle effect
        CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"Shoot"];
        // make the particle effect clean itself up, once it is completed
        explosion.autoRemoveOnFinish = TRUE;
        // place the particle effect on the seals position
        explosion.position = _planet.position;
        // add the particle effect to the same node the seal is on
        [_planet.parent addChild:explosion];
        
        /*let the planet move!*/
        _planet.physicsBody.velocity = ccp(500.f, 0);
    }
    return;
}

#pragma mark - Collision
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair sun:(CCNode *)sun planet:(CCNode *)planet{
    
    /*set the planet not to move*/
    CGPoint tmp_pos = [planet convertToWorldSpace:ccp(34.5,50)];
    tmp_pos = [sun convertToNodeSpace:tmp_pos];
    planet.physicsBody.velocity = ccp(0, 0);
    /*if hit any other planet, call game over popup*/
    for(CCNode *child in _sun.children){
        float distance = (child.position.x-tmp_pos.x)*(child.position.x-tmp_pos.x)+(child.position.y-tmp_pos.y)*(child.position.y-tmp_pos.y);
        float width = planet.contentSizeInPoints.width*planet.scale;
        if(distance < width*width){
            planet.position = tmp_pos;
            [planet removeFromParent];
            planet.physicsBody = nil;
            [_sun addChild:planet];
            self.paused = YES;
            Popup *popup = (Popup *)[CCBReader load:@"LosePopup" owner:self];
            popup.position = ccp(0,0);
            [self addChild:popup];
            OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
            // play sound effect
            [audio stopBg];
            [audio playEffect:@"failure.mp3"];
            isPoped = true;
            return YES;
        }
    }
    
    planet.position = tmp_pos;
    [planet removeFromParent];
    planet.physicsBody = nil;
    [_sun addChild:planet];
    
    /*else add the planet to the sun, add score and see if the player wins*/
    _scoreval++;
    _scorelabel.string = [NSString stringWithFormat:@"%d", _scoreval];
    if(_scoreval == _scorereq){
        self.paused = YES;
        Popup *popup = (Popup *)[CCBReader load:@"WinPopup" owner:self];
        popup.position = ccp(0,0);
        NSUserDefaults *storeLevel = [NSUserDefaults standardUserDefaults];
        NSString *storedLevel = [storeLevel objectForKey:@"highScore"];
        if(storedLevel==nil||[self getLevel:storedLevel]<[self getLevel:selectedLevel]){
            NSLog(@"high score%d", [self getLevel:selectedLevel]);
            NSUserDefaults *storeLevel = [NSUserDefaults standardUserDefaults];
            [storeLevel setValue:selectedLevel forKey:@"highScore"];
            [storeLevel synchronize];
        }
        [self addChild:popup];
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        // play sound effect
        [audio stopBg];
        [audio playEffect:@"success.mp3"];
        isPoped = true;
        return YES;
    }
    return NO;
}

//load next level
- (void)loadnextLevel {
    
    selectedLevel = _sun.nextLevelName;
    
    NSUserDefaults *storeLevel = [NSUserDefaults standardUserDefaults];
    [storeLevel setValue:selectedLevel forKey:@"level"];
    //NSLog(@"stored!");
    [storeLevel synchronize];
    
    CCScene *nextScene = nil;
    
    if (selectedLevel) {
        nextScene = [CCBReader loadAsScene:@"Gameplay"];
    } else {
        selectedLevel = kFirstLevel;
        nextScene = [CCBReader loadAsScene:@"MainScene"];
    }
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // stop sound effect
    [audio stopAllEffects];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:nextScene withTransition:transition];
    [super removeFromParent];
}

//toggled when user hit play again
- (void)retry {
    CCScene *nextScene = [CCBReader loadAsScene:@"Gameplay"];
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // stop sound effect
    [audio stopAllEffects];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:nextScene withTransition:transition];
    [super removeFromParent];
}

//toggle when going back
- (void) goBack{
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    CCScene *nextScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] presentScene:nextScene withTransition:transition];
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio stopEverything];
}


#pragma mark - helper function

- (int)getLevel:(NSString *)selectedLevel{
    return [[selectedLevel substringFromIndex:3] intValue];
}

@end
