//
//  Sun.h
//  Shootem
//
//  Created by River on 2/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Sun : CCSprite

@property (nonatomic, assign) int requirement;
@property (nonatomic, assign) float rotateduration;
@property (nonatomic, copy) NSString* nextLevelName;

@end
