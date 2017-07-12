package com.mopub.mobileads;

import io.presage.Presage;
import io.presage.IADHandler;

import java.util.Map;

import android.content.Context;

import com.mopub.mobileads.CustomEventInterstitial;
import com.mopub.mobileads.MoPubErrorCode;

/**
 * PresageCustomEvent is a CustomEventInterstitial for Google Admob Mediation for Presage
 */
public class PresageCustomEventMopub extends CustomEventInterstitial {

    private CustomEventInterstitialListener mListener;

    public PresageCustomEventMopub() {
        super();
    }

    @Override
    protected void loadInterstitial(Context context,
                                    CustomEventInterstitialListener listener, Map<String, Object> arg2,
                                    Map<String, String> arg3) {

        if (listener == null) {
            // log error
            return;
        }

        mListener = listener;

        Presage.getInstance().loadInterstitial(new IADHandler() {
            @Override
            public void onAdNotFound() {
                if (mListener != null)
                    mListener.onInterstitialFailed(MoPubErrorCode.NETWORK_NO_FILL);
            }

            @Override
            public void onAdFound() {
                if (mListener != null)
                    mListener.onInterstitialLoaded();
            }

            @Override
            public void onAdClosed() {
            }

            @Override
            public void onAdError(int i) {
                if (mListener != null)
                    mListener.onInterstitialFailed(MoPubErrorCode.NO_FILL);
            }

            @Override
            public void onAdDisplayed() {
            }
        });
    }

        @Override
        protected void showInterstitial() {
            if (Presage.getInstance().isInterstitialLoaded()) {
                Presage.getInstance().showInterstitial(new IADHandler() {
                    @Override
                    public void onAdFound() {

                    }

                    @Override
                    public void onAdNotFound() {

                    }

                    @Override
                    public void onAdClosed() {
                        if (mListener != null)
                            mListener.onInterstitialDismissed();
                    }

                    @Override
                    public void onAdError(int i) {
                        if (mListener != null)
                            mListener.onInterstitialFailed(MoPubErrorCode.NETWORK_NO_FILL);
                    }

                    @Override
                    public void onAdDisplayed() {
                        if (mListener != null)
                            mListener.onInterstitialShown();
                    }
                });
            }
        }

        @Override
        protected void onInvalidate() {
            //nothing to do here
        }
    }
