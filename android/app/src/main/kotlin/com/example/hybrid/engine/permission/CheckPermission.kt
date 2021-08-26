package com.example.hybrid.engine.permission

import android.content.Intent
import android.os.Build
import android.provider.Settings
import androidx.annotation.RequiresApi
import com.example.hybrid.GlobalApplication

object CheckPermission {

    /**
     * 检查是否已允许悬浮窗权限。
     *
     * @param isPopupPermissionWindowWhenUnAllowed 当为 true 时，且未被允许权限时，是否弹出授权引擎 Activity。
     */
    @RequiresApi(Build.VERSION_CODES.M)
    fun checkFloatingWindow(isPopupPermissionWindowWhenUnAllowed: Boolean): Boolean {
        val isAllowed = Settings.canDrawOverlays(GlobalApplication.context)
        if (!isAllowed && isPopupPermissionWindowWhenUnAllowed) {
            GlobalApplication.context.startActivity(
                Intent(
                    GlobalApplication.context,
                    CheckPermissionActivity::class.java
                )
            )
        }
        return isAllowed
    }
}