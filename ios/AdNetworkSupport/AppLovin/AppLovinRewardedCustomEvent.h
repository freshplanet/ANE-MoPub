//
//  AppLovinRewardedCustomEvent.h
//  MoPub Rewarded Adapter
//
//  Created on 10/14/15.
//  Copyright © 2015 Applovin. All rights reserved.
//

#import "MPRewardedVideoCustomEvent.h"
#import "ALAdLoadDelegate.h"
#import "ALAdDisplayDelegate.h"
#import "ALAdRewardDelegate.h"
#import "ALAdVideoPlaybackDelegate.h"

@interface AppLovinRewardedCustomEvent
    : MPRewardedVideoCustomEvent <ALAdLoadDelegate, ALAdDisplayDelegate,
                                  ALAdRewardDelegate, ALAdVideoPlaybackDelegate>

@end
