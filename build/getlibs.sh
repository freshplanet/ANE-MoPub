#!/bin/bash

function get_android_libs() {

	echo "getting android libs..."

	echo "  adcolony    acquired via gradle (currently not included)"
	echo "  applovin    needs to be pulled from website manually https://www.applovin.com/downloadSDK?type=android"
	echo "  chartboost  pulling from site... (currently not included)"
#	curl -o cb.tar.bz2 -J -L http://www.chartboo.st/sdk/android
#    mkdir cb
#    tar -xf cb.tar.bz2 -C cb "*/chartboost.jar"
#    cp cb/lib/chartboost.jar ../android/lib/libs/chartboost.jar
#    rm -rf cb

	echo "  facebook    acquired via gradle"
	echo "  google      acquired via gradle, tied to GPS"
	echo "  millenial   pulling from site..."
	curl -o mm.zip http://docs.onemobilesdk.aol.com/artifacts/android/mm-android-ad-sdk-dist-6.4.0.zip
	unzip -j mm.zip "android-ad-sdk.aar" -d mm
	cp mm/android-ad-sdk.aar ../android/lib/libs/mm-ad-sdk.aar
	rm -rf mm/

	echo "  tapjoy      acquired via gradle (currently not included)"
	echo "  unity       pulling from git..."
	unity_aar=`curl -s https://api.github.com/repos/Unity-Technologies/unity-ads-android/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4`
	curl -o ../android/lib/libs/unity-ads.aar -J -L $unity_aar

	echo "  vungle      pulling from site..."
	curl -o vungle.zip -J -L https://v.vungle.com/dashboard/api/1/sdk/android
	unzip -j  vungle.zip "*.jar" -d vungle/
	for file in vungle/*; do
	    new_name="${file%%[.-]*}"
	    new_name="${new_name#*/}"
	    cp $file ../android/lib/libs/$new_name.jar
	done
	rm -rf vungle/
	rm vungle.zip
}

function get_ios_libs() {

	echo "getting ios libs..."

	echo "  adcolony    acquired via cocoapods"
	echo "  applovin    acquired via cocoapods"
	echo "  chartboost  acquired via cocoapods"
	echo "  facebook    acquired via cocoapods"
	echo "  google      acquired via cocoapods"
	echo "  millenial   pulling from site..."
	curl -o mm.zip http://docs.onemobilesdk.aol.com/artifacts/ios/mm-ios-ad-sdk-dist-6.4.0.zip
   	unzip -jo mm.zip "*.framework/*" -d ../ios/AdNetworkSupport/Millennial/SDK/MMAdSDK.framework
   	rm mm.zip

	echo "  tapjoy      acquired via cocoapods"
	echo "  unity       acquired via cocoapods"
	echo "  vungle      acquired via cocoapods"

	(cd ../ios/ && pod update)
}

get_android_libs
get_ios_libs