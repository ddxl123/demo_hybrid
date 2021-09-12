package com.example.hybrid.engine.datatransfer

import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.manager.FlutterEnginer

@RequiresApi(Build.VERSION_CODES.O)
class LoginAndRegisterDataTransfer(flutterEnginer: FlutterEnginer) :AbstractDataTransfer(flutterEnginer) {
    override fun listenFromFlutterEngineToNative(operationId: String, data: Any?): Any {
        TODO("Not yet implemented")
    }
}