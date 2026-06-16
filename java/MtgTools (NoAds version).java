package com.arizona.launcher;

import android.app.Activity;
import android.content.Context;

import android.util.Log;

public class MtgTools {

    public static void initialize(Activity activity, Context context) {

        new Thread(() -> {
            try {
                if (!com.arizona.launcher.CheckUpdate.isNeedUpdate(activity, context)) {
                    com.arizona.launcher.AssetExtractor.unpackAssets(activity, context);
                }
            } catch (Exception e) {
                Log.e("MtgTools", "Error update/assets: ", e);
            }
        }).start();

    }

}