/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AppDelegate.h"
#import "CCBuilderReader.h"

@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
    // Do any extra configuration of Cocos2d here (the example line changes the pixel format for faster rendering, but with less colors)
    //[cocos2dSetup setObject:kEAGLColorFormatRGB565 forKey:CCConfigPixelFormat];
    
    [self setupCocos2dWithOptions:cocos2dSetup];
    
    
    // This is the only app delegate method you need to implement when inheriting from CCAppDelegate.
    // This method is a good place to add one time setup code that only runs when your app is first launched.

    
    self.isBannerOn=false;
    self.isBannerOnTop = true;
    mIAd = [[MyiAd alloc] init];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

-(void)ShowIAdBanner
{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"adDisabled"]!=0)
    {
        self.isBannerOn = false;
        [self hideIAdBanner];
        return;
    }
    
    self.isBannerOn = true;
    
    if(mIAd)
    {
        [mIAd showBannerView];
    }
    else
    {
        mIAd = [[MyiAd alloc] init];
    }
}


-(void)hideIAdBanner
{
    self.isBannerOn = false;
    if(mIAd)
        [mIAd hideBannerView];
}

-(void)bannerDidFail
{
    mIAd = nil;
    
#if TARGET_IPHONE_SIMULATOR
    UIAlertView* alert= [[UIAlertView alloc] initWithTitle: @"Simulator_ShowAlert!" message: @"didFailToReceiveAdWithError:"
                                                  delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL];
    [alert show];
#endif
}


- (CCScene*) startScene
{
    return [CCBReader loadAsScene:@"MainScene"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[CCDirector sharedDirector] pause];
    [[CCDirector sharedDirector] stopAnimation];
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    if(audio.bgPlaying){
        [audio setBgPaused:YES];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation]; // Add
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    if(audio.bgPaused){
        [audio playBg];
    }
}

- (void)dealloc {
    [[CCDirector sharedDirector] end];
}

@end
