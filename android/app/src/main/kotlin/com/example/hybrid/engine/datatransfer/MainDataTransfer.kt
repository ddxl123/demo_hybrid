package com.example.hybrid.engine.datatransfer

import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.manager.FlutterEnginer
import com.example.hybrid.engine.constant.OMain_FlutterSend
import com.example.hybrid.engine.manager.FlutterEngineManager
import com.example.hybrid.util.checkType

class MainDataTransfer(val flutterEnginer: FlutterEnginer) : AbstractDataTransfer(flutterEnginer) {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun listenFromFlutterEngineToNative(operationId: String, data: Any?): Any? {
        when (operationId) {
            // 启动数据中心引擎服务。
            OMain_FlutterSend.start_data_center_engine -> {

                // 启动引擎的初始大小与位置，当引擎被初始化完成后，会被在其他 operationId 重新设置大小与位置。
                val dataMap = data.checkType<Map<*, *>>()
                val width = dataMap["width"].checkType<Int>()
                val height = dataMap["height"].checkType<Int>()
                val x = dataMap["x"].checkType<Int>()
                val y = dataMap["y"].checkType<Int>()

                FlutterEngineManager.getFlutterEnginersByObject.data_center.createNewEngineAndAttach()
                    .floatingWindow!!.setSize(width, height)
                    .setPosition(x, y)

                // 引擎启动成功。
                return true
            }

            else -> {
                return throwUnhandledOperationIdException(operationId)
            }
        }
    }
}

