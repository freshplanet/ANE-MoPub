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
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	/**
	 *
	 */
	public class MoPubInterstitial extends EventDispatcher {
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									   PUBLIC API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		/**
		 *
		 */
		public function dispose():void {
			
			_context.dispose();
			_context.removeEventListener(StatusEvent.STATUS, _handleStatusEvent);
		}
		
		/**
		 *
		 */
		public function get id():String {
			return _id;
		}
		
		/**
		 *
		 */
		public function get isReady():Boolean {
			
			var ret:Object = _context.call("interstitial_getIsReady");
			
			if (ret is Error)
				throw ret;
			
			return ret as Boolean;
		}
		
		/**
		 *
		 * @param value
		 */
		public function set testing(value:Boolean):void {
			
			var ret:Object = _context.call("interstitial_setTesting", value);
			if (ret is Error)
				throw ret;
		}
		
		/**
		 *
		 */
		public function load():void {
			
			var ret:Object = _context.call("interstitial_loadInterstitial");
			if (ret is Error)
				throw ret;
		}
		
		/**
		 *
		 */
		public function show():void {
			
			var ret:Object = _context.call("interstitial_showInterstitial");
			if (ret is Error)
				throw ret;
		}
		
		/**
		 *
		 * @param value
		 */
		public function set keywords(value:String):void {
			
			if (!value)
				return;
			
			var ret:Object = _context.call("interstitial_setKeywords", value);
			if (ret is Error)
				throw ret;
		}
		
		/**
		 *
		 */
		public function get data():Object {
			
			var ret:Object = _context.call("interstitial_data");
			
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
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									 	PRIVATE API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		private var _context:ExtensionContext = null;
		private var _id:String                = null;
		
		public function MoPubInterstitial(context:ExtensionContext, id:String) {
			
			super();
			
			_context = context;
			_id      = id;
			
			_context.addEventListener(StatusEvent.STATUS, _handleStatusEvent);
		}
		
		private function _handleStatusEvent(event:StatusEvent):void {
			
			switch (event.level) {
				case "interstitialLoaded":
					dispatchEvent(new MoPubEvent(MoPubEvent.AD_LOADED));
					break;
				case "interstitialFailedToLoad":
					dispatchEvent(new MoPubEvent(MoPubEvent.AD_LOADING_FAILED));
					break;
				case "interstitialClicked":
					dispatchEvent(new MoPubEvent(MoPubEvent.AD_CLICKED));
					break;
				case "interstitialClosed":
					dispatchEvent(new MoPubEvent(MoPubEvent.AD_CLOSED));
					break;
				case "interstitialExpired":
					dispatchEvent(new MoPubEvent(MoPubEvent.INTERSTITIAL_EXPIRED));
					break;
			}
		}
		
	}
}