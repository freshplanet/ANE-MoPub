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
#import "AirMoPub.h"

#import "MoPub.h"

#import "MoPubBanner.h"
#import "MoPubInterstitial.h"
#import "MoPubRewardedVideo.h"
#import "TapJoyOfferWall.h"
#import "MPAdConversionTracker.h"

#import "NSObject+Properties.h"
#import "MPAdServerCommunicator.h"
#import "MPAdConfiguration.h"
#import "MPLogEvent.h"
#import "MPGeolocationProvider.h"

#import "ALSdk.h"
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <MMAdSDK/MMAdSDK.h>
#import <Tapjoy/Tapjoy.h>
#import <UnityAds/UnityAds.h>
#import <VungleSDK/VungleSDK.h>
#import <Supersonic/Supersonic.h>
#import <HyprMX/HyprMX.h>
#import <Chartboost/Chartboost.h>

@implementation AirMoPub

static unsigned int const TOTAL_NETWORKS = 12;
static NSString* const NETWORKS[TOTAL_NETWORKS] = {
        @"adcolony",
        @"applovin",
        @"chartboost",
        @"facebook",
        @"google",
        @"inmobi",
        @"millenial",
        @"tapjoy",
        @"unity",
        @"vungle",
        @"supersonic",
        @"hypermx"
};

+ (FREObject*)dataStringFromAdManager:(id)manager {
    
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    
    NSDictionary* managerProps = [manager propertiesPlease];
    MPAdServerCommunicator* communicator = [managerProps objectForKey:@"communicator"];
    MPAdConfiguration* configuration = [managerProps objectForKey:@"configuration"];
    
    if (communicator != nil) {
        
        NSDictionary* communicatorProps = [communicator propertiesPlease];
        NSURL* URL = [communicatorProps objectForKey:@"URL"];
        MPLogEvent* adRequestLatencyEvent = [communicatorProps objectForKey:@"adRequestLatencyEvent"];
        
        NSString* url = [NSString stringWithFormat:@"%@", URL];
        [data setObject:url forKey:@"url"];
        
        if (adRequestLatencyEvent != nil && adRequestLatencyEvent.requestId != nil) {
            
            NSString* requestId = [NSString stringWithString:adRequestLatencyEvent.requestId];
            [data setObject:requestId forKey:@"requestId"];
        }
    }
    
    if (configuration != nil && [@"" respondsToSelector:@selector(localizedCaseInsensitiveContainsString:)]) {
        
        if (configuration.creativeId != nil) {
            
            NSString* creativeId = [NSString stringWithString:configuration.creativeId];
            [data setObject:creativeId forKey:@"creativeId"];
        }
        
        NSString* class = [NSString stringWithFormat:@"%@", configuration.customEventClass];
        NSString* network = nil;
        
        for (int i = 0; i < TOTAL_NETWORKS; i++) {
            
            if ([class localizedCaseInsensitiveContainsString:NETWORKS[i]]) {
                
                network = NETWORKS[i];
                break;
            }
        }
        
        if (network == nil)
            network = @"mopub";
        
        [data setObject:network forKey:@"network"];
    }
    
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    NSString* jsonString = nil;
    
    if (jsonData != nil)
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    FREObject* freObj = FPANE_NSStringToFREObject(jsonString);
    
    return freObj;
}

@end

DEFINE_ANE_FUNCTION(setupNetworks) {
    
    BOOL debug = FPANE_FREObjectToBool(argv[0]);
    
    NSString* inMobiAppId = FPANE_FREObjectToNSString(argv[1]);
    NSString* tapJoySdkKey = FPANE_FREObjectToNSString(argv[2]);
    
    if (inMobiAppId) {

//        [InMobi initialize:inMobiAppId];
//        [InMobiBannerCustomEvent setAppId:inMobiAppId];
//        [InMobiInterstitialCustomEvent setAppId:inMobiAppId];
    }

#ifdef _TAPJOY_H
    if (tapJoySdkKey) {
        
        [Tapjoy setDebugEnabled:debug];
        [Tapjoy connect:tapJoySdkKey];
    }
#endif
    
    return NULL;
}

DEFINE_ANE_FUNCTION(getSdkVersions) {
    
    NSString* mopub = [[MoPub sharedInstance] version];
    NSString* adcolony = @"";
    NSString* applovin = [ALSdk version];
    NSString* chartboost = [Chartboost getSDKVersion];
    NSString* facebook = FB_AD_SDK_VERSION;
    NSString* google = [NSString stringWithFormat:@"%s", GoogleMobileAdsVersionString];
    NSString* millennial = [[MMSDK sharedInstance] version];
    NSString* tapjoy = [Tapjoy getVersion];
    NSString* unity = [UnityAds getVersion];
    NSString* vungle = VungleSDKVersion;
    NSString* supersonic = [[Supersonic sharedInstance] getVersion];
    NSString* hypermarketplace = [[HYPRManager sharedManager] versionString];
    
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    
    [data setObject:mopub forKey:@"mopub"];
    [data setObject:adcolony forKey:@"adcolony"];
    [data setObject:applovin forKey:@"applovin"];
    [data setObject:chartboost forKey:@"chartboost"];
    [data setObject:facebook forKey:@"facebook"];
    [data setObject:google forKey:@"google"];
    [data setObject:millennial forKey:@"millennial"];
    [data setObject:tapjoy forKey:@"tapjoy"];
    [data setObject:unity forKey:@"unity"];
    [data setObject:vungle forKey:@"vungle"];
    [data setObject:supersonic forKey:@"supersonic"];
    [data setObject:hypermarketplace forKey:@"hypermarketplace"];
    
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    NSString* jsonString = nil;
    
    if (jsonData != nil)
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    FREObject* freObj = FPANE_NSStringToFREObject(jsonString);
    
    return freObj;
}

void AirMoPubContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet,
                                const FRENamedFunction** functionsToSet) {
    
    if (strcmp((char*)ctxType, "banner") == 0)
        MoPubBannerListFunctions(functionsToSet, numFunctionsToSet);
    else if (strcmp((char*)ctxType, "interstitial") == 0)
        MoPubInterstitialListFunctions(functionsToSet, numFunctionsToSet);
    else if (strcmp((char*)ctxType, "rewardVideo") == 0)
        MoPubRewardedVideoListFunctions(functionsToSet, numFunctionsToSet);
    else if (strcmp((char*)ctxType, "offerWall") == 0)
        TapJoyOfferWallListFunctions(functionsToSet, numFunctionsToSet);
    else {
        
        static FRENamedFunction functions[] = {
            MAP_FUNCTION(setupNetworks, NULL),
            MAP_FUNCTION(getSdkVersions, NULL)
        };
        
        *numFunctionsToSet = sizeof(functions) / sizeof(FRENamedFunction);
        *functionsToSet = functions;
    }
}

void AirMoPubContextFinalizer(FREContext ctx) {
    
    CFTypeRef nativeData;
    FREGetContextNativeData(ctx, (void**)&nativeData);
    
    if (nativeData != nil) {
        
        if ([nativeData isKindOfClass:[MoPubBanner class]]) {
            [(MoPubBanner*)nativeData removeFromSuperview];
        }
        else if ([nativeData isKindOfClass:[MoPubInterstitial class]]) {
        }
        else if ([nativeData isKindOfClass:[MoPubRewardedVideo class]]) {
        }
        
        CFBridgingRelease(nativeData);
    }
    
    return;
}

void AirMoPubInitializer(void** extDataToSet,
                         FREContextInitializer* ctxInitializerToSet,
                         FREContextFinalizer* ctxFinalizerToSet) {
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &AirMoPubContextInitializer;
    *ctxFinalizerToSet = &AirMoPubContextFinalizer;
    
    [[MPGeolocationProvider sharedProvider] setLocationUpdatesEnabled:NO];
}

void AirMoPubFinalizer(void* extData) {
}


