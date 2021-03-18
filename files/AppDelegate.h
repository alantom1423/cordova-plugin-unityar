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
//  AppDelegate.h
//
//  Created by ___ALAN JOSE___ on ___17/03/2021___.
//  Copyright ___ALAN JOSE___ ___2021___. All rights reserved.
//

#import <Cordova/CDVViewController.h>
#import <Cordova/CDVAppDelegate.h>
#import <UIKit/UIKit.h>
#include <UnityFramework/UnityFramework.h>
#include <UnityFramework/NativeCallProxy.h>

#import "AppDelegate.h"
#import "UnityAR.h"

@interface AppDelegate : CDVAppDelegate<UIApplicationDelegate,UnityFrameworkListener,NativeCallsProtocol> {}

@property UnityFramework* ufw;
@property (readwrite, assign) UnityAR* unityar;
@property (nonatomic, strong) UIButton *quitBtn;

- (void)initUnity:(NSDictionary*) objParams;
- (void)ShowMainUnity:(NSDictionary*) objParams;
- (void)assignUnityAR:(UnityAR*) unityInstance;

@end
