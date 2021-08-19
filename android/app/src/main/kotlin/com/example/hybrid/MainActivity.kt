package com.example.hybrid

import android.annotation.SuppressLint
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import androidx.annotation.RequiresApi
import androidx.lifecycle.LifecycleObserver
import io.flutter.FlutterInjector
import io.flutter.embedding.android.ExclusiveAppComponent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformPlugin


class MainActivity : FlutterActivity(), LifecycleObserver {

    companion object {
        lateinit var flutterView: FlutterView;
        lateinit var flutterView2: FlutterView;
    }

    private lateinit var engine: FlutterEngine

    @RequiresApi(Build.VERSION_CODES.M)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        engine = FlutterEngine(applicationContext)
        engine.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint(
                        FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                        "demo"))
        flutterView = FlutterView(this)
        flutterView2 = FlutterView(this)

        val platformPlugin = PlatformPlugin(activity, engine.platformChannel)
        engine.activityControlSurface.attachToActivity(this, lifecycle)

        flutterView.attachToFlutterEngine(engine)
        flutterView2.attachToFlutterEngine(engine)
        lifecycle.addObserver(this)

        engine.lifecycleChannel.appIsResumed()

//        val flutterChannel = MethodChannel(engine.dartExecutor, "method_channel")
//        flutterChannel.invokeMethod("demo_method", "哈哈哈哈哈哈哈")

        if (!Settings.canDrawOverlays(this)) {
            println("~~~~~~~~ 无权限")
            startActivityForResult(
                    Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:" + activity!!.packageName)), 0)
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
