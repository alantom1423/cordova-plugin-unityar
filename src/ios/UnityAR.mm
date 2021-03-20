/********* UnityAR.m Cordova Plugin Implementation *******/
//  UnityAR.mm
//
//  Created by ___ALAN JOSE___ on ___17/03/2021___.
//  Copyright ___ALAN JOSE___ ___2021___. All rights reserved.
//


#import "UnityAR.h"
#import "AppDelegate.h"

BOOL initialized = false;
NSString *pluginCallbackId = @"";

@implementation UnityAR

- (void)launchUnity:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSDictionary* objParams = [self getArgsObject:command.arguments];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate assignUnityAR:self];
    [appDelegate initUnity:objParams];
}

- (void)launchwithMessage:(CDVInvokedUrlCommand *)command
{
    pluginCallbackId = command.callbackId;
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"Launched Unity with message"]];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];

    NSDictionary* obj = [self getArgsObject:command.arguments];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate assignUnityAR:self];
    [appDelegate initUnity:obj];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)messageToCordova:(NSString*) message
{
    [self sendMessage:message];
}

- (void) sendMessage:(NSString*) msg
{
    CDVPluginResult *pluginResult  = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:msg]];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:pluginCallbackId];
}

+ (UnityAR *)getInstance
{
    static UnityAR *UnityARInstance;
    @synchronized(self)
    {
        if (!UnityARInstance)
        {
            // This is never freed.  Is a singleton a leak?
            UnityARInstance = [[UnityAR alloc] init];
        }
    }
    return UnityARInstance;
}

//General method
-(NSDictionary*) getArgsObject:(NSArray *)args
{
    if(args == nil)
    {
        return nil;
    }
    if (args.count != 1)
    {
      return nil;
    }
    NSObject* arg = [args objectAtIndex:0];
    if (![arg isKindOfClass:[NSDictionary class]]) {
      return nil;
    }

    return (NSDictionary *)[args objectAtIndex:0];
}

@end
