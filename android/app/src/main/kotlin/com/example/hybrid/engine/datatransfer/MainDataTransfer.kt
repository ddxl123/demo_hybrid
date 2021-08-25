package com.example.hybrid.engine.datatransfer

import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.FlutterEnginer
import com.example.hybrid.engine.constant.OMain_FlutterSend
import com.example.hybrid.engine.service.DataCenterService
import java.lang.Exception

class MainDataTransfer(flutterEnginer: FlutterEnginer) : BaseDataTransfer(flutterEnginer) {
    @RequiresApi(Build.VERSION_CODES.N)
    override fun listenFromFlutterEngineToNative(operationId: String, data: Any?): Any? {
        when (operationId) {
            OMain_FlutterSend.start_data_center_engine -> {
                // 创建数据中心引擎服务。
                println("-------------- start_data_center_engine")
                GlobalApplication.context.startService(
                    Intent(
                        GlobalApplication.context,
                        DataCenterService::class.java
                    )
                )
                return true
            }
            else -> {
                throw Exception("unknown $operationId")
            }
        }
    }
}