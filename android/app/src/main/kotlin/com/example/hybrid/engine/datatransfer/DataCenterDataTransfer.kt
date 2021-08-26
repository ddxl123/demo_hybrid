package com.example.hybrid.engine.datatransfer

import com.example.hybrid.engine.manager.FlutterEnginer

class DataCenterDataTransfer(flutterEnginer: FlutterEnginer) : AbstractDataTransfer(flutterEnginer) {

    override fun listenFromFlutterEngineToNative(operationId: String, data: Any?): Any? {
        TODO("Not yet implemented")
    }
}