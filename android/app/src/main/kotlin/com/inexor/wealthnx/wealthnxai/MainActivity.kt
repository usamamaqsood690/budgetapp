package com.stackstars.budget.ai

import android.os.Bundle
import android.webkit.WebView
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // ✅ Enable in-app WebView debugging (safe for production)
        WebView.setWebContentsDebuggingEnabled(true)
    }
}