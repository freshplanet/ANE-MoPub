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

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubView;
import com.mopub.mobileads.MoPubView.BannerAdListener;

import java.util.HashMap;
import java.util.Map;

public class MoPubBanner extends MoPubView {
	
	public static final int BANNER_SIZE = 1;
	public static final int MEDIUM_RECT_SIZE = 2;
	public static final int LEADERBOARD_SIZE = 3;
	public static final int WIDE_SKYSCRAPER_SIZE = 4;
	
	private Context mContext;
	private FrameLayout.LayoutParams mLayoutParams;
	
	public MoPubBanner(Context context) {
		
		super(context);
		
		mContext = context;
		mLayoutParams = new FrameLayout.LayoutParams(0, 0, Gravity.TOP | Gravity.LEFT);
	}
	
	public MoPubBanner(Context context, AttributeSet attrs) {
		
		super(context, attrs);
	}
	
	public int getPosX() {
		
		return getUnscaledMetric(mLayoutParams.leftMargin);
	}
	
	public void setPosX(int x) {
		
		mLayoutParams.leftMargin = getScaledMetric(x);
		setLayoutParams(mLayoutParams);
	}
	
	public int getPosY() {
		
		return getUnscaledMetric(mLayoutParams.topMargin);
	}
	
	public void setPosY(int y) {
		
		mLayoutParams.topMargin = getScaledMetric(y);
		setLayoutParams(mLayoutParams);
	}
	
	public int getFrameWidth() {
		
		return getUnscaledMetric(mLayoutParams.width);
	}
	
	public void setFrameWidth(int width) {
		
		mLayoutParams.width = getScaledMetric(width);
		setLayoutParams(mLayoutParams);
	}
	
	public int getFrameHeight() {
		
		return getUnscaledMetric(mLayoutParams.height);
	}
	
	public void setFrameHeight(int height) {
		
		mLayoutParams.height = getScaledMetric(height);
		setLayoutParams(mLayoutParams);
	}
	
	public void setAdSize(int size) {
		
		int width, height;
		switch (size) {
			// from mopub-ios-sdk MPConstants.h
			case MEDIUM_RECT_SIZE:
				width = 300;
				height = 250;
				break;
			case LEADERBOARD_SIZE:
				width = 728;
				height = 90;
				break;
			case WIDE_SKYSCRAPER_SIZE:
				width = 160;
				height = 600;
				break;
			default: // BANNER_SIZE
				width = 320;
				height = 50;
				break;
		}
		
		setFrameWidth(width);
		setFrameHeight(height);
	}
	
	@Override
	public void destroy() {
		
		super.destroy();
		mContext = null;
		mLayoutParams = null;
	}
	
	public void moveToDefaultPosition() {
		
		setPosX(0);
		setPosY(0);
		mLayoutParams.gravity = Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL;
	}
	
	private int getScaledMetric(int value) {
		
		double density = mContext.getResources().getDisplayMetrics().density;
		return (int) Math.ceil(value * density);
	}
	
	private int getUnscaledMetric(int value) {
		
		double density = mContext.getResources().getDisplayMetrics().density;
		return (int) Math.floor(value / density);
	}
}

class MoPubBannerContext extends FREContext implements BannerAdListener {
	
	private MoPubBanner banner;
	
	private MoPubBanner getBanner() {
		
		if (banner == null) {
			
			banner = new MoPubBanner(this.getActivity());
			banner.setBannerAdListener(this);
		}
		return banner;
	}
	
	@Override
	public void dispose() {
		
		if (banner != null) {
			
			banner.setBannerAdListener(null);
			ViewGroup parent = (ViewGroup) banner.getParent();
			
			if (parent != null)
				parent.removeView(banner);
			
			banner.destroy();
		}
	}
	
	// Events
	
	@Override
	public void onBannerLoaded(MoPubView banner) {
		
		dispatchStatusEventAsync("", "bannerLoaded");
	}
	
	@Override
	public void onBannerFailed(MoPubView banner, MoPubErrorCode errorCode) {
		
		dispatchStatusEventAsync("", "bannerFailedToLoad");
	}
	
	@Override
	public void onBannerClicked(MoPubView banner) {
		
		dispatchStatusEventAsync("", "bannerAdClicked");
	}
	
	@Override
	public void onBannerExpanded(MoPubView banner) {
		
		dispatchStatusEventAsync("", "bannerAdExpanded");
	}
	
	@Override
	public void onBannerCollapsed(MoPubView banner) {
		
		dispatchStatusEventAsync("", "bannerAdCollapsed");
	}
	
	// AS interface
	
	private FREFunction banner_init = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				
				MoPubBanner banner = getBanner();
				
				String adUnitId = getStringFromFREObject(args[0]);
				int adSize = args[1].getAsInt();
				
				banner.setAdUnitId(adUnitId);
				banner.setAdSize(adSize);
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_getAutorefresh = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				
				return FREObject.newObject(getBanner().getAutorefreshEnabled());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_setAutorefresh = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				
				getBanner().setAutorefreshEnabled(getBooleanFromFREObject(args[0]));
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_getPositionX = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				return FREObject.newObject(getBanner().getPosX());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_getPositionY = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				return FREObject.newObject(getBanner().getPosY());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_getFrameWidth = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				return FREObject.newObject(getBanner().getWidth());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_getFrameHeight = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				return FREObject.newObject(getBanner().getHeight());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_setPositionX = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				getBanner().setPosX(args[0].getAsInt());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_setPositionY = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				getBanner().setPosY(args[0].getAsInt());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_setFrameWidth = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				getBanner().setFrameWidth(args[0].getAsInt());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_setFrameHeight = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				getBanner().setFrameHeight(args[0].getAsInt());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_setAdSize = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				getBanner().setAdSize(args[0].getAsInt());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_getCreativeWidth = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				return FREObject.newObject(getBanner().getAdWidth());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_getCreativeHeight = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				return FREObject.newObject(getBanner().getAdHeight());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_loadBanner = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				getBanner().loadAd();
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_showBanner = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				
				ViewGroup rootContainer = (ViewGroup) ctx.getActivity().findViewById(android.R.id.content);
				rootContainer = (ViewGroup) rootContainer.getChildAt(0);
				rootContainer.addView(getBanner());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_removeBanner = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				ViewGroup parent = (ViewGroup) getBanner().getParent();
				if (parent != null) {
					parent.removeView(getBanner());
				}
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_refresh = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				getBanner().forceRefresh();
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_setKeywords = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				getBanner().setKeywords(getStringFromFREObject(args[0]));
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_setTesting = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				getBanner().setTesting(getBooleanFromFREObject(args[0]));
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_getTesting = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				return FREObject.newObject(getBanner().getTesting());
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	private FREFunction banner_moveToDefaultPosition = new BaseFunction() {
		@Override
		public FREObject call(FREContext ctx, FREObject[] args) {
			
			try {
				getBanner().moveToDefaultPosition();
			}
			catch (Exception exception) {
				Log.w("MoPub", exception);
			}
			
			return null;
		}
	};
	
	@Override
	public Map<String, FREFunction> getFunctions() {
		
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("banner_init", banner_init);
		functionMap.put("banner_getAutorefresh", banner_getAutorefresh);
		functionMap.put("banner_setAutorefresh", banner_setAutorefresh);
		functionMap.put("banner_getPositionX", banner_getPositionX);
		functionMap.put("banner_getPositionY", banner_getPositionY);
		functionMap.put("banner_getFrameWidth", banner_getFrameWidth);
		functionMap.put("banner_getFrameHeight", banner_getFrameHeight);
		functionMap.put("banner_setPositionX", banner_setPositionX);
		functionMap.put("banner_setPositionY", banner_setPositionY);
		functionMap.put("banner_setFrameWidth", banner_setFrameWidth);
		functionMap.put("banner_setFrameHeight", banner_setFrameHeight);
		functionMap.put("banner_setAdSize", banner_setAdSize);
		functionMap.put("banner_getCreativeWidth", banner_getCreativeWidth);
		functionMap.put("banner_getCreativeHeight", banner_getCreativeHeight);
		functionMap.put("banner_loadBanner", banner_loadBanner);
		functionMap.put("banner_showBanner", banner_showBanner);
		functionMap.put("banner_removeBanner", banner_removeBanner);
		functionMap.put("banner_refresh", banner_refresh);
		functionMap.put("banner_setKeywords", banner_setKeywords);
		functionMap.put("banner_setTesting", banner_setTesting);
		functionMap.put("banner_getTesting", banner_getTesting);
		functionMap.put("banner_moveToDefaultPosition", banner_moveToDefaultPosition);
		
		return functionMap;
	}
}
