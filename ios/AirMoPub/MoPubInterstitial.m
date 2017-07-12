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
#import "MoPubInterstitial.h"
#import "AirMoPub.h"

#import "NSObject+Properties.h"
#import "MPInterstitialAdManager.h"

@interface MoPubInterstitial () {
}

@property(nonatomic, assign) FREContext context;
@property(nonatomic, assign) MPInterstitialAdController* interstitial;

@end

@implementation MoPubInterstitial

@synthesize context, interstitial;

- (id)initWithContext:(FREContext)extensionContext adUnitId:(NSString*)adUnitId {
    
    self = [super init];
    
    if (self) {
        self.context = extensionContext;
        self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:adUnitId];
        self.interstitial.delegate = self;
    }
    return self;
}

- (void)dealloc {
    
    if (self.interstitial) {
        
        self.interstitial.delegate = nil;
        self.interstitial = nil;
    }
    
    [super dealloc];
}

- (BOOL)getIsReady {
    
    return self.interstitial.ready;
}

- (void)setTesting:(BOOL)value {
    
    self.interstitial.testing = value;
}

- (void)loadInterstitial {
    
    [self.interstitial loadAd];
}

- (BOOL)showInterstitial {
    
    if (self.interstitial.ready) {
        [self.interstitial showFromViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
        return YES;
    }
    return NO;
}

- (void)setKeywords:(NSString*)keywords {
    
    [self.interstitial setKeywords:keywords];
}

- (void)interstitialDidLoadAd:(MPInterstitialAdController*)interstitial {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"", (const uint8_t*)"interstitialLoaded");
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController*)interstitial {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"", (const uint8_t*)"interstitialFailedToLoad");
}

- (void)interstitialDidDisappear:(MPInterstitialAdController*)interstitial {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"", (const uint8_t*)"interstitialClosed");
}

- (void)interstitialDidExpire:(MPInterstitialAdController*)interstitial {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"", (const uint8_t*)"interstitialExpired");
}

@end

#pragma mark - C interface

DEFINE_ANE_FUNCTION(interstitial_init) {
    
    NSString* adUnitId = FPANE_FREObjectToNSString(argv[0]);
    MoPubInterstitial* controller = [[MoPubInterstitial alloc] initWithContext:context adUnitId:adUnitId];
    FRESetContextNativeData(context, (__bridge void*)(controller));
    
    return NULL;
}

DEFINE_ANE_FUNCTION(interstitial_getIsReady) {
    
    MoPubInterstitial* controller;
    FREGetContextNativeData(context, (void**)&controller);
    if (controller == nil)
        return FPANE_CreateError(@"Context does not have an interstitial controller", 0);
    
    return FPANE_BOOLToFREObject([controller getIsReady]);
}

DEFINE_ANE_FUNCTION(interstitial_setTesting) {
    
    MoPubInterstitial* controller;
    FREGetContextNativeData(context, (void**)&controller);
    if (controller == nil)
        return FPANE_CreateError(@"Context does not have an interstitial controller", 0);
    
    [controller setTesting:FPANE_FREObjectToBool(argv[0])];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(interstitial_getTesting) {
    
    MoPubInterstitial* controller;
    FREGetContextNativeData(context, (void**)&controller);
    if (controller == nil)
        return FPANE_CreateError(@"Context does not have an interstitial controller", 0);
    
    return FPANE_BOOLToFREObject(controller.interstitial.testing);
}

DEFINE_ANE_FUNCTION(interstitial_loadInterstitial) {
    
    MoPubInterstitial* controller;
    FREGetContextNativeData(context, (void**)&controller);
    if (controller == nil)
        return FPANE_CreateError(@"Context does not have an interstitial controller", 0);
    
    [controller loadInterstitial];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(interstitial_showInterstitial) {
    
    MoPubInterstitial* controller;
    FREGetContextNativeData(context, (void**)&controller);
    if (controller == nil)
        return FPANE_CreateError(@"Context does not have an interstitial controller", 0);
    
    return FPANE_BOOLToFREObject([controller showInterstitial]);
}

DEFINE_ANE_FUNCTION(interstitial_setKeywords) {
    
    MoPubInterstitial* controller;
    FREGetContextNativeData(context, (void**)&controller);
    if (controller == nil)
        return FPANE_CreateError(@"Context does not have an interstitial controller", 0);
    
    [controller setKeywords:FPANE_FREObjectToNSString(argv[0])];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(interstitial_data) {
    
    MoPubInterstitial* controller;
    FREGetContextNativeData(context, (void**)&controller);
    
    if (controller == nil)
        return FPANE_CreateError(@"Context does not have an interstitial controller", 0);
    
    if (controller.interstitial != nil) {
        
        NSDictionary* interstitialProperties = [controller.interstitial propertiesPlease];
        MPInterstitialAdManager* adManager = [interstitialProperties objectForKey:@"manager"];
        
        if (adManager != nil)
            return [AirMoPub dataStringFromAdManager:adManager];
    }
    
    return NULL;
}

# pragma mark - list functions

void MoPubInterstitialListFunctions(const FRENamedFunction** functionsToSet, uint32_t* numFunctionsToSet) {
    
    static FRENamedFunction functions[] = {
        MAP_FUNCTION(interstitial_init, NULL),
        MAP_FUNCTION(interstitial_getIsReady, NULL),
        MAP_FUNCTION(interstitial_setTesting, NULL),
        MAP_FUNCTION(interstitial_getTesting, NULL),
        MAP_FUNCTION(interstitial_loadInterstitial, NULL),
        MAP_FUNCTION(interstitial_showInterstitial, NULL),
        MAP_FUNCTION(interstitial_setKeywords, NULL),
        MAP_FUNCTION(interstitial_data, NULL)
    };
    
    *numFunctionsToSet = sizeof(functions) / sizeof(FRENamedFunction);
    *functionsToSet = functions;
}