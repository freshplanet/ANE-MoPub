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

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import java.util.HashMap;
import java.util.Map;

public class TapJoyOfferWallContext extends FREContext {//implements TJPlacementListener {

//    private TJPlacement offerWallPlacement;
	
	public TapJoyOfferWallContext() {
	
	}
	
	/**
	 *
	 * INTERFACE
	 *
	 */
	
	private FREFunction offerwall_init = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			_openOfferWall();
			
			return null;
		}
	};
	
	
	private FREFunction offerwall_load = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {

//            if (Tapjoy.isConnected())
//                offerWallPlacement.requestContent();
//            else
//                Log.d("MoPub", "Tapjoy SDK must finish connecting before requesting content.");
			
			return null;
		}
	};
	
	private FREFunction offerwall_show = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {

//            offerWallPlacement.showContent();
			
			return null;
		}
	};
	
	
	private FREFunction offerwall_ready = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {

//            Boolean offerWallIsReady = offerWallPlacement.isContentReady() && offerWallPlacement.isContentAvailable();
//
//            try {
//                return FREObject.newObject(offerWallIsReady);
//            }
//            catch (Exception exception) {
//                Log.w("MoPub", exception);
//            }
			
			return null;
		}
	};
	
	
	private FREFunction offerwall_setuserid = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {

//            String userId = getStringFromFREObject(args[0]);
//            Tapjoy.setUserID(userId);
			
			return null;
		}
	};
	
	private void _openOfferWall() {

//        Activity appActivity = this.getActivity();
//        Context appContext = appActivity.getApplicationContext();
//
//        offerWallPlacement = new TJPlacement(appContext, "offerwall", this);
	}
	
	/**
	 *
	 * EVENTS
	 *
	 */

//    public void onRequestSuccess(TJPlacement var1) {
//        dispatchStatusEventAsync("didLoad", "" + var1.getName());
//    }
//
//    public void onRequestFailure(TJPlacement var1, TJError var2) {
//        dispatchStatusEventAsync("didFailToLoad", "" + var2.message);
//    }
//
//    public void onContentReady(TJPlacement var1) {
//        dispatchStatusEventAsync("didBecomeReady", "" + var1.getName());
//    }
//
//    public void onContentShow(TJPlacement var1) {
//        dispatchStatusEventAsync("didAppear", "" + var1.getName());
//    }
//
//    public void onContentDismiss(TJPlacement var1) {
//        dispatchStatusEventAsync("didDisappear", "" + var1.getName());
//    }
//
//    public void onPurchaseRequest(TJPlacement var1, TJActionRequest var2, String var3) {
//
//        String purchaseRequest = "{ placement :" + var1.getName() +
//                ", requestId : " + var2.getRequestId() +
//                ", token : " + var2.getToken() +
//                ", var3 : " + var3 + " }";
//
//        dispatchStatusEventAsync("didRequestPurchase", purchaseRequest);
//    }
//
//    public void onRewardRequest(TJPlacement var1, TJActionRequest var2, String var3, int var4) {
//
//        String rewardRequest = "{ placement :" + var1.getName() +
//                ", requestId : " + var2.getRequestId() +
//                ", token : " + var2.getToken() +
//                ", var3 : " + var3 +
//                ", var4 : " + var4 + " }";
//
//        dispatchStatusEventAsync("didRequestReward", rewardRequest);
//    }
	
	/**
	 *
	 * FRECONTEXT SETUP
	 *
	 */
	
	public void dispose() {
	
	}
	
	public Map<String, FREFunction> getFunctions() {
		
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("offerwall_init", offerwall_init);
		functionMap.put("offerwall_load", offerwall_load);
		functionMap.put("offerwall_show", offerwall_show);
		functionMap.put("offerwall_ready", offerwall_ready);
		functionMap.put("offerwall_setuserid", offerwall_setuserid);
		
		return functionMap;
	}
}
