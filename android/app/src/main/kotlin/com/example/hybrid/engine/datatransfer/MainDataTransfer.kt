package com.example.hybrid.engine.datatransfer

import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.constant.OMain_FlutterSend
import com.example.hybrid.engine.manager.FlutterEngineManager
import com.example.hybrid.engine.manager.FlutterEnginer
import com.example.hybrid.engine.permission.CheckPermission

@RequiresApi(Build.VERSION_CODES.O)
class MainDataTransfer(val flutterEnginer: FlutterEnginer) : AbstractDataTransfer(flutterEnginer) {
    @RequiresApi(Build.VERSION_CODES.R)
    override fun listenFromFlutterEngineToNative(operationId: String, data: Any?): Any {
        return throwUnhandledOperationIdException(operationId);
    }
}

