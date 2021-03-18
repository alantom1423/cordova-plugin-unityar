/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//
//  Created by ___ALAN JOSE___ on ___17/03/2021___.
//  Copyright ___ALAN JOSE___ ___2021___. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

int gArgc = 0;
char** gArgv = nullptr;
NSDictionary* appLaunchOpts;
NSString* cordovaMsg;
AppDelegate* hostDelegate = NULL;

UnityFramework* UnityFrameworkLoad()
{
    NSString* bundlePath = nil;
    bundlePath = [[NSBundle mainBundle] bundlePath];
    bundlePath = [bundlePath stringByAppendingString: @"/Frameworks/UnityFramework.framework"];
    
    NSBundle* bundle = [NSBundle bundleWithPath: bundlePath];
    if ([bundle isLoaded] == false) [bundle load];
    
    UnityFramework* ufw = [bundle.principalClass getInstance];
    if (![ufw appController])
    {
        // unity is not initialized
        [ufw setExecuteHeader: &_mh_execute_header];
    }
    return ufw;
}

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    appLaunchOpts = launchOptions;
    hostDelegate = self;
    self.viewController = [[MainViewController alloc] init];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void) messageSendToCordova:(NSString*)message
{
    cordovaMsg = message;
}

- (void)quitunityPlayer:(NSString*)feedbackMsg
{
    [UnityFrameworkLoad() unloadApplication];
    cordovaMsg = feedbackMsg;
}

- (void)showHostMainWindow
{
    [self showHostMainWindow:@""];
}

- (void)showHostMainWindow:(NSString*)color
{
    [self.window makeKeyAndVisible];
}

- (void)ShowMainUnity:(NSDictionary*) objParams;
{
    [[self ufw] showUnityWindow];
    if(objParams)
       {
           [self sendMessageUnity: objParams];
       }
}

-(void) initUnity:(NSDictionary*) objParams;
{
    [self setUfw: UnityFrameworkLoad()];
    [[self ufw] setDataBundleId: "com.unity3d.framework"];
    [[self ufw] registerFrameworkListener: self];
    [NSClassFromString(@"FrameworkLibAPI") registerAPIforNativeCalls:self];
    [[self ufw] runEmbeddedWithArgc: gArgc argv: gArgv appLaunchOpts: appLaunchOpts];
    [[self ufw] appController].quitHandler = ^(){ NSLog(@"AppController.quitHandler called"); };
    
//    auto view = [[[self ufw] appController] rootView];
//    self.quitBtn = [UIButton buttonWithType: UIButtonTypeSystem];
//    [self.quitBtn setTitle: @"Back" forState: UIControlStateNormal];
//    [self.quitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.quitBtn.bounds = CGRectMake(0, 0, 70, 35);
//    self.quitBtn.center = CGPointMake(50, 35);
//    self.quitBtn.backgroundColor = [UIColor whiteColor];
//    [self.quitBtn addTarget: self action: @selector(quitButtonTouched:) forControlEvents: UIControlEventPrimaryActionTriggered];
//    [view addSubview: self.quitBtn];
    if(objParams)
    {
        [self sendMessageUnity: objParams];
    }
}

- (void)quitButtonTouched:(UIButton *)sender
{
    [UnityFrameworkLoad() unloadApplication];
}

- (void)unityDidUnload:(NSNotification*)notification
{
    NSLog(@"unityDidUnload called");
    
    [[self ufw] unregisterFrameworkListener: self];
    [self setUfw: nil];
    [self showHostMainWindow];
    [self.unityar sendMessage:cordovaMsg];
}

- (void)unityDidQuit:(NSNotification*)notification
{
    NSLog(@"unityDidQuit called");
    
    [[self ufw] unregisterFrameworkListener: self];
    [self setUfw: nil];
    [self showHostMainWindow];
}


- (void) assignUnityAR:(UnityAR *)unityInstance
{
    self.unityar = unityInstance;
}

- (void)sendMessageUnity:(NSDictionary*) paramstoPass
{
    NSString* gameObj = [paramstoPass valueForKey:@"gameobject"];
    NSString* fnctnName = [paramstoPass valueForKey:@"method"];
    NSString* argumentParam = [paramstoPass valueForKey:@"argument"];
    [[self ufw] sendMessageToGOWithName: [gameObj cStringUsingEncoding:[NSString defaultCStringEncoding]] functionName:[fnctnName cStringUsingEncoding:[NSString defaultCStringEncoding]] message:[argumentParam cStringUsingEncoding:[NSString defaultCStringEncoding]]];
}

@end

int main(int argc, char* argv[])
{
    gArgc = argc;
    gArgv = argv;
    @autoreleasepool
    {
        if (false)
        {
            // run UnityFramework as main app
            id ufw = UnityFrameworkLoad();
            // Set UnityFramework target for Unity-iPhone/Data folder to make Data part of a UnityFramework.framework and call to setDataBundleId
            // ODR is not supported in this case, ( if you need embedded and ODR you need to copy data )
            [ufw setDataBundleId: "com.unity3d.framework"];
            [ufw runUIApplicationMainWithArgc: argc argv: argv];
        } else {
            // run host app first and then unity later
            UIApplicationMain(argc, argv, nil, [NSString stringWithUTF8String: "AppDelegate"]);
        }
    }
    
    return 0;
}
