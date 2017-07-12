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
package com.freshplanet.ane.AirMoPub;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubInterstitial;
import com.mopub.mobileads.MoPubInterstitial.InterstitialAdListener;

import java.util.HashMap;
import java.util.Map;

class MoPubInterstitialContext extends FREContext implements InterstitialAdListener {
	
	private MoPubInterstitial interstitial;
	private String adUnitId;
	
	private MoPubInterstitial getInterstitial() {
		
		if (interstitial == null) {
			
			interstitial = new MoPubInterstitial(this.getActivity(), adUnitId);
			interstitial.setInterstitialAdListener(this);
		}
		
		return interstitial;
	}
	
	@Override
	public void dispose() {
		
		if (interstitial != null) {
			
			interstitial.setInterstitialAdListener(null);
			interstitial.destroy();
		}
	}
	
	// Events
	
	@Override
	public void onInterstitialLoaded(MoPubInterstitial interstitial) {
		
		dispatchStatusEventAsync("", "interstitialLoaded");
	}
	
	@Override
	public void onInterstitialFailed(MoPubInterstitial interstitial, MoPubErrorCode errorCode) {
		
		dispatchStatusEventAsync("", "interstitialFailedToLoad");
	}
	
	@Override
	public void onInterstitialShown(MoPubInterstitial interstitial) {
	
	}
	
	@Override
	public void onInterstitialClicked(MoPubInterstitial interstitial) {
		
		dispatchStatusEventAsync("", "interstitialClicked");
	}
	
	@Override
	public void onInterstitialDismissed(MoPubInterstitial interstitial) {
		
		dispatchStatusEventAsync("", "interstitialClosed");
	}
	
	// AS interface
	
	private FREFunction interstitial_init = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				
				adUnitId = getStringFromFREObject(args[0]);
				getInterstitial();
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			return null;
		}
	};
	
	private FREFunction interstitial_getIsReady = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				return FREObject.newObject(getInterstitial().isReady());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			return null;
		}
	};
	
	private FREFunction interstitial_setTesting = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				getInterstitial().setTesting(getBooleanFromFREObject(args[0]));
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			return null;
		}
	};
	
	private FREFunction interstitial_getTesting = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				return FREObject.newObject(getInterstitial().getTesting());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			return null;
		}
	};
	
	private FREFunction interstitial_loadInterstitial = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				getInterstitial().load();
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			return null;
		}
	};
	
	private FREFunction interstitial_showInterstitial = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				
				MoPubInterstitial interstitial = getInterstitial();
				interstitial.show();
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			return null;
		}
	};
	
	private FREFunction interstitial_setKeywords = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				getInterstitial().setKeywords(getStringFromFREObject(args[0]));
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			return null;
		}
	};
	
	private FREFunction interstitial_data = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			return null;
		}
	};
	
	@Override
	public Map<String, FREFunction> getFunctions() {
		
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("interstitial_init", interstitial_init);
		functionMap.put("interstitial_getIsReady", interstitial_getIsReady);
		functionMap.put("interstitial_setTesting", interstitial_setTesting);
		functionMap.put("interstitial_getTesting", interstitial_getTesting);
		functionMap.put("interstitial_loadInterstitial", interstitial_loadInterstitial);
		functionMap.put("interstitial_showInterstitial", interstitial_showInterstitial);
		functionMap.put("interstitial_setKeywords", interstitial_setKeywords);
		functionMap.put("interstitial_data", interstitial_data);
		return functionMap;
	}
}