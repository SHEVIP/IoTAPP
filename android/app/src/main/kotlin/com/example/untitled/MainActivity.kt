package com.example.untitled

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.untitled/open_browser"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openBrowser") {
                val url = call.argument<String>("url")
                if (url != null) {
                    openBrowser(url)
                    result.success(null)
                } else {
                    result.error("INVALID_URL", "URL is null or invalid", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun openBrowser(url: String) {
        val intent = Intent(Intent.ACTION_VIEW)
        intent.data = Uri.parse(url)
        startActivity(intent)
    }
}

