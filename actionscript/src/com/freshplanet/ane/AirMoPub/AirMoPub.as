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
	
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	/**
	 *
	 */
	public class AirMoPub {
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									   PUBLIC API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		/**
		 *
		 */
		public static function get isSupported():Boolean {
			return Capabilities.manufacturer.indexOf("iOS") > -1 || Capabilities.manufacturer.indexOf("Android") > -1;
		}
		
		/**
		 *
		 * @param debug
		 * @param inMobiAppId
		 * @param tapJoySdkKey
		 */
		public static function setupNetworks(debug:Boolean = false, inMobiAppId:String = null,
											 tapJoySdkKey:String = null):void {
			
			if (!isSupported)
				return;
			
			_getMoPubContext().call("setupNetworks", debug, inMobiAppId, tapJoySdkKey);
		}
		
		/**
		 *
		 * @return
		 */
		public static function getSdkVersions():Object {
			
			if (!isSupported)
				return {};
			
			var ret:Object = _getMoPubContext().call("getSdkVersions");
			
			if (ret is Error)
				throw ret;
			
			var dataString:String = ret as String;
			var json:Object       = null;
			
			try {
				json = JSON.parse(dataString);
			}
			catch (e:Error) {
			
			}
			
			return json;
		}
		
		/**
		 *
		 * @param id
		 * @param size
		 * @return
		 */
		public static function createBanner(id:String, size:int):MoPubBanner {
			
			if (!isSupported)
				return null;
			
			var ctx:ExtensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID,
																			   EXTENSION_CONTEXT_BANNER);
			ctx.call("banner_init", id, size);
			return new MoPubBanner(ctx, id, size);
		}
		
		/**
		 *
		 * @param id
		 * @return
		 */
		public static function createInterstitial(id:String):MoPubInterstitial {
			
			if (!isSupported)
				return null;
			
			var ctx:ExtensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID,
																			   EXTENSION_CONTEXT_INTERSTITIAL);
			ctx.call("interstitial_init", id);
			return new MoPubInterstitial(ctx, id);
		}
		
		/**
		 *
		 * @param id
		 * @return
		 */
		public static function createRewardVideo(id:String):MoPubRewardVideo {
			
			if (!isSupported)
				return null;
			
			var ctx:ExtensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID,
																			   EXTENSION_CONTEXT_REWARD_VIDEO);
			ctx.call("reward_init", id);
			return new MoPubRewardVideo(ctx, id);
		}
		
		/**
		 *
		 * @return
		 */
		public static function createOfferWall():TapJoyOfferWall {
			
			if (!isSupported)
				return null;
			
			var ctx:ExtensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID,
																			   EXTENSION_CONTEXT_OFFER_WALL);
			ctx.call("offerwall_init");
			return new TapJoyOfferWall(ctx);
		}
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									 	PRIVATE API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		private static const EXTENSION_ID:String = "com.freshplanet.ane.AirMoPub";
		
		private static const EXTENSION_CONTEXT_BANNER:String       = "banner";
		private static const EXTENSION_CONTEXT_INTERSTITIAL:String = "interstitial";
		private static const EXTENSION_CONTEXT_REWARD_VIDEO:String = "rewardVideo";
		private static const EXTENSION_CONTEXT_OFFER_WALL:String   = "offerWall";
		
		private static var _context:ExtensionContext = null;
		
		private static function _getMoPubContext():ExtensionContext {
			
			if (_context == null)
				_context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
			
			return _context;
		}
	}
}