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
static float rduration = 0;

@implementation Gameplay{
    CCPhysicsNode *_physicsNode;
    Planet *_planet;
    Sun *_sun;
    CCActionRepeatForever *action;
    CCLabelTTF *_scorelabel;
    CCLabelTTF *_requirelabel;
    int _scoreval;
    int _scorereq;
}

- (void)didLoadFromCCB{
    
    self.userInteractionEnabled = TRUE;
    _physicsNode.collisionDelegate = self;
    
    /*load sun (a.k.a: level)*/
    NSLog(@"%@",selectedLevel);
    _sun = (Sun *)[CCBReader load:selectedLevel owner:self];
    CGPoint planetPosition = ccp(360, 160);
    _sun.position = [_physicsNode convertToNodeSpace:planetPosition];
    [_physicsNode addChild:_sun];
    
    /*let the sun rotate!*/
    rduration = _sun.rotateduration;
    action = [CCActionRepeatForever actionWithAction:[CCActionRotateBy actionWithDuration:rduration angle:360]];
    [_sun runAction:action];
    
    /*initialize the score*/
    _scoreval = 0;
    _scorereq = _sun.requirement;
    _requirelabel.string = [NSString stringWithFormat:@"%d", _scorereq];
    _scorelabel.string = [NSString stringWithFormat:@"%d", _scoreval];
    
    //_physicsNode.debugDraw = true;
    return;
}

#pragma mark - Touch Handle


- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    
    /*add the planet to screen*/
    _planet = (Planet *)[CCBReader load:@"Planet"];
    CGPoint planetPosition = ccp(50, 160);
    _planet.position = [_physicsNode convertToNodeSpace:planetPosition];
    _planet.scale = 0.4;
    [_physicsNode addChild:_planet];
    
    /*let the planet move!*/
    _planet.physicsBody.velocity = ccp(500.f, 0);
    
    return;
}

#pragma mark - Collision


- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair sun:(CCNode *)sun planet:(CCNode *)planet{
    
    /*set the planet not to move and remove it from physicsNode*/
    CGPoint tmp_pos = [planet convertToWorldSpace:ccp(39.2,50)];
    planet.physicsBody.velocity = ccp(0, 0);
    planet.position = [sun convertToNodeSpace:tmp_pos];
    [planet removeFromParent];
    planet.physicsBody = nil;
    
    /*if hit any other planet, call game over popup*/
    for(CCNode *child in _sun.children){
        float distance = (child.position.x-planet.position.x)*(child.position.x-planet.position.x)+(child.position.y-planet.position.y)*(child.position.y-planet.position.y);
        float width = planet.contentSizeInPoints.width*planet.scale;
        if(distance < width*width){
            self.paused = YES;
            Popup *popup = (Popup *)[CCBReader load:@"LosePopup" owner:self];
            popup.position = ccp(0,0);
            [self addChild:popup];
            return YES;
        }
    }
    
    /*else add the planet to the sun, add score and see if the player wins*/
    [_sun addChild:planet];
    _scoreval++;
    _scorelabel.string = [NSString stringWithFormat:@"%d", _scoreval];
    if(_scoreval == _scorereq){
        self.paused = YES;
        Popup *popup = (Popup *)[CCBReader load:@"WinPopup" owner:self];
        popup.position = ccp(0,0);
        [self addChild:popup];
        return YES;
    }
    return NO;
}


- (void)loadnextLevel {
    
    selectedLevel = _sun.nextLevelName;
    
    CCScene *nextScene = nil;
    
    if (selectedLevel) {
        nextScene = [CCBReader loadAsScene:@"Gameplay"];
    } else {
        selectedLevel = kFirstLevel;
        nextScene = [CCBReader loadAsScene:@"MainScene"];
    }
    
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:nextScene withTransition:transition];
}

- (void)retry {
    CCScene *nextScene = [CCBReader loadAsScene:@"Gameplay"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:nextScene withTransition:transition];
}

@end
