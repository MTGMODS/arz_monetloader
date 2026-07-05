package com.arizona.launcher;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import com.unity3d.ads.IUnityAdsInitializationListener;
import com.unity3d.ads.IUnityAdsLoadListener;
import com.unity3d.ads.IUnityAdsShowListener;
import com.unity3d.ads.UnityAds;
import com.unity3d.ads.UnityAdsShowOptions;

public class Ads {

    private static final String GAME_ID = "4595401";
    public static final Boolean testMode = false;
    public static final String placementVideo = "Interstitial_Android";

    public static void initializeAds(final Activity activity, final Context context) {
        UnityAds.initialize(activity, GAME_ID, testMode, new IUnityAdsInitializationListener() {
        
            @Override
            public void onInitializationComplete() {
                Log.d("MtgTools", "Unity Ads initialized 4.4.1");

                UnityAds.load(placementVideo, new IUnityAdsLoadListener() {

                    @Override
                    public void onUnityAdsAdLoaded(String placementId) {
                        Log.d("MtgTools", "Ad loaded");

                        UnityAds.show(activity, placementId, new UnityAdsShowOptions(),
                                new IUnityAdsShowListener() {

                                    @Override
                                    public void onUnityAdsShowStart(String placementId) {
                                        Toast.makeText(context, "[MTG MODS]\nℹ️️ VIP убирает рекламу ℹ️", Toast.LENGTH_LONG).show();
                                    }

                                    @Override
                                    public void onUnityAdsShowClick(String placementId) {
                                        
                                    }

                                    @Override
                                    public void onUnityAdsShowComplete(String placementId, UnityAds.UnityAdsShowCompletionState state) {
                                        if (state == UnityAds.UnityAdsShowCompletionState.COMPLETED) {
                                            Toast.makeText(context, "[MTG MODS]\n❤️ Спасибо за просмотр ❤️", Toast.LENGTH_SHORT).show();
                                        } else {
                                            Toast.makeText(context, "[MTG MODS]\n😭 Вы пропустили 😭", Toast.LENGTH_LONG).show();
                                        }
                                    }

                                    @Override
                                    public void onUnityAdsShowFailure(String placementId, UnityAds.UnityAdsShowError error, String message) {
                                        Log.e("MtgTools", "Show Error: " + error + " " + message);
                                    }
                                });
                    }

                    @Override
                    public void onUnityAdsFailedToLoad(String placementId, UnityAds.UnityAdsLoadError error, String message) {
                        Log.e("MtgTools","Load Error: " + error + " " + message);
                    }
                });
            }

            @Override
            public void onInitializationFailed(UnityAds.UnityAdsInitializationError error, String message) {
                Log.e("MtgTools", "Init Error: " + error + " " + message);
            }
        });
    }
}
