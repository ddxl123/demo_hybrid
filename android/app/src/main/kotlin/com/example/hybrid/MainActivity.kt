package com.example.hybrid

import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.FlutterEngineHandler
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    @RequiresApi(Build.VERSION_CODES.N)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FlutterEngineHandler.getFlutterEnginersByObject.main.attachMain(flutterEngine!!)
    }

    override fun onDestroy() {
        super.onDestroy()
        println("---------------111 onDestroy")
    }
}