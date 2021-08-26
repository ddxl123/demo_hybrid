package com.example.hybrid.engine.manager

import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.constant.EngineEntryName
import com.example.hybrid.engine.datatransfer.AndroidPermissionDataTransfer
import com.example.hybrid.engine.datatransfer.DataCenterDataTransfer
import com.example.hybrid.engine.datatransfer.MainDataTransfer
import com.example.hybrid.engine.floatingwindow.DataCenterFloatingWindow
import com.example.hybrid.engine.service.DataCenterService

/**
 * 由 [FlutterEngineManager] 启动。
 */
class FlutterEnginers {
    val main = FlutterEnginer(EngineEntryName.main, { MainDataTransfer(it) }, null, null)


    @RequiresApi(Build.VERSION_CODES.O)
    val data_center = FlutterEnginer(
        EngineEntryName.data_center,
        { DataCenterDataTransfer(it) },
        { DataCenterService(it) },
        { DataCenterFloatingWindow(it) })

    @RequiresApi(Build.VERSION_CODES.O)
    val android_permission = FlutterEnginer(
        EngineEntryName.android_permission,
        { AndroidPermissionDataTransfer(it) },
        null,
        null
    )
}