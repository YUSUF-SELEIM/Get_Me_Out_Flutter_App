package com.example.flutter_application_1

import android.content.Context
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.view.KeyEvent

class MainActivity : FlutterActivity() {
    private val CHANNEL = "VOLUME_UP_CHANNEL"
    private var volumeUpCount = 0
    private var ringtone: Ringtone? = null
    private val handler = Handler()

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "makeFakeCall") {
                if (ringtone == null) {
                    makeFakeCall()
                }
                result.success(null)
            } else if (call.method == "stopFakeCall") {
                stopFakeCall()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_VOLUME_UP) {
            volumeUpCount++
            if (volumeUpCount == 3) {
                volumeUpCount = 0
                if (ringtone == null) {
                    // Start the fake call after 30 seconds
                    handler.postDelayed({ makeFakeCall() }, 3000)
                }
            }
            return true
        }
        return super.onKeyDown(keyCode, event)
    }

    private fun makeFakeCall() {
        val ringtoneUri: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
        ringtone = RingtoneManager.getRingtone(applicationContext, ringtoneUri)
        ringtone?.play()
    }

    private fun stopFakeCall() {
        ringtone?.stop()
        ringtone = null
    }
}