//
//  HyprMXRewardedVideoCustomEvent.h
//  HyprMX MoPubSDK Adapter

#import <HyprMX/HyprMX.h>
#import <Foundation/Foundation.h>

#import "MoPub.h"
#import "MPRewardedVideoCustomEvent.h"
#import "HyprMXGlobalMediationSettings.h"

@interface HyprMXRewardedVideoCustomEvent : MPRewardedVideoCustomEvent

/**
 * This method returns the version of the HyprMXRewardedVideo Adapter
 *
 * @return - An NSInteger version number of the adapter
 */
+ (NSInteger)adapterVersion;

/**
 * This method returns the version of HyprMarketplace
 *
 * @return - An NSString version of the HyprMarketplace SDK
 */
+ (NSString *)hyprMXSdkVersion;

@end
