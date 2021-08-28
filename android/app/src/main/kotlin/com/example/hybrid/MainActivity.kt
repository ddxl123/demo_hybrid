package com.example.hybrid

import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.constant.EngineEntryName
import com.example.hybrid.engine.datatransfer.MainDataTransfer
import com.example.hybrid.engine.manager.FlutterEngineManager
import com.example.hybrid.engine.manager.FlutterEnginer
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    @RequiresApi(Build.VERSION_CODES.N)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FlutterEnginer(EngineEntryName.main, { MainDataTransfer(it) }, this.flutterEngine!!)
    }

    @RequiresApi(Build.VERSION_CODES.R)
    override fun onDestroy() {
        super.onDestroy()
        println("---------------- MainActivity onDestroy")
    }
}