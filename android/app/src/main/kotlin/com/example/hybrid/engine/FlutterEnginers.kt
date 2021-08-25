package com.example.hybrid.engine

import android.content.Context
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.datatransfer.DataCenterDataTransfer
import com.example.hybrid.engine.datatransfer.MainDataTransfer

/**
 * 由 [FlutterEngineHandler] 启动。
 */
class FlutterEnginers {
    val main = FlutterEnginer("main") { MainDataTransfer(it) }

    val data_center = FlutterEnginer("data_center") { DataCenterDataTransfer(it) }
}