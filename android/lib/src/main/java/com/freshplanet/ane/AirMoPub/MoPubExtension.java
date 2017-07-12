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

import android.app.Activity;
import android.content.Context;
import android.content.res.Configuration;
import android.util.Log;
import com.adobe.air.AndroidActivityWrapper;
import com.adobe.air.StateChangeCallback;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.facebook.ads.BuildConfig;
import com.millennialmedia.MMSDK;
import com.mopub.common.MoPub;
import com.vungle.sdk.VunglePub;
import io.presage.Presage;

import java.util.HashMap;
import java.util.Map;

//import com.applovin.sdk.AppLovinSdk;
//import com.jirbo.adcolony.AdColony;
//import com.jirbo.adcolony.AdColonyAd;
//import com.tapjoy.Tapjoy;
//import com.unity3d.ads.UnityAds;
//import com.mopub.simpleadsdemo.InMobiBanner;
//import com.mopub.simpleadsdemo.InMobiInterstitial;

public class MoPubExtension implements FREExtension, StateChangeCallback {
	
	private AndroidActivityWrapper aaw = null;
	
	/**
	 * FREExtension SETUP
	 */
	
	public void initialize() {
		
		aaw = AndroidActivityWrapper.GetAndroidActivityWrapper();
		aaw.addActivityStateChangeListner(this);
		
		MoPub.onCreate(aaw.getActivity());
		
		Presage.getInstance().setContext(aaw.getApplicationContext());
		Presage.getInstance().start();
	}
	
	public void dispose() {
		
		if (aaw != null) {
			
			aaw.removeActivityStateChangeListner(this);
			aaw = null;
		}
	}
	
	public FREContext createContext(String label) {
		
		if (label.equals("banner"))
			return new MoPubBannerContext();
		else if (label.equals("interstitial"))
			return new MoPubInterstitialContext();
		else if (label.equals("rewardVideo"))
			return new MoPubRewardVideoContext();
		else if (label.equals("offerWall"))
			return new TapJoyOfferWallContext();
		
		return new MoPubExtensionContext();
	}
	
	/**
	 * ADOBE HACKERY
	 */
	
	public void onActivityStateChanged(AndroidActivityWrapper.ActivityState var1) {
		
		/*
		 * TODO : map these remaining events from the Adobe activity lifecycle
		 * onCreate - maybe done?
		 * onBackPressed
		 */
		
		switch (var1) {
			case STARTED:
				MoPub.onStart(aaw.getActivity());
				break;
			
			case RESTARTED:
				MoPub.onRestart(aaw.getActivity());
				break;
			
			case RESUMED:
				MoPub.onResume(aaw.getActivity());
				break;
			
			case PAUSED:
				MoPub.onPause(aaw.getActivity());
				break;
			
			case STOPPED:
				MoPub.onStop(aaw.getActivity());
				break;
			
			case DESTROYED:
				MoPub.onDestroy(aaw.getActivity());
				break;
			
			default:
				break;
		}
	}
	
	public void onConfigurationChanged(Configuration var1) {
		// do nothing
	}
}

class MoPubExtensionContext extends FREContext {
	
	private FREFunction setupNetworks = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			Activity appActivity = ctx.getActivity();
			Context appContext = appActivity.getApplicationContext();
			
			Boolean debug = getBooleanFromFREObject(args[0]);
			
			if (args[1] != null) {
				
				String inMobiAppId = getStringFromFREObject(args[1]);
			}
			
			if (args[2] != null) {
				
				String tapJoySdkKey = getStringFromFREObject(args[2]);
//                Tapjoy.setDebugEnabled(debug);
//                Tapjoy.connect(appContext, tapJoySdkKey);
			}
			
			return null;
		}
	};
	
	private FREFunction getSdkVersions = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			String mopub = MoPub.SDK_VERSION;
//            String adcolony = "-";
//            String applovin = AppLovinSdk.VERSION;
			String chartboost = "-";
			String facebook = BuildConfig.VERSION_NAME;
			String google = "-";
			String millennial = MMSDK.VERSION;
//            String tapjoy = Tapjoy.getVersion();
//            String unity = UnityAds.getVersion();
			String vungle = VunglePub.getVersionString();
			String ogury = "-";
			
			String data = "{" +
					  "\"mopub\":\"" + mopub +
//                    "\",\"adcolony\":\"" + adcolony +
//                    "\",\"applovin\":\"" + applovin +
//                    ",\"chartboost\":"" + chartboost +
					  "\",\"facebook\":\"" + facebook +
					  "\",\"google\":\"" + google +
					  "\",\"millennial\":\"" + millennial +
//                    "\",\"tapjoy\":\"" + tapjoy +
//                    "\",\"unity\":\"" + unity +
					  "\",\"vungle\":\"" + vungle +
					  "\",\"ogury\":\"" + ogury +
					  "\"}";
			
			Log.e("MOPUB", data);
			
			FREObject freReturn = null;
			
			try {
				freReturn = FREObject.newObject(data);
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			
			return freReturn;
		}
	};
	
	public void dispose() {
	
	}
	
	public Map<String, FREFunction> getFunctions() {
		
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("setupNetworks", setupNetworks);
		functionMap.put("getSdkVersions", getSdkVersions);
		
		return functionMap;
	}
}