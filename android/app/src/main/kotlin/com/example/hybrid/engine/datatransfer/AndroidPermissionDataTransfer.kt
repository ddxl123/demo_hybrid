package com.example.hybrid.engine.datatransfer

import android.os.Build
import android.provider.Settings
import androidx.annotation.RequiresApi
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.manager.FlutterEnginer
import com.example.hybrid.engine.constant.OAndroidPermission_FlutterSend

class AndroidPermissionDataTransfer(flutterEnginer: FlutterEnginer) :
    AbstractDataTransfer(flutterEnginer) {
    @RequiresApi(Build.VERSION_CODES.M)
    override fun listenFromFlutterEngineToNative(operationId: String, data: Any?): Any? {
        when (operationId) {
            OAndroidPermission_FlutterSend.check_floating_window -> {
//            startActivity(
//                Intent(
//                    Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
//                    Uri.parse("package:" + this.packageName)
//                )
//            )
                return Settings.canDrawOverlays(GlobalApplication.context)
            }
            else -> return throwUnhandledOperationIdException(operationId)
        }
    }
}