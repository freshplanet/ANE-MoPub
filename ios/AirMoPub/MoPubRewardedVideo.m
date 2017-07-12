/*
 * Copyright 2017 FreshPlanet
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#import "MoPubRewardedVideo.h"
#import "FPANEUtils.h"
#import "MoPub.h"
#import "AirMoPub.h"

#import "NSObject+Properties.h"
#import "MPRewardedVideo+Singleton.h"
#import "MPRewardedVideoAdManager.h"

@interface MoPubRewardedVideo () {
}

@property(nonatomic, assign) FREContext context;
@property(nonatomic, assign) NSString* adUnitId;

@end

@implementation MoPubRewardedVideo

@synthesize context;

- (id)initWithContext:(FREContext)extensionContext adUnitId:(NSString*)adUnitId {
    
    if (self = [super init]) {
        
        self.context = extensionContext;
        self.adUnitId = adUnitId;
        
        [[MoPub sharedInstance] initializeRewardedVideoWithGlobalMediationSettings:nil delegate:self];
    }
    
    return self;
}

- (void)dealloc {
    
    self.context = nil;
    self.adUnitId = nil;
    
    [super dealloc];
}

- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString*)adUnitID {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"didLoad", (const uint8_t*)[adUnitID UTF8String]);
}

- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString*)adUnitID error:(NSError*)error {
    
    NSString* errorString = [MoPubRewardedVideo errorStringWithCode:error.code];
    FREDispatchStatusEventAsync(context, (const uint8_t*)"didFailToLoad", (const uint8_t*)[errorString UTF8String]);
}

- (void)rewardedVideoAdDidFailToPlayForAdUnitID:(NSString*)adUnitID error:(NSError*)error {
    
    NSString* errorString = [MoPubRewardedVideo errorStringWithCode:error.code];
    FREDispatchStatusEventAsync(context, (const uint8_t*)"didFailToPlay", (const uint8_t*)[errorString UTF8String]);
}

- (void)rewardedVideoAdWillAppearForAdUnitID:(NSString*)adUnitID {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"willAppear", (const uint8_t*)[adUnitID UTF8String]);
}

- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString*)adUnitID {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"didAppear", (const uint8_t*)[adUnitID UTF8String]);
}

- (void)rewardedVideoAdWillDisappearForAdUnitID:(NSString*)adUnitID {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"willDisappear", (const uint8_t*)[adUnitID UTF8String]);
}

- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString*)adUnitID {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"didDisappear", (const uint8_t*)[adUnitID UTF8String]);
}

- (void)rewardedVideoAdDidExpireForAdUnitID:(NSString*)adUnitID {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"didExpire", (const uint8_t*)[adUnitID UTF8String]);
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString*)adUnitID {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"didReceiveTapEvent", (const uint8_t*)[adUnitID UTF8String]);
}

- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString*)adUnitID reward:(MPRewardedVideoReward*)reward {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"didComplete", (const uint8_t*)[adUnitID UTF8String]);
}

- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString*)adUnitID {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"willLeaveApplication", (const uint8_t*)[adUnitID UTF8String]);
}

+ (NSString*)errorStringWithCode:(NSUInteger)code {
    
    switch (code) {
        case MPRewardedVideoAdErrorUnknown:
            return @"MPRewardedVideoAdErrorUnknown";
        
        case MPRewardedVideoAdErrorTimeout:
            return @"MPRewardedVideoAdErrorTimeout";
        
        case MPRewardedVideoAdErrorAdUnitWarmingUp:
            return @"MPRewardedVideoAdErrorAdUnitWarmingUp";
        
        case MPRewardedVideoAdErrorNoAdsAvailable:
            return @"MPRewardedVideoAdErrorNoAdsAvailable";
        
        case MPRewardedVideoAdErrorInvalidCustomEvent:
            return @"MPRewardedVideoAdErrorInvalidCustomEvent";
        
        case MPRewardedVideoAdErrorMismatchingAdTypes:
            return @"MPRewardedVideoAdErrorMismatchingAdTypes";
        
        case MPRewardedVideoAdErrorAdAlreadyPlayed:
            return @"MPRewardedVideoAdErrorAdAlreadyPlayed";
        
        case MPRewardedVideoAdErrorInvalidAdUnitID:
            return @"MPRewardedVideoAdErrorInvalidAdUnitID";
        
        default:
            break;
    }
    
    return @"";
}

@end

#pragma mark - C interface

DEFINE_ANE_FUNCTION(reward_init) {
    
    NSString* adUnitId = FPANE_FREObjectToNSString(argv[0]);
    
    MoPubRewardedVideo* controller = [[MoPubRewardedVideo alloc] initWithContext:context adUnitId:adUnitId];
    FRESetContextNativeData(context, (__bridge void*)(controller));
    
    return NULL;
}

DEFINE_ANE_FUNCTION(reward_load) {
    
    MoPubRewardedVideo* controller;
    FREGetContextNativeData(context, (void**)&controller);
    
    if (controller == nil)
        return FPANE_CreateError(@"Context does not have a rewarded video controller", 0);
    
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:controller.adUnitId withMediationSettings:nil];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(reward_show) {
    
    MoPubRewardedVideo* controller;
    FREGetContextNativeData(context, (void**)&controller);
    
    if (controller == nil)
        return FPANE_CreateError(@"Context does not have a rewarded video controller", 0);
    
    UIApplication* sharedApplication = [UIApplication sharedApplication];
    UIWindow* keyWindow = sharedApplication.keyWindow;
    UIViewController* rootViewController = keyWindow.rootViewController;
    
    [MPRewardedVideo presentRewardedVideoAdForAdUnitID:controller.adUnitId fromViewController:rootViewController];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(reward_has) {
    
    MoPubRewardedVideo* controller;
    FREGetContextNativeData(context, (void**)&controller);
    
    if (controller == nil)
        return FPANE_CreateError(@"Context does not have a rewarded video controller", 0);
    
    BOOL isReady = [MPRewardedVideo hasAdAvailableForAdUnitID:controller.adUnitId];
    
    return FPANE_BOOLToFREObject(isReady);
}

DEFINE_ANE_FUNCTION(reward_data) {
    
    MoPubRewardedVideo* controller;
    FREGetContextNativeData(context, (void**)&controller);
    
    if (controller == nil)
        return FPANE_CreateError(@"Context does not have a rewarded video controller", 0);
    
    MPRewardedVideo* rewarded = [MPRewardedVideo sharedInstance];
    
    if (rewarded != nil) {
        
        NSDictionary* rewardedProperties = [rewarded propertiesPlease];
        NSMutableDictionary* adManagers = [rewardedProperties objectForKey:@"rewardedVideoAdManagers"];
        
        if (adManagers != nil) {
            
            MPRewardedVideoAdManager* adManager = [adManagers objectForKey:controller.adUnitId];
            
            if (adManager != nil)
                return [AirMoPub dataStringFromAdManager:adManager];
        }
    }
    
    return NULL;
}

# pragma mark - list functions

void MoPubRewardedVideoListFunctions(const FRENamedFunction** functionsToSet, uint32_t* numFunctionsToSet) {
    
    static FRENamedFunction functions[] = {
            MAP_FUNCTION(reward_init, NULL),
            MAP_FUNCTION(reward_load, NULL),
            MAP_FUNCTION(reward_show, NULL),
            MAP_FUNCTION(reward_has, NULL),
            MAP_FUNCTION(reward_data, NULL)
    };
    
    *numFunctionsToSet = sizeof(functions) / sizeof(FRENamedFunction);
    *functionsToSet = functions;
}

