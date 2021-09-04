package com.example.hybrid.engine.datatransfer

import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.constant.OMain_FlutterSend
import com.example.hybrid.engine.manager.FlutterEngineManager
import com.example.hybrid.engine.manager.FlutterEnginer
import com.example.hybrid.engine.permission.CheckPermission

class MainDataTransfer(val flutterEnginer: FlutterEnginer) : AbstractDataTransfer(flutterEnginer) {
    @RequiresApi(Build.VERSION_CODES.R)
    override fun listenFromFlutterEngineToNative(operationId: String, data: Any?): Any? {
        when (operationId) {
            OMain_FlutterSend.check_floating_window_permission -> {
                return CheckPermission.checkFloatingWindow(false)
            }
            OMain_FlutterSend.check_and_push_page_floating_window_permission -> {
                return CheckPermission.checkFloatingWindow(true)
            }
            OMain_FlutterSend.start_data_center_engine_and_keep_background_running_by_floating_window -> {
                // 启动数据中心引擎服务。
//                FlutterEngineManager.startServiceAndEngine(DataCenterService::class.java)

                // 引擎启动成功。
                return true
            }


            else -> {
                return throwUnhandledOperationIdException(operationId)
            }
        }
    }
}

