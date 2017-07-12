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
    public class TapJoyOfferWall extends EventDispatcher {
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									   PUBLIC API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//

        public function load():void {

            var ret:Object = _context.call("offerwall_load");
            if (ret is Error)
                throw ret;
        }

        public function show():void {

            var ret:Object = _context.call("offerwall_show");
            if (ret is Error)
                throw ret;
        }

        public function get isReady():Boolean {

            var ret:Object = _context.call("offerwall_ready");
            if (ret is Error)
                throw ret;
            else
                return ret as Boolean;
        }

        public function setUserId(userId:String):void {

            var ret:Object = _context.call("offerwall_setuserid", userId);
            if (ret is Error)
                throw ret;
        }
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									 	PRIVATE API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		private var _context:ExtensionContext = null;
		
		public function TapJoyOfferWall(context:ExtensionContext) {
			
			_context = context;
			_context.addEventListener(StatusEvent.STATUS, _handleStatusEvent);
		}

        private function _handleStatusEvent(event:StatusEvent):void {
            this.dispatchEvent(new MoPubEvent(event.code, event.level));
        }
    }
}
