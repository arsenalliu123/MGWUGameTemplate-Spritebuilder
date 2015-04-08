//
//  Popup.m
//  Shootem
//
//  Created by River on 2/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Popup.h"

@implementation Popup

- (void) sharing{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"http://rivo.me"];
    content.contentTitle = @"Test shootem!";
    content.contentDescription = @"This is a ios Mobile Game Development Course project";
    FBSDKShareButton *button = [[FBSDKShareButton alloc] init];
    button.shareContent = content;

    button.center = CGPointMake(10.0f, 10.0f);
    [[[CCDirector sharedDirector] view]addSubview:button];
    
}

@end
