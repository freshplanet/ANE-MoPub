//
// AppLovin <--> MoPub Network Adaptors
//

#import "MPInterstitialCustomEvent.h"

#import "ALInterstitialAd.h"
#import "ALAdService.h"

@interface AppLovinInterstitialCustomEvent : MPInterstitialCustomEvent <ALAdLoadDelegate, ALAdDisplayDelegate>

@property (strong, nonatomic) ALInterstitialAd* interstitialAd;
@property (strong, nonatomic) ALAd* loadedAd;

@end
