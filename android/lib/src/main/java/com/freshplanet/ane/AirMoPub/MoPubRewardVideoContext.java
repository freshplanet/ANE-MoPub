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
import com.mopub.common.MoPubReward;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubRewardedVideoListener;
import com.mopub.mobileads.MoPubRewardedVideos;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class MoPubRewardVideoContext extends FREContext implements MoPubRewardedVideoListener {
	
	private String _adUnitId;
	
	public MoPubRewardVideoContext() {
	
	}
	
	/**
	 * INTERFACE
	 */
	
	private FREFunction reward_init = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			String adUnitId = getStringFromFREObject(args[0]);
			_initRewardedVideo(adUnitId);
			
			return null;
		}
	};
	
	private FREFunction reward_load = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			MoPubRewardedVideos.loadRewardedVideo(_adUnitId);
			return null;
		}
	};
	
	private FREFunction reward_show = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			MoPubRewardedVideos.showRewardedVideo(_adUnitId);
			return null;
		}
	};
	
	
	private FREFunction reward_has = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			Boolean hasRewarded = MoPubRewardedVideos.hasRewardedVideo(_adUnitId);
			
			try {
				return FREObject.newObject(hasRewarded);
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction reward_data = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {

//            Class rewardClass = MoPubRewardedVideoManager.class;
//
//            Field managerInstanceField = null;
//            MoPubRewardedVideoManager manager = null;
//
//            Field adRequestStatusField = null;
//            AdRequestStatusMapping adRequestStatus = null;
//
//            try {
//
//                managerInstanceField = rewardClass.getDeclaredField("sInstance");
//                manager = (MoPubRewardedVideoManager)managerInstanceField.get(rewardClass);
//
//                if (manager == null)
//                    return null;
//
//            }
//            catch (NoSuchFieldException noSuchFieldException) {
//                return null;
//            }
//            catch (IllegalAccessException illegalAccessException) {
//                return null;
//            }
//
//            String url = null;
//            String requestId = null;
//            String adClass = null;
//            String classData = null;
//            String creativeId = null;
			
			return null;
		}
	};
	
	private void _initRewardedVideo(String adUnitId) {
		
		_adUnitId = adUnitId;
		
		MoPubRewardedVideos.initializeRewardedVideo(this.getActivity());
		MoPubRewardedVideos.setRewardedVideoListener(this);
	}
	
	/**
	 * EVENTS
	 */
	
	@Override
	public void onRewardedVideoLoadSuccess(String adUnitId) {
		// Called when the video for the given adUnitId has loaded. At this point you should be able to call MoPub.showRewardedVideo(String) to show the video.
		dispatchStatusEventAsync("didLoad", "" + adUnitId);
	}
	
	@Override
	public void onRewardedVideoLoadFailure(String adUnitId, MoPubErrorCode errorCode) {
		// Called when a video fails to load for the given adUnitId. The provided error code will provide more insight into the reason for the failure to load.
		dispatchStatusEventAsync("didFailToLoad", "" + errorCode.toString());
	}
	
	@Override
	public void onRewardedVideoStarted(String adUnitId) {
		// Called when a rewarded video starts playing.
		dispatchStatusEventAsync("didAppear", "" + adUnitId);
	}
	
	@Override
	public void onRewardedVideoPlaybackError(String adUnitId, MoPubErrorCode errorCode) {
		//  Called when there is an error during video playback.
		dispatchStatusEventAsync("didFailToPlay", "" + errorCode.toString());
	}
	
	@Override
	public void onRewardedVideoClosed(String adUnitId) {
		// Called when a rewarded video is closed. At this point your application should resume.
		dispatchStatusEventAsync("didDisappear", "" + adUnitId);
	}
	
	@Override
	public void onRewardedVideoCompleted(Set<String> adUnitIds, MoPubReward reward) {
		// Called when a rewarded video is completed and the user should be rewarded.
		// You can query the reward object with boolean isSuccessful(), String getLabel(), and int getAmount().
		
		if (reward.isSuccessful())
			dispatchStatusEventAsync("didComplete", "");
	}
	
	@Override
	public void onRewardedVideoClicked(String adUnitId) {
	
	}
	
	/**
	 * FRECONTEXT SETUP
	 */
	
	public void dispose() {
	
	}
	
	public Map<String, FREFunction> getFunctions() {
		
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("reward_init", reward_init);
		functionMap.put("reward_load", reward_load);
		functionMap.put("reward_show", reward_show);
		functionMap.put("reward_has", reward_has);
		functionMap.put("reward_data", reward_data);
		
		return functionMap;
	}
}
