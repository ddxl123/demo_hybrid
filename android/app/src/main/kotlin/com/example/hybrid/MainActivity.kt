package com.example.hybrid

import android.annotation.SuppressLint
import android.content.Intent
import android.graphics.Color
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import androidx.annotation.RequiresApi
import androidx.lifecycle.LifecycleObserver
import io.flutter.FlutterInjector
import io.flutter.embedding.android.*
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineGroup
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformPlugin


class MainActivity : FlutterActivity(), LifecycleObserver {

    companion object {
        lateinit var flutterView1: FlutterView;
        lateinit var flutterView2: FlutterView;
        lateinit var flutterView3: FlutterView;
    }


    @RequiresApi(Build.VERSION_CODES.M)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val flutterEngineGroup = FlutterEngineGroup(this)

        val point1 = DartExecutor.DartEntrypoint(
                FlutterInjector.instance().flutterLoader().findAppBundlePath(), "point1")
        val point2 = DartExecutor.DartEntrypoint(
                FlutterInjector.instance().flutterLoader().findAppBundlePath(), "point2")
        val point3 = DartExecutor.DartEntrypoint(
                FlutterInjector.instance().flutterLoader().findAppBundlePath(), "point3")

        val point1Engine = flutterEngineGroup.createAndRunEngine(this, point1)
        val point2Engine = flutterEngineGroup.createAndRunEngine(this, point2)
        val point3Engine = flutterEngineGroup.createAndRunEngine(this, point3)

        flutterView1 = FlutterView(this, FlutterSurfaceView(this, true))
        flutterView2 = FlutterView(this, FlutterSurfaceView(this, true))
        flutterView3 = FlutterView(this, FlutterSurfaceView(this, true))

        PlatformPlugin(this, point1Engine.platformChannel)
        PlatformPlugin(this, point2Engine.platformChannel)
        PlatformPlugin(this, point3Engine.platformChannel)

        point1Engine.activityControlSurface.attachToActivity(this, lifecycle)
        point2Engine.activityControlSurface.attachToActivity(this, lifecycle)
        point3Engine.activityControlSurface.attachToActivity(this, lifecycle)

        flutterView1.attachToFlutterEngine(point1Engine)
        flutterView2.attachToFlutterEngine(point2Engine)
        flutterView3.attachToFlutterEngine(point3Engine)

        point1Engine.lifecycleChannel.appIsResumed()
        point2Engine.lifecycleChannel.appIsResumed()
        point3Engine.lifecycleChannel.appIsResumed()

//        val flutterChannel = MethodChannel(engine.dartExecutor, "method_channel")
//        flutterChannel.invokeMethod("demo_method", "哈哈哈哈哈哈哈")

        if (!Settings.canDrawOverlays(this)) {
            println("~~~~~~~~ 无权限")
            startActivityForResult(
                    Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:" + activity.packageName)), 0)
        } else {
            startService(Intent(activity, DemoService::class.java))
        }
    }
//
//    override fun onPause() {
//        super.onPause()
//        onResume()
//        engine.lifecycleChannel.appIsResumed()
//    }
//
//    override fun onStop() {
//        super.onStop()
//        onResume()
//        engine.lifecycleChannel.appIsResumed()
//    }
}
