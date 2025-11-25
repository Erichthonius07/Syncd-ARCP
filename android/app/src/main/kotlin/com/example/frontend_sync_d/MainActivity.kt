package com.example.frontend_sync_d

import android.accessibilityservice.AccessibilityService
import android.app.ActivityManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.provider.Settings
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "com.syncd/accessibility"
    private var accessibilityService: AccessibilityTapService? = null
    private var mediaProjection: MediaProjection? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "performTap" -> {
                    val x = call.argument<Number>("x")?.toFloat() ?: return@setMethodCallHandler
                    val y = call.argument<Number>("y")?.toFloat() ?: return@setMethodCallHandler
                    performTap(x, y)
                    result.success(null)
                }
                "startScreenCapture" -> {
                    startScreenCapture()
                    result.success(null)
                }
                "requestAccessibilityPermission" -> {
                    requestAccessibilityPermission()
                    result.success(null)
                }
                "isAccessibilityServiceEnabled" -> {
                    result.success(isAccessibilityServiceEnabled())
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun performTap(x: Float, y: Float) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            accessibilityService?.performTap(x, y)
        }
    }

    private fun startScreenCapture() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val mediaProjectionManager = getSystemService(MediaProjectionManager::class.java)
            val intent = mediaProjectionManager?.createScreenCaptureIntent()
            if (intent != null) {
                startActivityForResult(intent, SCREEN_RECORD_REQUEST_CODE)
            }
        }
    }

    private fun requestAccessibilityPermission() {
        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        startActivity(intent)
    }

    private fun isAccessibilityServiceEnabled(): Boolean {
        val manager = getSystemService(ActivityManager::class.java)
        val services = manager.getRunningServices(Int.MAX_VALUE)
        for (service in services) {
            if (AccessibilityTapService::class.java.name == service.service.className) {
                return true
            }
        }
        return false
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        
        if (requestCode == SCREEN_RECORD_REQUEST_CODE && resultCode == RESULT_OK && data != null) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                val mediaProjectionManager = getSystemService(MediaProjectionManager::class.java)
                mediaProjection = mediaProjectionManager?.getMediaProjection(resultCode, data)
                println("✅ Screen capture permission granted")
            }
        }
    }

    companion object {
        private const val SCREEN_RECORD_REQUEST_CODE = 1000
    }
}

