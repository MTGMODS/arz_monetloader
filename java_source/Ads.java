package com.arizona.launcher;

import android.content.Context;
import android.app.Activity;

import com.unity3d.ads.IUnityAdsListener;
import com.unity3d.ads.UnityAds;

import android.content.SharedPreferences;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.widget.EditText;
import android.widget.Toast;

public class Ads {

    public static String placementVideo = "Interstitial_Android";

    private static class UnityAdsListener implements IUnityAdsListener {
        private Context context;

        public UnityAdsListener(Context context) {
            this.context = context;
        }

        public void onUnityAdsReady(String placementVideo) {
            // Toast.makeText(context, "[MTG MODS]\nℹ️️ Реклама готова ℹ️", Toast.LENGTH_LONG).show();
        }
        @Override
        public void onUnityAdsStart(String placementVideo) {
            Toast.makeText(context, "[MTG MODS]\nℹ️️ VIP убирает рекламу ℹ️", Toast.LENGTH_LONG).show();
        }
        @Override
        public void onUnityAdsFinish(String placementVideo, UnityAds.FinishState finishState) {
            if (finishState.equals(UnityAds.FinishState.COMPLETED)) {
                Toast.makeText(context, "[MTG MODS]\n❤️ Спасибо за просмотр ❤️", Toast.LENGTH_SHORT).show();
            } else if (finishState.equals(UnityAds.FinishState.SKIPPED)) {
                Toast.makeText(context, "[MTG MODS]\n😭 Вы пропустили 😭️", Toast.LENGTH_LONG).show();
            } else if (finishState.equals(UnityAds.FinishState.ERROR)) {
                // Toast.makeText(context, "[MTG MODS]\n❗️️ Ошибка сети ❗", Toast.LENGTH_LONG).show();
            }
        }

        @Override
        public void onUnityAdsError(UnityAds.UnityAdsError error, String message) {
            // Toast.makeText(context, "[MTG MODS]\n❗️️ Ошибка сети ❗", Toast.LENGTH_LONG).show();
            Log.e("MtgTools", "onUnityAdsError: " + message);
        }

    }

    public static void initializeAds(Activity activity, Context context) {
        final Ads.UnityAdsListener UnityAdsListener = new Ads.UnityAdsListener(context);
        UnityAds.addListener(UnityAdsListener);
        UnityAds.initialize(activity, "4595401", false);
        new Thread(() -> {
            while (!UnityAds.isReady(placementVideo)) {
                try {
                    Thread.sleep(3000);
                } catch (InterruptedException e) {
                    Log.e("MtgTools", "Error ads: ", e);
                }
            }
            new Handler(Looper.getMainLooper()).post(() -> {
                UnityAds.show(activity, placementVideo);
            });
        }).start();
    }



}
