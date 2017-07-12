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
	public class MoPubBanner extends EventDispatcher {
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									   PUBLIC API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		public static const BANNER_SIZE:int          = 1;
		public static const MEDIUM_RECT_SIZE:int     = 2;
		public static const LEADERBOARD_SIZE:int     = 3;
		public static const WIDE_SKYSCRAPER_SIZE:int = 4;
		
		/**
		 *
		 */
		public function dispose():void {
			
			_context.dispose();
			this._context.removeEventListener(StatusEvent.STATUS, handleStatusEvent);
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
		public function get size():int {
			return _size;
		}
		
		/**
		 *
		 */
		public function get testing():Boolean {
			
			var ret:Object = _context.call("banner_getTesting");
			if (ret is Error)
				throw ret;
			
			return ret as Boolean;
		}
		
		/**
		 *
		 * @param value
		 */
		public function set testing(value:Boolean):void {
			
			var ret:Object = _context.call("banner_setTesting", value);
			if (ret is Error)
				throw ret;
		}
		
		/**
		 *
		 */
		public function get autorefresh():Boolean {
			
			var ret:Object = _context.call("banner_getAutorefresh");
			if (ret is Error)
				throw ret;
			
			return ret as Boolean;
		}
		
		/**
		 *
		 * @param value
		 */
		public function set autorefresh(value:Boolean):void {
			
			var ret:Object = _context.call("banner_setAutorefresh", value);
			if (ret is Error)
				throw ret;
		}
		
		/**
		 *
		 */
		public function get x():int {
			
			var ret:Object = _context.call("banner_getPositionX");
			if (ret is Error)
				throw ret;
			
			return ret as int;
		}
		
		/**
		 *
		 */
		public function get y():int {
			
			var ret:Object = _context.call("banner_getPositionY");
			if (ret is Error)
				throw ret;
			
			return ret as int;
		}
		
		/**
		 *
		 */
		public function get width():int {
			
			var ret:Object = _context.call("banner_getFrameWidth");
			if (ret is Error)
				throw ret;
			
			return ret as int;
		}
		
		/**
		 *
		 */
		public function get height():int {
			
			var ret:Object = _context.call("banner_getFrameHeight");
			if (ret is Error)
				throw ret;
			
			return ret as int;
		}
		
		/**
		 *
		 * @param value
		 */
		public function set x(value:int):void {
			
			var ret:Object = _context.call("banner_setPositionX", value);
			if (ret is Error)
				throw ret;
		}
		
		/**
		 *
		 * @param value
		 */
		public function set y(value:int):void {
			
			var ret:Object = _context.call("banner_setPositionY", value);
			if (ret is Error)
				throw ret;
		}
		
		/**
		 *
		 * @param value
		 */
		public function set width(value:int):void {
			
			var ret:Object = _context.call("banner_setFrameWidth", value);
			if (ret is Error)
				throw ret;
		}
		
		/**
		 *
		 * @param value
		 */
		public function set height(value:int):void {
			
			var ret:Object = _context.call("banner_setFrameHeight", value);
			if (ret is Error)
				throw ret;
		}
		
		/**
		 *
		 * @param value
		 */
		public function set adSize(value:int):void {
			
			var ret:Object = _context.call("banner_setAdSize", value);
			if (ret is Error)
				throw ret;
			
			_size = value;
		}
		
		/**
		 *
		 */
		public function get creativeWidth():int {
			
			var ret:Object = _context.call("banner_getCreativeWidth");
			if (ret is Error)
				throw ret;
			
			return ret as int;
		}
		
		/**
		 *
		 */
		public function get creativeHeight():int {
			
			var ret:Object = _context.call("banner_getCreativeHeight");
			if (ret is Error)
				throw ret;
			
			return ret as int;
		}
		
		
		/**
		 *
		 */
		public function load():void {
			
			var ret:Object = _context.call("banner_loadBanner");
			if (ret is Error)
				throw ret;
		}
		
		/**
		 *
		 */
		public function show():void {
			
			var ret:Object = _context.call("banner_showBanner");
			if (ret is Error)
				throw ret;
		}
		
		/**
		 *
		 */
		public function remove():void {
			
			var ret:Object = _context.call("banner_removeBanner");
			if (ret is Error)
				throw ret;
		}
		
		/**
		 *
		 */
		public function refresh():void {
			
			var ret:Object = _context.call("banner_refresh");
			if (ret is Error)
				throw ret;
		}
		
		/**
		 *
		 * @param keywords
		 */
		public function set keywords(keywords:String):void {
			
			if (!keywords)
				return;
			
			var ret:Object = _context.call("banner_setKeywords", keywords);
			if (ret is Error)
				throw ret;
		}
		
		/**
		 *
		 */
		public function moveToDefaultPosition():void {
			
			var ret:Object = _context.call("banner_moveToDefaultPosition");
			if (ret is Error)
				throw ret;
		}
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									 	PRIVATE API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		private var _context:ExtensionContext = null;
		private var _id:String                = null;
		
		private var _size:int;
		
		public function MoPubBanner(context:ExtensionContext, id:String, size:int) {
			
			super();
			
			_context = context;
			_id      = id;
			_size    = size;
			
			_context.addEventListener(StatusEvent.STATUS, handleStatusEvent);
		}
		
		private function handleStatusEvent(event:StatusEvent):void {
			
			switch (event.level) {
				case "bannerLoaded":
					dispatchEvent(new MoPubEvent(MoPubEvent.AD_LOADED));
					break;
				case "bannerFailedToLoad":
					dispatchEvent(new MoPubEvent(MoPubEvent.AD_LOADING_FAILED));
					break;
				case "bannerAdClicked":
					dispatchEvent(new MoPubEvent(MoPubEvent.AD_CLICKED));
					break;
				case "bannerAdClosed":
					dispatchEvent(new MoPubEvent(MoPubEvent.AD_CLOSED));
					break;
				case "bannerAdExpanded":
					dispatchEvent(new MoPubEvent(MoPubEvent.AD_CLOSED));
					break;
				case "bannerAdCollapsed":
					dispatchEvent(new MoPubEvent(MoPubEvent.AD_CLOSED));
					break;
			}
		}
		
	}
}