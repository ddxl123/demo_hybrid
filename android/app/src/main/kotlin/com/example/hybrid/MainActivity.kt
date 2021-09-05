package com.example.hybrid

import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.constant.EngineEntryName
import com.example.hybrid.engine.datatransfer.MainDataTransfer
import com.example.hybrid.engine.manager.FlutterEngineManager
import com.example.hybrid.engine.manager.FlutterEnginer
import com.example.hybrid.test.TestService
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FlutterEngineManager.startFlutterEngine(EngineEntryName.main, flutterEngine)
    }

    override fun onDestroy() {
        super.onDestroy()
        println("---------------- MainActivity onDestroy")
    }
}