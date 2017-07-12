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
package com.freshplanet.ane.AirMoPub {
	
	import flash.events.Event;
	
	/**
	 *
	 */
	public class MoPubEvent extends Event {
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									   PUBLIC API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		public static const AD_LOADED:String         = "adLoaded";
		public static const AD_LOADING_FAILED:String = "adLoadingFailed";
		public static const AD_CLICKED:String        = "adClicked";
		public static const AD_CLOSED:String         = "adClosed";
		
		public static const REWARD_STARTED:String    = "rewardStarted";
		public static const REWARD_PLAY_ERROR:String = "rewardPlayError";
		
		public static const BANNER_EXPANDED:String = "bannerExpanded";
		public static const BANNER_COLAPSED:String = "bannerColapsed";
		
		public static const INTERSTITIAL_EXPIRED:String = "interstitialExpired";
		
		/**
		 *
		 */
		public function get data():String {
			return _data;
		}
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									 	PRIVATE API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		private var _data:String = null;
		
		public function MoPubEvent(type:String, data:String = null, bubbles:Boolean = false,
								   cancelable:Boolean = false) {
			
			super(type, bubbles, cancelable);
			_data = data;
		}
	}
}