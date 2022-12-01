#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import <React/RCTBridgeModule.h>
#import "ReactNativeUnityView.h"
#include <UnityFramework/UnityFramework.h>

@interface ReactNativeUnityViewManager : RCTViewManager <RCTBridgeModule>
@end

@implementation ReactNativeUnityViewManager

RCT_EXPORT_MODULE(ReactNativeUnityView)
RCT_EXPORT_VIEW_PROPERTY(onUnityMessage, RCTBubblingEventBlock)


- (UIView *)view
{
    ReactNativeUnityView *unity = [[ReactNativeUnityView alloc] init];
    UIWindow * main = [[[UIApplication sharedApplication] delegate] window];

    if(main != nil) {
        [main makeKeyAndVisible];
    }

    return unity;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

RCT_EXPORT_METHOD(postMessage:(nonnull NSNumber*) reactTag gameObject:(NSString*_Nonnull) gameObject methodName:(NSString*_Nonnull) methodName message:(NSString*_Nonnull) message) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        ReactNativeUnityView *view = (ReactNativeUnityView*) viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[ReactNativeUnityView class]]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
            return;
        }
        [ReactNativeUnityView UnityPostMessage:(NSString *)gameObject methodName:(NSString *)methodName message:(NSString *)message];
    }];
}


- (NSArray<NSString *> *)supportedEvents {
    return @[@"onUnityMessage"];
}


@end
