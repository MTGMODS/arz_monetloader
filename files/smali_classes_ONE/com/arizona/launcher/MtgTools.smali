.class public Lcom/arizona/launcher/MtgTools;
.super Ljava/lang/Object;
.source "MtgTools.java"


# static fields
.field public static forceVip:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 36
    const/4 v0, 0x0

    sput-boolean v0, Lcom/arizona/launcher/MtgTools;->forceVip:Z

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 34
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getDeviceId(Landroid/content/Context;)Ljava/lang/String;
    .locals 2
    .param p0, "context"    # Landroid/content/Context;

    .line 40
    nop

    .line 41
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    .line 40
    const-string v1, "android_id"

    invoke-static {v0, v1}, Landroid/provider/Settings$Secure;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static initialize(Landroid/app/Activity;Landroid/content/Context;)V
    .locals 2
    .param p0, "activity"    # Landroid/app/Activity;
    .param p1, "context"    # Landroid/content/Context;

    .line 228
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda0;

    invoke-direct {v1, p1, p0}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda0;-><init>(Landroid/content/Context;Landroid/app/Activity;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 277
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    .line 279
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda10;

    invoke-direct {v1, p0, p1}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda10;-><init>(Landroid/app/Activity;Landroid/content/Context;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 287
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    .line 289
    return-void
.end method

.method public static isActiveAdBlocker(Landroid/app/Activity;Landroid/content/Context;)Z
    .locals 12
    .param p0, "activity"    # Landroid/app/Activity;
    .param p1, "context"    # Landroid/content/Context;

    .line 164
    const-string v0, "connectivity"

    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/net/ConnectivityManager;

    .line 165
    .local v0, "cm":Landroid/net/ConnectivityManager;
    const/4 v1, 0x0

    if-eqz v0, :cond_1

    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x1c

    if-lt v2, v3, :cond_1

    .line 166
    invoke-virtual {v0}, Landroid/net/ConnectivityManager;->getActiveNetwork()Landroid/net/Network;

    move-result-object v2

    .line 167
    .local v2, "activeNetwork":Landroid/net/Network;
    if-eqz v2, :cond_1

    .line 168
    invoke-virtual {v0, v2}, Landroid/net/ConnectivityManager;->getLinkProperties(Landroid/net/Network;)Landroid/net/LinkProperties;

    move-result-object v3

    .line 169
    .local v3, "linkProperties":Landroid/net/LinkProperties;
    if-eqz v3, :cond_1

    .line 170
    invoke-virtual {v3}, Landroid/net/LinkProperties;->getPrivateDnsServerName()Ljava/lang/String;

    move-result-object v4

    .line 171
    .local v4, "privateDnsHost":Ljava/lang/String;
    if-eqz v4, :cond_1

    .line 172
    invoke-virtual {v4}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v5

    .line 173
    .local v5, "dns":Ljava/lang/String;
    const/16 v6, 0x9

    new-array v6, v6, [Ljava/lang/String;

    const-string v7, "adguard"

    aput-object v7, v6, v1

    const-string v7, "nextdns"

    const/4 v8, 0x1

    aput-object v7, v6, v8

    const/4 v7, 0x2

    const-string v9, "controld"

    aput-object v9, v6, v7

    const/4 v7, 0x3

    const-string v9, "libredns"

    aput-object v9, v6, v7

    const/4 v7, 0x4

    const-string v9, "blokada"

    aput-object v9, v6, v7

    const/4 v7, 0x5

    const-string v9, "quad9"

    aput-object v9, v6, v7

    const/4 v7, 0x6

    const-string v9, "adblock"

    aput-object v9, v6, v7

    const/4 v7, 0x7

    const-string v9, "rethinkdns"

    aput-object v9, v6, v7

    const/16 v7, 0x8

    const-string v9, "cleanbrowsing"

    aput-object v9, v6, v7

    .line 174
    .local v6, "adBlockers":[Ljava/lang/String;
    array-length v7, v6

    move v9, v1

    :goto_0
    if-ge v9, v7, :cond_1

    aget-object v10, v6, v9

    .line 175
    .local v10, "blocker":Ljava/lang/String;
    invoke-virtual {v5, v10}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v11

    if-eqz v11, :cond_0

    .line 176
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Detected AD blocker: "

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v7, "MtgTools"

    invoke-static {v7, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 177
    return v8

    .line 174
    .end local v10    # "blocker":Ljava/lang/String;
    :cond_0
    add-int/lit8 v9, v9, 0x1

    goto :goto_0

    .line 184
    .end local v2    # "activeNetwork":Landroid/net/Network;
    .end local v3    # "linkProperties":Landroid/net/LinkProperties;
    .end local v4    # "privateDnsHost":Ljava/lang/String;
    .end local v5    # "dns":Ljava/lang/String;
    .end local v6    # "adBlockers":[Ljava/lang/String;
    :cond_1
    return v1
.end method

.method public static isShowAd(Landroid/content/Context;)Z
    .locals 5
    .param p0, "context"    # Landroid/content/Context;

    .line 187
    const-string v0, "mtg"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 188
    .local v0, "sp":Landroid/content/SharedPreferences;
    const-string v2, "check"

    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v3

    const/4 v4, 0x1

    if-nez v3, :cond_0

    .line 189
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    invoke-interface {v3, v2, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 190
    return v1

    .line 192
    :cond_0
    const-string v2, "key"

    const-string v3, ""

    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 193
    .local v2, "savedKey":Ljava/lang/String;
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_1

    invoke-static {v2, p0}, Lcom/arizona/launcher/MtgTools;->isValidKey(Ljava/lang/String;Landroid/content/Context;)Z

    move-result v3

    if-nez v3, :cond_2

    :cond_1
    move v1, v4

    :cond_2
    return v1
.end method

.method public static isValidKey(Ljava/lang/String;Landroid/content/Context;)Z
    .locals 14
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "context"    # Landroid/content/Context;

    .line 101
    const-string v0, "valid"

    const-string v1, "Error check key: "

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Check key: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "MtgTools"

    invoke-static {v3, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 103
    const-string v2, "mtgmods.duckdns.org"

    .line 104
    .local v2, "host":Ljava/lang/String;
    const-string v4, "https://mtgmods.duckdns.org/api/v1/check_key"

    .line 105
    .local v4, "urlHost":Ljava/lang/String;
    const-string v5, "https://130.61.116.240/api/v1/check_key"

    .line 107
    .local v5, "urlIp":Ljava/lang/String;
    invoke-static {p1}, Lcom/arizona/launcher/MtgTools;->getDeviceId(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v6

    const-string v7, "https://mtgmods.duckdns.org/api/v1/check_key"

    const/4 v8, 0x0

    const-string v9, "mtgmods.duckdns.org"

    invoke-static {v7, p0, v6, v8, v9}, Lcom/arizona/launcher/MtgTools;->postRequest(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;)Ljava/lang/String;

    move-result-object v6

    .line 108
    .local v6, "response":Ljava/lang/String;
    const/4 v7, 0x1

    if-eqz v6, :cond_0

    const-string v10, "DNS_FAIL"

    invoke-virtual {v6, v10}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v10

    if-nez v10, :cond_0

    const-string v10, "UnknownHostException"

    invoke-virtual {v6, v10}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v10

    if-nez v10, :cond_0

    const-string v10, "host"

    invoke-virtual {v6, v10}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v10

    if-nez v10, :cond_0

    const-string v10, "or service"

    invoke-virtual {v6, v10}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v10

    if-eqz v10, :cond_1

    .line 109
    :cond_0
    const-string v10, "https://130.61.116.240/api/v1/check_key"

    invoke-static {p1}, Lcom/arizona/launcher/MtgTools;->getDeviceId(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v11

    invoke-static {v10, p0, v11, v7, v9}, Lcom/arizona/launcher/MtgTools;->postRequest(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;)Ljava/lang/String;

    move-result-object v6

    .line 111
    :cond_1
    if-nez v6, :cond_2

    .line 112
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v1, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda17;

    invoke-direct {v1, p1}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda17;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 113
    return v8

    .line 117
    :cond_2
    :try_start_0
    new-instance v9, Lorg/json/JSONObject;

    invoke-direct {v9, v6}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 118
    .local v9, "json":Lorg/json/JSONObject;
    invoke-virtual {v9, v0}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_3

    invoke-virtual {v9, v0}, Lorg/json/JSONObject;->getBoolean(Ljava/lang/String;)Z

    move-result v0

    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    goto :goto_0

    :cond_3
    const/4 v0, 0x0

    .line 119
    .local v0, "valid":Ljava/lang/Boolean;
    :goto_0
    sget-object v10, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v10, v0}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_4

    .line 120
    const-string v10, "user"

    const-string v11, "VIP \u043f\u043e\u043b\u044c\u0437\u043e\u0432\u0430\u0442\u0435\u043b\u044c"

    invoke-virtual {v9, v10, v11}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    .line 121
    .local v10, "username":Ljava/lang/String;
    new-instance v11, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v12

    invoke-direct {v11, v12}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v12, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda18;

    invoke-direct {v12, p1, v10}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda18;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    invoke-virtual {v11, v12}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 122
    return v7

    .line 123
    .end local v10    # "username":Ljava/lang/String;
    :cond_4
    sget-object v7, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    invoke-virtual {v7, v0}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_b

    .line 124
    const-string v7, "error"

    const-string v10, ""

    invoke-virtual {v9, v7, v10}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    .line 126
    .local v7, "err":Ljava/lang/String;
    const-string v10, "expires"

    invoke-virtual {v9, v10, v8}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v10
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const-string v11, "key"

    const-string v12, "mtg"

    if-eqz v10, :cond_5

    .line 127
    :try_start_1
    const-string v10, "[MTG MODS]\n\ud83d\ude2d \u041a\u043b\u044e\u0447 \u0443\u0441\u0442\u0430\u0440\u0435\u043b \ud83d\ude2d"

    .line 128
    .local v10, "toastMessage":Ljava/lang/String;
    invoke-virtual {p1, v12, v8}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v12

    invoke-interface {v12}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v12

    invoke-interface {v12, v11}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    invoke-interface {v11}, Landroid/content/SharedPreferences$Editor;->apply()V

    goto/16 :goto_1

    .line 129
    .end local v10    # "toastMessage":Ljava/lang/String;
    :cond_5
    const-string v10, "Key not found"

    invoke-virtual {v10, v7}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_6

    .line 130
    const-string v10, "[MTG MODS]\n\u274c \u041a\u043b\u044e\u0447 \u043d\u0435 \u043d\u0430\u0439\u0434\u0435\u043d \u274c"

    .line 131
    .restart local v10    # "toastMessage":Ljava/lang/String;
    invoke-virtual {p1, v12, v8}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v12

    invoke-interface {v12}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v12

    invoke-interface {v12, v11}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    invoke-interface {v11}, Landroid/content/SharedPreferences$Editor;->apply()V

    goto/16 :goto_1

    .line 132
    .end local v10    # "toastMessage":Ljava/lang/String;
    :cond_6
    const-string v10, "Missing key"

    invoke-virtual {v10, v7}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_7

    .line 133
    const-string v10, "[MTG MODS]\n\u26a0\ufe0f \u041d\u0435 \u0432\u0432\u0435\u0434\u0451\u043d \u043a\u043b\u044e\u0447 \u26a0\ufe0f"

    .line 134
    .restart local v10    # "toastMessage":Ljava/lang/String;
    invoke-virtual {p1, v12, v8}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v12

    invoke-interface {v12}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v12

    invoke-interface {v12, v11}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v11

    invoke-interface {v11}, Landroid/content/SharedPreferences$Editor;->apply()V

    goto :goto_1

    .line 135
    .end local v10    # "toastMessage":Ljava/lang/String;
    :cond_7
    const-string v10, "Internal server error"

    invoke-virtual {v10, v7}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_8

    .line 136
    const-string v10, "[MTG MODS]\n\u2757\ufe0f \u0421\u0435\u0440\u0432\u0435\u0440 \u0443\u043f\u0430\u043b \u2757\ufe0f"

    .restart local v10    # "toastMessage":Ljava/lang/String;
    goto :goto_1

    .line 137
    .end local v10    # "toastMessage":Ljava/lang/String;
    :cond_8
    const-string v10, "NOT_ACTIVATED"

    invoke-virtual {v10, v7}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_9

    .line 138
    const-string v10, "[MTG MODS]\n\ud83d\udc49 \u0410\u043a\u0442\u0438\u0432\u0438\u0440\u0443\u0439\u0442\u0435 \u0432 TG/DS \ud83d\udc48"

    .restart local v10    # "toastMessage":Ljava/lang/String;
    goto :goto_1

    .line 139
    .end local v10    # "toastMessage":Ljava/lang/String;
    :cond_9
    const-string v10, "RATE_LIMIT"

    invoke-virtual {v10, v7}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_a

    .line 140
    const-string v10, "retry"

    const/16 v11, 0xa

    invoke-virtual {v9, v10, v11}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v10

    .line 141
    .local v10, "retry":I
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "[MTG MODS]\n\u23f3 \u0410\u043d\u0442\u0438\u0424\u043b\u0443\u0434 "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v11

    const-string v12, " \u0441\u0435\u043a \u23f3"

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    move-object v10, v11

    .line 142
    .local v10, "toastMessage":Ljava/lang/String;
    goto :goto_1

    .line 143
    .end local v10    # "toastMessage":Ljava/lang/String;
    :cond_a
    const-string v10, "[MTG MODS]\n\u26a0\ufe0f \u041e\u0448\u0438\u0431\u043a\u0430 \u0441\u0435\u0440\u0432\u0435\u0440\u0430 \u26a0\ufe0f"

    .line 144
    .restart local v10    # "toastMessage":Ljava/lang/String;
    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "Unexpected valid=false response: "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    invoke-static {v3, v11}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 145
    move-object v11, v6

    .line 146
    .local v11, "finalResponse":Ljava/lang/String;
    new-instance v12, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v13

    invoke-direct {v12, v13}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v13, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda1;

    invoke-direct {v13, p1, v11}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda1;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    invoke-virtual {v12, v13}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 148
    .end local v11    # "finalResponse":Ljava/lang/String;
    :goto_1
    new-instance v11, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v12

    invoke-direct {v11, v12}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v12, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda2;

    invoke-direct {v12, p1, v10}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda2;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    invoke-virtual {v11, v12}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 149
    nop

    .end local v7    # "err":Ljava/lang/String;
    .end local v10    # "toastMessage":Ljava/lang/String;
    goto :goto_2

    .line 150
    :cond_b
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v3, v7}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 151
    new-instance v7, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v10

    invoke-direct {v7, v10}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v10, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda3;

    invoke-direct {v10, p1}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda3;-><init>(Landroid/content/Context;)V

    invoke-virtual {v7, v10}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 152
    move-object v7, v6

    .line 153
    .local v7, "finalResponse":Ljava/lang/String;
    new-instance v10, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v11

    invoke-direct {v10, v11}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v11, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda4;

    invoke-direct {v11, p1, v7}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda4;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    invoke-virtual {v10, v11}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 155
    .end local v7    # "finalResponse":Ljava/lang/String;
    :goto_2
    return v8

    .line 156
    .end local v0    # "valid":Ljava/lang/Boolean;
    .end local v9    # "json":Lorg/json/JSONObject;
    :catch_0
    move-exception v0

    .line 157
    .local v0, "e":Ljava/lang/Exception;
    invoke-static {v3, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 158
    new-instance v1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v3

    invoke-direct {v1, v3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v3, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda5;

    invoke-direct {v3, p1, v0}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda5;-><init>(Landroid/content/Context;Ljava/lang/Exception;)V

    invoke-virtual {v1, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 160
    .end local v0    # "e":Ljava/lang/Exception;
    return v8
.end method

.method static synthetic lambda$initialize$12(Landroid/content/Context;Landroid/app/Activity;Landroid/content/DialogInterface;I)V
    .locals 4
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "activity"    # Landroid/app/Activity;
    .param p2, "dialog"    # Landroid/content/DialogInterface;
    .param p3, "which"    # I

    .line 245
    const/high16 v0, 0x10000000

    :try_start_0
    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.settings.PRIVATE_DNS_SETTINGS"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 246
    .local v1, "intent":Landroid/content/Intent;
    invoke-virtual {v1, v0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 247
    invoke-virtual {p0, v1}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 256
    .end local v1    # "intent":Landroid/content/Intent;
    goto :goto_0

    .line 248
    :catch_0
    move-exception v1

    .line 250
    .local v1, "e":Ljava/lang/Exception;
    :try_start_1
    new-instance v2, Landroid/content/Intent;

    const-string v3, "android.settings.WIRELESS_SETTINGS"

    invoke-direct {v2, v3}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 251
    .local v2, "intent":Landroid/content/Intent;
    invoke-virtual {v2, v0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 252
    invoke-virtual {p0, v2}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .line 255
    .end local v2    # "intent":Landroid/content/Intent;
    goto :goto_0

    .line 253
    :catch_1
    move-exception v0

    .line 254
    .local v0, "ex":Ljava/lang/Exception;
    const-string v2, "\u041d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438 -> \u0421\u0435\u0442\u044c -> DNS"

    const/4 v3, 0x1

    invoke-static {p0, v2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v2

    invoke-virtual {v2}, Landroid/widget/Toast;->show()V

    .line 257
    .end local v0    # "ex":Ljava/lang/Exception;
    .end local v1    # "e":Ljava/lang/Exception;
    :goto_0
    invoke-virtual {p1}, Landroid/app/Activity;->finishAffinity()V

    .line 258
    return-void
.end method

.method static synthetic lambda$initialize$13(Landroid/app/Activity;Landroid/content/Context;Landroid/content/DialogInterface;I)V
    .locals 0
    .param p0, "activity"    # Landroid/app/Activity;
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "dialog"    # Landroid/content/DialogInterface;
    .param p3, "which"    # I

    .line 259
    invoke-static {p0, p1}, Lcom/arizona/launcher/MtgTools;->showVipDialog(Landroid/app/Activity;Landroid/content/Context;)V

    return-void
.end method

.method static synthetic lambda$initialize$14(Landroid/content/DialogInterface;I)V
    .locals 0
    .param p0, "dialog"    # Landroid/content/DialogInterface;
    .param p1, "which"    # I

    .line 267
    invoke-interface {p0}, Landroid/content/DialogInterface;->dismiss()V

    return-void
.end method

.method static synthetic lambda$initialize$15(Landroid/app/Activity;Landroid/content/Context;Landroid/content/DialogInterface;I)V
    .locals 0
    .param p0, "activity"    # Landroid/app/Activity;
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "dialog"    # Landroid/content/DialogInterface;
    .param p3, "which"    # I

    .line 268
    invoke-static {p0, p1}, Lcom/arizona/launcher/MtgTools;->showVipDialog(Landroid/app/Activity;Landroid/content/Context;)V

    return-void
.end method

.method static synthetic lambda$initialize$16(Landroid/app/Activity;Landroid/content/Context;)V
    .locals 5
    .param p0, "activity"    # Landroid/app/Activity;
    .param p1, "context"    # Landroid/content/Context;

    .line 232
    invoke-static {p0, p1}, Lcom/arizona/launcher/MtgTools;->isActiveAdBlocker(Landroid/app/Activity;Landroid/content/Context;)Z

    move-result v0

    const/4 v1, 0x1

    const-string v2, "\u0423\u0431\u0440\u0430\u0442\u044c \u0440\u0435\u043a\u043b\u0430\u043c\u0443"

    if-eqz v0, :cond_0

    .line 233
    sput-boolean v1, Lcom/arizona/launcher/MtgTools;->forceVip:Z

    .line 234
    new-instance v0, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    invoke-direct {v0, p1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;-><init>(Landroid/content/Context;)V

    .line 235
    const-string v1, "\u2139\ufe0f \u041e\u0431\u043d\u0430\u0440\u0443\u0436\u0435\u043d AD Blocker (Private DNS) \u2139\ufe0f"

    invoke-virtual {v0, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setTitle(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    .line 236
    const-string v1, "\u0414\u0430\u043d\u043d\u044b\u0439 Lua \u043b\u0430\u0443\u043d\u0447\u0435\u0440 \u0440\u0430\u0441\u043f\u0440\u043e\u0441\u0442\u0440\u0430\u043d\u044f\u0435\u0442\u0441\u044f \u0431\u0435\u0441\u043f\u043b\u0430\u0442\u043d\u043e, \u0430 \u0440\u0435\u043a\u043b\u0430\u043c\u0430 \u043f\u0440\u0438 \u0437\u0430\u043f\u0443\u0441\u043a\u0435 (\u0432 \u0438\u0433\u0440\u0435 \u0435\u0451 \u043d\u0435\u0442\u0443) \u043f\u043e\u043c\u043e\u0433\u0430\u0435\u0442 \u043f\u043e\u0434\u0434\u0435\u0440\u0436\u0438\u0432\u0430\u0442\u044c \u043b\u0430\u0443\u043d\u0447\u0435\u0440 \ud83d\udc96\n\n\u0412\u044b \u0436\u0435 \u0438\u0441\u043f\u043e\u043b\u044c\u0437\u0443\u0435\u0442\u0435 Private DNS, \u043a\u043e\u0442\u043e\u0440\u044b\u0439 \u0431\u043b\u043e\u043a\u0438\u0440\u0443\u0435\u0442 \u043f\u043e\u043a\u0430\u0437 \u0440\u0435\u043a\u043b\u0430\u043c\u044b \ud83e\udd7a\n\n\u2139\ufe0f \u0414\u043b\u044f \u043f\u0440\u043e\u0434\u043e\u043b\u0436\u0435\u043d\u0438\u044f, \u0432\u0430\u043c \u043d\u0443\u0436\u043d\u043e \u0440\u0435\u0448\u0438\u0442\u044c \u0434\u0430\u043d\u043d\u0443\u044e \u043f\u0440\u043e\u0431\u043b\u0435\u043c\u0443:\n\ud83d\udc49 \u041b\u0438\u0431\u043e \u043e\u0442\u043a\u043b\u044e\u0447\u0438\u0442\u044c \u0447\u0430\u0441\u0442\u043d\u044b\u0439 DNS \u0432 \u043d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0430\u0445, \u0434\u043b\u044f \u0437\u0430\u0433\u0440\u0443\u0437\u043a\u0438 \u0440\u0435\u043a\u043b\u0430\u043c\u044b\n\ud83d\udc49 \u041b\u0438\u0431\u043e \u0438\u043c\u0435\u0442\u044c \u043f\u043e\u0434\u043f\u0438\u0441\u043a\u0443 MTGVIP (\u0434\u043b\u044f \u0441\u043a\u0440\u0438\u043f\u0442\u043e\u0432 \u0438 \u043b\u0430\u0443\u043d\u0447\u0435\u0440\u0430)"

    invoke-virtual {v0, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setMessage(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    new-instance v1, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda13;

    invoke-direct {v1, p1, p0}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda13;-><init>(Landroid/content/Context;Landroid/app/Activity;)V

    .line 243
    const-string v3, "\u041e\u0442\u043a\u0440\u044b\u0442\u044c \u043d\u0430\u0441\u0442\u0440\u043e\u0439\u043a\u0438"

    invoke-virtual {v0, v3, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    new-instance v1, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda14;

    invoke-direct {v1, p0, p1}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda14;-><init>(Landroid/app/Activity;Landroid/content/Context;)V

    .line 259
    invoke-virtual {v0, v2, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    .line 260
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setCancelable(Z)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    .line 261
    invoke-virtual {v0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->show()Landroidx/appcompat/app/AlertDialog;

    goto :goto_0

    .line 263
    :cond_0
    invoke-static {p0, p1}, Lcom/arizona/launcher/Ads;->initializeAds(Landroid/app/Activity;Landroid/content/Context;)V

    .line 264
    new-instance v0, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    invoke-direct {v0, p1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;-><init>(Landroid/content/Context;)V

    .line 265
    const-string v3, "\u2139\ufe0f \u041f\u0440\u043e\u0441\u043c\u043e\u0442\u0440 \u0440\u0435\u043a\u043b\u0430\u043c\u044b \u043f\u0435\u0440\u0435\u0434 \u043d\u0430\u0447\u0430\u043b\u043e\u043c \u0438\u0433\u0440\u044b \u2139\ufe0f"

    invoke-virtual {v0, v3}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setTitle(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    .line 266
    const-string v3, "\u042d\u0442\u0438\u043c \u0434\u0435\u0439\u0441\u0442\u0432\u0438\u0435\u043c \u0432\u044b \u043f\u043e\u0434\u0434\u0435\u0440\u0436\u0438\u0432\u0430\u0435\u0442\u0435 MTG MODS \u2764\ufe0f\n\u0420\u0435\u043a\u043b\u0430\u043c\u044b \u0432 \u0438\u0433\u0440\u0435 \u043d\u0435\u0442\u0443, \u043e\u043d\u0430 \u0442\u043e\u043b\u044c\u043a\u043e \u043f\u0440\u0438 \u0437\u0430\u043f\u0443\u0441\u043a\u0435 \u043b\u0430\u0443\u043d\u0447\u0435\u0440\u0430\n\n\u0415\u0441\u043b\u0438 \u0432\u044b \u0445\u043e\u0442\u0438\u0442\u0435 \u043e\u0442\u043a\u043b\u044e\u0447\u0438\u0442\u044c \u0440\u0435\u043a\u043b\u0430\u043c\u0443, \u043f\u0440\u0438\u043e\u0431\u0440\u0435\u0442\u0438\u0442\u0435 VIP"

    invoke-virtual {v0, v3}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setMessage(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    new-instance v3, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda15;

    invoke-direct {v3}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda15;-><init>()V

    .line 267
    const-string v4, "\u0418\u0433\u0440\u0430\u0442\u044c"

    invoke-virtual {v0, v4, v3}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    new-instance v3, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda16;

    invoke-direct {v3, p0, p1}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda16;-><init>(Landroid/app/Activity;Landroid/content/Context;)V

    .line 268
    invoke-virtual {v0, v2, v3}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    .line 269
    invoke-virtual {v0, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setCancelable(Z)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    .line 270
    invoke-virtual {v0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->show()Landroidx/appcompat/app/AlertDialog;

    .line 272
    :goto_0
    return-void
.end method

.method static synthetic lambda$initialize$17(Landroid/content/Context;Landroid/app/Activity;)V
    .locals 3
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "activity"    # Landroid/app/Activity;

    .line 230
    :try_start_0
    invoke-static {p0}, Lcom/arizona/launcher/MtgTools;->isShowAd(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 231
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v1, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda6;

    invoke-direct {v1, p1, p0}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda6;-><init>(Landroid/app/Activity;Landroid/content/Context;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 276
    :cond_0
    goto :goto_0

    .line 274
    :catch_0
    move-exception v0

    .line 275
    .local v0, "e":Ljava/lang/Exception;
    const-string v1, "MtgTools"

    const-string v2, "Error init ad: "

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 277
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_0
    return-void
.end method

.method static synthetic lambda$initialize$18(Landroid/app/Activity;Landroid/content/Context;)V
    .locals 3
    .param p0, "activity"    # Landroid/app/Activity;
    .param p1, "context"    # Landroid/content/Context;

    .line 281
    :try_start_0
    invoke-static {p0, p1}, Lcom/arizona/launcher/CheckUpdate;->isNeedUpdate(Landroid/app/Activity;Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 282
    invoke-static {p0, p1}, Lcom/arizona/launcher/AssetExtractor;->unpackAssets(Landroid/app/Activity;Landroid/content/Context;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 286
    :cond_0
    goto :goto_0

    .line 284
    :catch_0
    move-exception v0

    .line 285
    .local v0, "e":Ljava/lang/Exception;
    const-string v1, "MtgTools"

    const-string v2, "Error update/assets: "

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 287
    .end local v0    # "e":Ljava/lang/Exception;
    :goto_0
    return-void
.end method

.method static synthetic lambda$isValidKey$1(Landroid/content/Context;)V
    .locals 2
    .param p0, "context"    # Landroid/content/Context;

    .line 112
    const-string v0, "[MTG MODS]\n\u26a0\ufe0f \u041e\u0448\u0438\u0431\u043a\u0430 \u043f\u043e\u0434\u043a\u043b\u044e\u0447\u0435\u043d\u0438\u044f \u26a0\ufe0f"

    const/4 v1, 0x1

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method static synthetic lambda$isValidKey$2(Landroid/content/Context;Ljava/lang/String;)V
    .locals 2
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "username"    # Ljava/lang/String;

    .line 121
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "[MTG MODS]\n\ud83d\udc51 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " \ud83d\udc51"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method static synthetic lambda$isValidKey$3(Landroid/content/Context;Ljava/lang/String;)V
    .locals 1
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "finalResponse"    # Ljava/lang/String;

    .line 146
    const/4 v0, 0x1

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method static synthetic lambda$isValidKey$4(Landroid/content/Context;Ljava/lang/String;)V
    .locals 1
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "toastMessage"    # Ljava/lang/String;

    .line 148
    const/4 v0, 0x1

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method static synthetic lambda$isValidKey$5(Landroid/content/Context;)V
    .locals 2
    .param p0, "context"    # Landroid/content/Context;

    .line 151
    const-string v0, "\ud83c\udf10 \u0421\u043c\u0435\u043d\u0438\u0442\u0435 4G / Wi-Fi / VPN \ud83c\udf10"

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method static synthetic lambda$isValidKey$6(Landroid/content/Context;Ljava/lang/String;)V
    .locals 1
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "finalResponse"    # Ljava/lang/String;

    .line 153
    const/4 v0, 0x1

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method static synthetic lambda$isValidKey$7(Landroid/content/Context;Ljava/lang/Exception;)V
    .locals 2
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "e"    # Ljava/lang/Exception;

    .line 158
    invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x1

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method static synthetic lambda$postRequest$0(Ljava/lang/String;Ljavax/net/ssl/SSLSession;)Z
    .locals 1
    .param p0, "h"    # Ljava/lang/String;
    .param p1, "s"    # Ljavax/net/ssl/SSLSession;

    .line 70
    const/4 v0, 0x1

    return v0
.end method

.method static synthetic lambda$showVipDialog$10(Landroid/widget/EditText;Landroid/content/Context;Landroid/app/Activity;Landroid/content/DialogInterface;I)V
    .locals 3
    .param p0, "input"    # Landroid/widget/EditText;
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "activity"    # Landroid/app/Activity;
    .param p3, "dialog2"    # Landroid/content/DialogInterface;
    .param p4, "which"    # I

    .line 204
    invoke-virtual {p0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    .line 205
    .local v0, "key":Ljava/lang/String;
    new-instance v1, Ljava/lang/Thread;

    new-instance v2, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda8;

    invoke-direct {v2, v0, p1, p2}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda8;-><init>(Ljava/lang/String;Landroid/content/Context;Landroid/app/Activity;)V

    invoke-direct {v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 212
    invoke-virtual {v1}, Ljava/lang/Thread;->start()V

    .line 213
    return-void
.end method

.method static synthetic lambda$showVipDialog$11(Landroid/content/Context;Landroid/app/Activity;Landroid/content/DialogInterface;I)V
    .locals 2
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "activity"    # Landroid/app/Activity;
    .param p2, "dialog"    # Landroid/content/DialogInterface;
    .param p3, "which"    # I

    .line 215
    sget-boolean v0, Lcom/arizona/launcher/MtgTools;->forceVip:Z

    if-eqz v0, :cond_0

    .line 216
    const-string v0, "[MTG MODS]\n\ud83d\udc49 \u041e\u0442\u043a\u043b\u044e\u0447\u0438\u0442\u0435 DNS \ud83d\udc48"

    const/4 v1, 0x1

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 217
    invoke-virtual {p1}, Landroid/app/Activity;->finishAffinity()V

    goto :goto_0

    .line 219
    :cond_0
    invoke-interface {p2}, Landroid/content/DialogInterface;->dismiss()V

    .line 221
    :goto_0
    return-void
.end method

.method static synthetic lambda$showVipDialog$8(Landroid/content/Context;)V
    .locals 2
    .param p0, "context"    # Landroid/content/Context;

    .line 208
    const-string v0, "[MTG MODS]\n\u2705 \u0420\u0435\u043a\u043b\u0430\u043c\u0430 \u043e\u0442\u043a\u043b\u044e\u0447\u0435\u043d\u0430 \u2705"

    const/4 v1, 0x1

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method static synthetic lambda$showVipDialog$9(Ljava/lang/String;Landroid/content/Context;Landroid/app/Activity;)V
    .locals 2
    .param p0, "key"    # Ljava/lang/String;
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "activity"    # Landroid/app/Activity;

    .line 206
    invoke-static {p0, p1}, Lcom/arizona/launcher/MtgTools;->isValidKey(Ljava/lang/String;Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 207
    const-string v0, "mtg"

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "key"

    invoke-interface {v0, v1, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 208
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v1, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda7;

    invoke-direct {v1, p1}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda7;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    goto :goto_0

    .line 209
    :cond_0
    sget-boolean v0, Lcom/arizona/launcher/MtgTools;->forceVip:Z

    if-eqz v0, :cond_1

    .line 210
    invoke-virtual {p2}, Landroid/app/Activity;->finishAffinity()V

    .line 212
    :cond_1
    :goto_0
    return-void
.end method

.method private static postRequest(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;)Ljava/lang/String;
    .locals 11
    .param p0, "urlStr"    # Ljava/lang/String;
    .param p1, "key"    # Ljava/lang/String;
    .param p2, "device"    # Ljava/lang/String;
    .param p3, "useIp"    # Z
    .param p4, "hostHeader"    # Ljava/lang/String;

    .line 47
    const-string v0, "MtgTools"

    const/4 v1, 0x0

    .line 49
    .local v1, "c":Ljavax/net/ssl/HttpsURLConnection;
    const/4 v2, 0x0

    :try_start_0
    new-instance v3, Ljava/net/URL;

    invoke-direct {v3, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v3

    check-cast v3, Ljavax/net/ssl/HttpsURLConnection;

    move-object v1, v3

    .line 50
    const-string v3, "POST"

    invoke-virtual {v1, v3}, Ljavax/net/ssl/HttpsURLConnection;->setRequestMethod(Ljava/lang/String;)V

    .line 51
    const/16 v3, 0x1388

    invoke-virtual {v1, v3}, Ljavax/net/ssl/HttpsURLConnection;->setConnectTimeout(I)V

    .line 52
    invoke-virtual {v1, v3}, Ljavax/net/ssl/HttpsURLConnection;->setReadTimeout(I)V

    .line 53
    const/4 v3, 0x1

    invoke-virtual {v1, v3}, Ljavax/net/ssl/HttpsURLConnection;->setDoOutput(Z)V

    .line 55
    const-string v4, "{\"key\":\"%s\",\"device\":\"%s\"}"

    if-eqz p2, :cond_0

    move-object v5, p2

    goto :goto_0

    :cond_0
    const-string v5, ""

    :goto_0
    filled-new-array {p1, v5}, [Ljava/lang/Object;

    move-result-object v5

    invoke-static {v4, v5}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    .line 56
    .local v4, "json":Ljava/lang/String;
    sget-object v5, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v4, v5}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v5

    .line 58
    .local v5, "out":[B
    const-string v6, "Content-Type"

    const-string v7, "application/json"

    invoke-virtual {v1, v6, v7}, Ljavax/net/ssl/HttpsURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 59
    array-length v6, v5

    invoke-virtual {v1, v6}, Ljavax/net/ssl/HttpsURLConnection;->setFixedLengthStreamingMode(I)V

    .line 61
    if-eqz p3, :cond_1

    .line 62
    const-string v6, "Host"

    invoke-virtual {v1, v6, p4}, Ljavax/net/ssl/HttpsURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 63
    const-string v6, "TLS"

    invoke-static {v6}, Ljavax/net/ssl/SSLContext;->getInstance(Ljava/lang/String;)Ljavax/net/ssl/SSLContext;

    move-result-object v6

    .line 64
    .local v6, "sc":Ljavax/net/ssl/SSLContext;
    new-array v3, v3, [Ljavax/net/ssl/TrustManager;

    new-instance v7, Lcom/arizona/launcher/MtgTools$1;

    invoke-direct {v7}, Lcom/arizona/launcher/MtgTools$1;-><init>()V

    const/4 v8, 0x0

    aput-object v7, v3, v8

    new-instance v7, Ljava/security/SecureRandom;

    invoke-direct {v7}, Ljava/security/SecureRandom;-><init>()V

    invoke-virtual {v6, v2, v3, v7}, Ljavax/net/ssl/SSLContext;->init([Ljavax/net/ssl/KeyManager;[Ljavax/net/ssl/TrustManager;Ljava/security/SecureRandom;)V

    .line 69
    invoke-virtual {v6}, Ljavax/net/ssl/SSLContext;->getSocketFactory()Ljavax/net/ssl/SSLSocketFactory;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljavax/net/ssl/HttpsURLConnection;->setSSLSocketFactory(Ljavax/net/ssl/SSLSocketFactory;)V

    .line 70
    new-instance v3, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda9;

    invoke-direct {v3}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda9;-><init>()V

    invoke-virtual {v1, v3}, Ljavax/net/ssl/HttpsURLConnection;->setHostnameVerifier(Ljavax/net/ssl/HostnameVerifier;)V

    .line 73
    .end local v6    # "sc":Ljavax/net/ssl/SSLContext;
    :cond_1
    invoke-virtual {v1}, Ljavax/net/ssl/HttpsURLConnection;->getResponseCode()I

    move-result v3

    .line 74
    .local v3, "code":I
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "HTTP code: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, " from "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v0, v6}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 76
    const/16 v6, 0x190

    if-lt v3, v6, :cond_2

    invoke-virtual {v1}, Ljavax/net/ssl/HttpsURLConnection;->getErrorStream()Ljava/io/InputStream;

    move-result-object v6

    goto :goto_1

    :cond_2
    invoke-virtual {v1}, Ljavax/net/ssl/HttpsURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v6
    :try_end_0
    .catch Ljava/net/UnknownHostException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    .line 77
    .local v6, "is":Ljava/io/InputStream;
    :goto_1
    if-nez v6, :cond_4

    .line 96
    if-eqz v1, :cond_3

    invoke-virtual {v1}, Ljavax/net/ssl/HttpsURLConnection;->disconnect()V

    .line 77
    :cond_3
    return-object v2

    .line 79
    :cond_4
    :try_start_1
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    .line 80
    .local v7, "sb":Ljava/lang/StringBuilder;
    new-instance v8, Ljava/io/BufferedReader;

    new-instance v9, Ljava/io/InputStreamReader;

    invoke-direct {v9, v6}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    invoke-direct {v8, v9}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    :try_end_1
    .catch Ljava/net/UnknownHostException; {:try_start_1 .. :try_end_1} :catch_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_2

    .line 82
    .local v8, "in":Ljava/io/BufferedReader;
    :goto_2
    :try_start_2
    invoke-virtual {v8}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v9

    move-object v10, v9

    .local v10, "line":Ljava/lang/String;
    if-eqz v9, :cond_5

    invoke-virtual {v7, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_2

    .line 83
    .end local v10    # "line":Ljava/lang/String;
    :cond_5
    :try_start_3
    invoke-virtual {v8}, Ljava/io/BufferedReader;->close()V

    .line 85
    .end local v8    # "in":Ljava/io/BufferedReader;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    .line 86
    .local v8, "body":Ljava/lang/String;
    invoke-virtual {v8}, Ljava/lang/String;->isEmpty()Z

    move-result v0
    :try_end_3
    .catch Ljava/net/UnknownHostException; {:try_start_3 .. :try_end_3} :catch_1
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0
    .catchall {:try_start_3 .. :try_end_3} :catchall_2

    if-eqz v0, :cond_7

    .line 96
    if-eqz v1, :cond_6

    invoke-virtual {v1}, Ljavax/net/ssl/HttpsURLConnection;->disconnect()V

    .line 86
    :cond_6
    return-object v2

    .line 88
    :cond_7
    nop

    .line 96
    if-eqz v1, :cond_8

    invoke-virtual {v1}, Ljavax/net/ssl/HttpsURLConnection;->disconnect()V

    .line 88
    :cond_8
    return-object v8

    .line 80
    .local v8, "in":Ljava/io/BufferedReader;
    :catchall_0
    move-exception v9

    :try_start_4
    invoke-virtual {v8}, Ljava/io/BufferedReader;->close()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    goto :goto_3

    :catchall_1
    move-exception v10

    :try_start_5
    invoke-virtual {v9, v10}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    .end local v1    # "c":Ljavax/net/ssl/HttpsURLConnection;
    .end local p0    # "urlStr":Ljava/lang/String;
    .end local p1    # "key":Ljava/lang/String;
    .end local p2    # "device":Ljava/lang/String;
    .end local p3    # "useIp":Z
    .end local p4    # "hostHeader":Ljava/lang/String;
    :goto_3
    throw v9
    :try_end_5
    .catch Ljava/net/UnknownHostException; {:try_start_5 .. :try_end_5} :catch_1
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_0
    .catchall {:try_start_5 .. :try_end_5} :catchall_2

    .line 96
    .end local v3    # "code":I
    .end local v4    # "json":Ljava/lang/String;
    .end local v5    # "out":[B
    .end local v6    # "is":Ljava/io/InputStream;
    .end local v7    # "sb":Ljava/lang/StringBuilder;
    .end local v8    # "in":Ljava/io/BufferedReader;
    .restart local v1    # "c":Ljavax/net/ssl/HttpsURLConnection;
    .restart local p0    # "urlStr":Ljava/lang/String;
    .restart local p1    # "key":Ljava/lang/String;
    .restart local p2    # "device":Ljava/lang/String;
    .restart local p3    # "useIp":Z
    .restart local p4    # "hostHeader":Ljava/lang/String;
    :catchall_2
    move-exception v0

    goto :goto_4

    .line 92
    :catch_0
    move-exception v3

    .line 93
    .local v3, "e":Ljava/lang/Exception;
    :try_start_6
    const-string v4, "Error post request: "

    invoke-static {v0, v4, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_2

    .line 94
    nop

    .line 96
    if-eqz v1, :cond_9

    invoke-virtual {v1}, Ljavax/net/ssl/HttpsURLConnection;->disconnect()V

    .line 94
    :cond_9
    return-object v2

    .line 89
    .end local v3    # "e":Ljava/lang/Exception;
    :catch_1
    move-exception v3

    .line 90
    .local v3, "e":Ljava/net/UnknownHostException;
    :try_start_7
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "DNS error: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v3}, Ljava/net/UnknownHostException;->getMessage()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v0, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_2

    .line 91
    nop

    .line 96
    if-eqz v1, :cond_a

    invoke-virtual {v1}, Ljavax/net/ssl/HttpsURLConnection;->disconnect()V

    .line 91
    :cond_a
    return-object v2

    .line 96
    .end local v3    # "e":Ljava/net/UnknownHostException;
    :goto_4
    if-eqz v1, :cond_b

    invoke-virtual {v1}, Ljavax/net/ssl/HttpsURLConnection;->disconnect()V

    .line 97
    :cond_b
    throw v0
.end method

.method public static showVipDialog(Landroid/app/Activity;Landroid/content/Context;)V
    .locals 4
    .param p0, "activity"    # Landroid/app/Activity;
    .param p1, "context"    # Landroid/content/Context;

    .line 197
    new-instance v0, Landroid/widget/EditText;

    invoke-direct {v0, p1}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    .line 198
    .local v0, "input":Landroid/widget/EditText;
    const-string v1, "\u0423\u043a\u0430\u0436\u0438\u0442\u0435 \u043a\u043b\u044e\u0447, \u043a\u043e\u0442\u043e\u0440\u044b\u0439 \u0432\u044b \u043f\u043e\u043b\u0443\u0447\u0438\u043b\u0438 \u0438\u0437 \u0431\u043e\u0442\u0430"

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V

    .line 199
    const/16 v1, 0x11

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setGravity(I)V

    .line 200
    new-instance v1, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    invoke-direct {v1, p1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;-><init>(Landroid/content/Context;)V

    .line 201
    const-string v2, "\u0423\u0437\u043d\u0430\u0442\u044c \u043f\u043e\u0434\u0440\u043e\u0431\u043d\u0435\u0439 \u043f\u0440\u043e \u0431\u043e\u043d\u0443\u0441\u044b \u0438 \u0446\u0435\u043d\u0443 VIP, \u043b\u0438\u0431\u043e \u043f\u0440\u0438\u043e\u0431\u0440\u0435\u0441\u0442\u0438 VIP \u0432\u044b \u043c\u043e\u0436\u0435\u0442\u0435 \u0432 Telegram/Discord MTG MODS, \u043d\u0430\u043f\u0440\u0438\u043c\u0435\u0440 https://t.me/mtgmods/60\n\n\u0415\u0441\u043b\u0438 \u0443 \u0432\u0430\u0441 \u0438 \u0442\u0430\u043a \u0443\u0436\u0435 \u0435\u0441\u0442\u044c \u043a\u0443\u043f\u043b\u0435\u043d\u043d\u044b\u0439 VIP, \u0442\u043e \u0432\u0432\u0435\u0434\u0438\u0442\u0435 \u0434\u0430\u043d\u043d\u044b\u0435 \u043d\u0438\u0436\u0435"

    invoke-virtual {v1, v2}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setMessage(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v1

    .line 202
    invoke-virtual {v1, v0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setView(Landroid/view/View;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v1

    new-instance v2, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda11;

    invoke-direct {v2, v0, p1, p0}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda11;-><init>(Landroid/widget/EditText;Landroid/content/Context;Landroid/app/Activity;)V

    .line 203
    const-string v3, "\u041f\u0440\u043e\u0432\u0435\u0440\u0438\u0442\u044c \u043a\u043b\u044e\u0447"

    invoke-virtual {v1, v3, v2}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v1

    new-instance v2, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda12;

    invoke-direct {v2, p1, p0}, Lcom/arizona/launcher/MtgTools$$ExternalSyntheticLambda12;-><init>(Landroid/content/Context;Landroid/app/Activity;)V

    .line 214
    const-string v3, "\u0417\u0430\u043a\u0440\u044b\u0442\u044c"

    invoke-virtual {v1, v3, v2}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v1

    .line 222
    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setCancelable(Z)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v1

    .line 223
    invoke-virtual {v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->show()Landroidx/appcompat/app/AlertDialog;

    .line 224
    return-void
.end method
