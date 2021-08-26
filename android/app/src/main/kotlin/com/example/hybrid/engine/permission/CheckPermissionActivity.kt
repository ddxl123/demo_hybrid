package com.example.hybrid.engine.permission

import android.app.Activity
import android.os.Build
import android.os.Bundle
import android.view.ViewGroup
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.manager.FlutterEngineManager

class CheckPermissionActivity : Activity() {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FlutterEngineManager.getFlutterEnginersByObject.android_permission.createNewEngineAndAttach()

        addContentView(
            FlutterEngineManager.getFlutterEnginersByObject.android_permission.flutterView!!,
            // 等待引擎 flutter 页面第一帧被初始化完成后重新设置
            ViewGroup.LayoutParams(400, 400)
        )


//        startActivity(
//            Intent(
//                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
//                Uri.parse("package:" + this.packageName)
//            )
//        )
    }
}