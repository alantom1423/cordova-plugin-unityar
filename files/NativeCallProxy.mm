#import <Foundation/Foundation.h>
#import "NativeCallProxy.h"

@implementation FrameworkLibAPI

id<NativeCallsProtocol> api = NULL;
+(void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) aApi
{
    api = aApi;
}

@end


extern "C" {
    void showHostMainWindow(const char* color) { 
        return [api showHostMainWindow:[NSString stringWithUTF8String:color]];
    }

    void sendMessageToCordova(const char* receivedMessage) 
    {
        return [api messageSendToCordova:[NSString stringWithUTF8String:receivedMessage]];
    }

    void quitUnityPlayer(const char* feedbackMsg)
    {
        return [api quitunityPlayer:[NSString stringWithUTF8String:feedbackMsg]];
    }
}

