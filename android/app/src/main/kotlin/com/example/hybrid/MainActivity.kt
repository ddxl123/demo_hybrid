package com.example.hybrid

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        FlutterEngineHandler.init(this)

        FlutterEngineHandler.flutterEnginers.main.attachMain(flutterEngine!!)
    }
}
