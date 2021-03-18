//
//  UnityAR.h
//
//  Created by ___ALAN JOSE___ on ___17/03/2021___.
//  Copyright ___ALAN JOSE___ ___2021___. All rights reserved.
//

#import <Cordova/CDV.h>

@interface UnityAR : CDVPlugin{
    
}

- (void)launchUnity:(CDVInvokedUrlCommand*)command;
- (void)launchwithMessage:(CDVInvokedUrlCommand *)command;
- (void)sendMessage:(NSString*) msg;

@end
