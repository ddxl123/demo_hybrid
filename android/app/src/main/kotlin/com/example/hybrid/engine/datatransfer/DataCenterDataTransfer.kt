package com.example.hybrid.engine.datatransfer

import android.content.Context
import com.example.hybrid.engine.FlutterEnginer

class DataCenterDataTransfer(flutterEnginer: FlutterEnginer) : BaseDataTransfer(flutterEnginer) {

    override fun listenFromFlutterEngineToNative(operationId: String, data: Any?): Any? {
        TODO("Not yet implemented")
    }
}