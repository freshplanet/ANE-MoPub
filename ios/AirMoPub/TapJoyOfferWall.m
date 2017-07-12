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
#import "TapJoyOfferWall.h"
#import "FPANEUtils.h"

@interface TapJoyOfferWall () {
}

@property(nonatomic, assign) FREContext context;
@property(nonatomic, assign) TJPlacement* offerWallPlacement;

@end

@implementation TapJoyOfferWall

@synthesize context, offerWallPlacement;

- (id)initWithContext:(FREContext)extensionContext {
    
    if (self = [super init])
        self.context = extensionContext;
    
    return self;
}

- (void)dealloc {
    
    [super dealloc];
}

- (void)requestDidSucceed:(TJPlacement*)placement {
    
    FREDispatchStatusEventAsync(context,
                                (const uint8_t*)"didLoad",
                                (const uint8_t*)[placement.placementName UTF8String]);
}

- (void)requestDidFail:(TJPlacement*)placement error:(NSError*)error {
    
    FREDispatchStatusEventAsync(context,
                                (const uint8_t*)"didFailToLoad",
                                (const uint8_t*)[error.localizedDescription UTF8String]);
    self.offerWallPlacement = nil;
}

- (void)contentIsReady:(TJPlacement*)placement {
    
    FREDispatchStatusEventAsync(context,
                                (const uint8_t*)"didBecomeReady",
                                (const uint8_t*)[placement.placementName UTF8String]);
}

- (void)contentDidAppear:(TJPlacement*)placement {
    
    FREDispatchStatusEventAsync(context,
                                (const uint8_t*)"didAppear",
                                (const uint8_t*)[placement.placementName UTF8String]);
}

- (void)contentDidDisappear:(TJPlacement*)placement {
    
    FREDispatchStatusEventAsync(context,
                                (const uint8_t*)"didDisappear",
                                (const uint8_t*)[placement.placementName UTF8String]);
    self.offerWallPlacement = nil;
}

- (void)placement:(TJPlacement*)placement didRequestPurchase:(TJActionRequest*)request productId:(NSString*)productId {
    
    FREDispatchStatusEventAsync(context,
                                (const uint8_t*)"didRequestPurchase",
                                (const uint8_t*)[placement.placementName UTF8String]);
}

- (void)placement:(TJPlacement*)placement
 didRequestReward:(TJActionRequest*)request
           itemId:(NSString*)itemId
         quantity:(int)quantity {
    
    FREDispatchStatusEventAsync(context,
                                (const uint8_t*)"didRequestReward",
                                (const uint8_t*)[placement.placementName UTF8String]);
}

@end

#pragma mark - C interface

DEFINE_ANE_FUNCTION(offerwall_init) {
    
    TapJoyOfferWall* controller = [[TapJoyOfferWall alloc] initWithContext:context];
    FRESetContextNativeData(context, (__bridge void*)(controller));
    
    return NULL;
}

DEFINE_ANE_FUNCTION(offerwall_load) {
    
    TapJoyOfferWall* controller;
    FREGetContextNativeData(context, (void**)&controller);
    
    if (controller == nil)
        return FPANE_CreateError(@"Context does not have an offer wall controller", 0);
    
    controller.offerWallPlacement = [TJPlacement placementWithName:@"offerwall" delegate:controller];
    [controller.offerWallPlacement requestContent];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(offerwall_show) {
    
    TapJoyOfferWall* controller;
    FREGetContextNativeData(context, (void**)&controller);
    
    if (controller == nil)
        return FPANE_CreateError(@"Context does not have an offer wall controller", 0);
    
    UIApplication* app = [UIApplication sharedApplication];
    UIWindow* appWindow = app.keyWindow;
    
    if (controller.offerWallPlacement)
        [controller.offerWallPlacement showContentWithViewController:appWindow.rootViewController];
    else
        return FPANE_CreateError(@"offerWallPlacement is nil", 0);
    
    return NULL;
}

DEFINE_ANE_FUNCTION(offerwall_ready) {
    
    TapJoyOfferWall* controller;
    FREGetContextNativeData(context, (void**)&controller);
    
    if (controller == nil)
        return FPANE_CreateError(@"Context does not have an offer wall controller", 0);
    
    BOOL ready = controller.offerWallPlacement && controller.offerWallPlacement.contentReady &&
                 controller.offerWallPlacement.contentAvailable;
    return FPANE_BOOLToFREObject(ready);
}

DEFINE_ANE_FUNCTION(offerwall_setuserid) {
    
    NSString* userId = FPANE_FREObjectToNSString(argv[0]);
    [Tapjoy setUserID:userId];
    
    return NULL;
}

# pragma mark - list functions

void TapJoyOfferWallListFunctions(const FRENamedFunction** functionsToSet, uint32_t* numFunctionsToSet) {
    
    static FRENamedFunction functions[] = {
        MAP_FUNCTION(offerwall_init, NULL),
        MAP_FUNCTION(offerwall_load, NULL),
        MAP_FUNCTION(offerwall_show, NULL),
        MAP_FUNCTION(offerwall_ready, NULL),
        MAP_FUNCTION(offerwall_setuserid, NULL)
    };
    
    *numFunctionsToSet = sizeof(functions) / sizeof(FRENamedFunction);
    *functionsToSet = functions;
}