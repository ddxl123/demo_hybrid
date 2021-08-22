package com.example.hybrid.engine

import com.example.hybrid.FlutterEnginer
import com.example.hybrid.engine.transfer.DataCenterEngineDataTransfer
import com.example.hybrid.engine.transfer.MainEngineDataTransfer

object FlutterEnginers {
    val main = FlutterEnginer("") { MainEngineDataTransfer(it) }

    val data_center = FlutterEnginer("data_center") { DataCenterEngineDataTransfer(it) }
}