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
#import "MoPubBanner.h"

@interface MoPubBanner () {
}

@property(nonatomic, assign) FREContext context;
@property(nonatomic, assign) BOOL autoRefreshEnabled;

@end

@implementation MoPubBanner

@synthesize context;

- (id)initWithContext:(FREContext)extensionContext adUnitId:(NSString*)adUnitId size:(CGSize)size {
    
    self = [super initWithAdUnitId:adUnitId size:size];
    
    if (self) {
        self.context = extensionContext;
        self.delegate = self;
        self.autoRefreshEnabled = YES;
    }
    return self;
}

- (void)dealloc {
    
    self.delegate = nil;
    [super dealloc];
}

- (float)getDisplayDensity {
    
    return [UIScreen mainScreen].scale;
}

+ (CGSize)getAdSizeFromSizeId:(int)sizeId {
    
    switch (sizeId) {
        case 1:
            return MOPUB_BANNER_SIZE;
        case 2:
            return MOPUB_MEDIUM_RECT_SIZE;
        case 3:
            return MOPUB_LEADERBOARD_SIZE;
        case 4:
            return MOPUB_WIDE_SKYSCRAPER_SIZE;
        default:
            return MOPUB_BANNER_SIZE;
    }
}

- (BOOL)getAutorefresh {
    
    return self.autoRefreshEnabled;
}

- (void)setAutorefresh:(BOOL)value {
    
    if (value && !self.autoRefreshEnabled)
        [self startAutomaticallyRefreshingContents];
    else if (!value && self.autoRefreshEnabled)
        [self stopAutomaticallyRefreshingContents];
    
    self.autoRefreshEnabled = value;
}

- (int)getPositionX {
    
    return (int)round(self.frame.origin.x * [self getDisplayDensity]);
}

- (int)getPositionY {
    
    return (int)round(self.frame.origin.y * [self getDisplayDensity]);
}

- (int)getFrameWidth {
    
    return (int)round(self.frame.size.width * [self getDisplayDensity]);
}

- (int)getFrameHeight {
    
    return (int)round(self.frame.size.height * [self getDisplayDensity]);
}

- (void)setPositionX:(int)value {
    
    CGRect frame = self.frame;
    frame.origin.x = (float)value / [self getDisplayDensity];
    self.frame = frame;
}

- (void)setPositionY:(int)value {
    
    CGRect frame = self.frame;
    frame.origin.y = (float)value / [self getDisplayDensity];
    self.frame = frame;
}

- (void)setFrameWidth:(int)value {
    
    CGRect frame = self.frame;
    frame.size.width = (float)value / [self getDisplayDensity];
    self.frame = frame;
}

- (void)setFrameHeight:(int)value {
    
    CGRect frame = self.frame;
    frame.size.height = (float)value / [self getDisplayDensity];
    self.frame = frame;
}

- (void)setAdSize:(int)value {
    
    CGSize size = [MoPubBanner getAdSizeFromSizeId:value];
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (int)getCreativeWidth {
    
    return (int)round([self adContentViewSize].width * [self getDisplayDensity]);
}

- (int)getCreativeHeight {
    
    return (int)round([self adContentViewSize].height * [self getDisplayDensity]);
}

- (void)loadBanner {
    
    [self loadAd];
}

- (void)showBanner {
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
}

- (void)removeBanner {
    
    [self removeFromSuperview];
}

- (void)refresh {
    
    [self forceRefreshAd];
}

- (UIViewController*)viewControllerForPresentingModalView {
    
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

- (void)adViewDidLoadAd:(MPAdView*)view {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"", (const uint8_t*)"bannerLoaded");
}

- (void)adViewDidFailToLoadAd:(MPAdView*)view {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"", (const uint8_t*)"bannerFailedToLoad");
}

- (void)willPresentModalViewForAd:(MPAdView*)view {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"", (const uint8_t*)"bannerAdClicked");
}

- (void)didDismissModalViewForAd:(MPAdView*)view {
    
    FREDispatchStatusEventAsync(context, (const uint8_t*)"", (const uint8_t*)"bannerAdClosed");
}

@end

# pragma mark - C/as interface

DEFINE_ANE_FUNCTION(banner_init) {
    
    NSString* adUnitId = FPANE_FREObjectToNSString(argv[0]);
    
    CGSize adType;
    int32_t sizeId;
    FREGetObjectAsInt32(argv[1], &sizeId);
    adType = [MoPubBanner getAdSizeFromSizeId:sizeId];
    
    MoPubBanner* banner = [[MoPubBanner alloc] initWithContext:context adUnitId:adUnitId size:adType];
    FRESetContextNativeData(context, (__bridge void*)(banner));
    
    return NULL;
}

DEFINE_ANE_FUNCTION(banner_getAutorefresh) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    return FPANE_BOOLToFREObject([banner getAutorefresh]);
}

DEFINE_ANE_FUNCTION(banner_setAutorefresh) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    [banner setAutorefresh:FPANE_FREObjectToBool(argv[0])];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(banner_getPositionX) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    return FPANE_IntToFREObject([banner getPositionX]);
}

DEFINE_ANE_FUNCTION(banner_getPositionY) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    return FPANE_IntToFREObject([banner getPositionY]);
}

DEFINE_ANE_FUNCTION(banner_getFrameWidth) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    return FPANE_IntToFREObject([banner getFrameWidth]);
}

DEFINE_ANE_FUNCTION(banner_getFrameHeight) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    return FPANE_IntToFREObject([banner getFrameHeight]);
}

DEFINE_ANE_FUNCTION(banner_setPositionX) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    [banner setPositionX:(int)FPANE_FREObjectToInt(argv[0])];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(banner_setPositionY) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    [banner setPositionY:(int)FPANE_FREObjectToInt(argv[0])];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(banner_setFrameWidth) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    [banner setFrameWidth:(int)FPANE_FREObjectToInt(argv[0])];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(banner_setFrameHeight) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    [banner setFrameHeight:(int)FPANE_FREObjectToInt(argv[0])];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(banner_setAdSize) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    [banner setAdSize:(int)FPANE_FREObjectToInt(argv[0])];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(banner_getCreativeWidth) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    return FPANE_IntToFREObject([banner getCreativeWidth]);
}

DEFINE_ANE_FUNCTION(banner_getCreativeHeight) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    return FPANE_IntToFREObject([banner getCreativeHeight]);
}

DEFINE_ANE_FUNCTION(banner_loadBanner) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    [banner loadBanner];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(banner_showBanner) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    [banner showBanner];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(banner_removeBanner) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    [banner removeBanner];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(banner_refresh) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    [banner refresh];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(banner_setKeywords) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    [banner setKeywords:FPANE_FREObjectToNSString(argv[0])];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(banner_setTesting) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    [banner setTesting:FPANE_FREObjectToBool(argv[0])];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(banner_getTesting) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    return FPANE_BOOLToFREObject(banner.testing);
}

DEFINE_ANE_FUNCTION(banner_moveToDefaultPosition) {
    
    MoPubBanner* banner;
    FREGetContextNativeData(context, (void**)&banner);
    if (banner == nil)
        return FPANE_CreateError(@"Context does not have a Banner", 0);
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    
    [banner setPositionX:(screenSize.width - [banner getFrameWidth]) / 2];
    [banner setPositionY:(screenSize.height - [banner getFrameHeight])];
    
    return NULL;
}

# pragma mark - list functions

void MoPubBannerListFunctions(const FRENamedFunction** functionsToSet, uint32_t* numFunctionsToSet) {
    
    static FRENamedFunction functions[] = {
            MAP_FUNCTION(banner_init, NULL),
            MAP_FUNCTION(banner_getAutorefresh, NULL),
            MAP_FUNCTION(banner_setAutorefresh, NULL),
            MAP_FUNCTION(banner_getPositionX, NULL),
            MAP_FUNCTION(banner_getPositionY, NULL),
            MAP_FUNCTION(banner_getFrameWidth, NULL),
            MAP_FUNCTION(banner_getFrameHeight, NULL),
            MAP_FUNCTION(banner_setPositionX, NULL),
            MAP_FUNCTION(banner_setPositionY, NULL),
            MAP_FUNCTION(banner_setFrameWidth, NULL),
            MAP_FUNCTION(banner_setFrameHeight, NULL),
            MAP_FUNCTION(banner_setAdSize, NULL),
            MAP_FUNCTION(banner_getCreativeWidth, NULL),
            MAP_FUNCTION(banner_getCreativeHeight, NULL),
            MAP_FUNCTION(banner_loadBanner, NULL),
            MAP_FUNCTION(banner_showBanner, NULL),
            MAP_FUNCTION(banner_removeBanner, NULL),
            MAP_FUNCTION(banner_refresh, NULL),
            MAP_FUNCTION(banner_setKeywords, NULL),
            MAP_FUNCTION(banner_setTesting, NULL),
            MAP_FUNCTION(banner_getTesting, NULL),
            MAP_FUNCTION(banner_moveToDefaultPosition, NULL)
    };
    
    *numFunctionsToSet = sizeof(functions) / sizeof(FRENamedFunction);
    *functionsToSet = functions;
}