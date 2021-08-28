package com.example.hybrid.engine.permission

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.annotation.RequiresApi
import com.example.hybrid.GlobalApplication

object CheckPermission {

    /**
     * 检查是否已允许悬浮窗权限。
     *
     * @param isPushSettingPageWhenUnAllowed 当为 true 时，且未被允许权限时，是否弹出权限设置页面。
     */
    @RequiresApi(Build.VERSION_CODES.M)
    fun checkFloatingWindow(isPushSettingPageWhenUnAllowed: Boolean): Boolean {
        val isAllowed = Settings.canDrawOverlays(GlobalApplication.context)
        if (!isAllowed && isPushSettingPageWhenUnAllowed) {
            GlobalApplication.context.startActivity(
                Intent(
                    Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                    Uri.parse("package:" + GlobalApplication.context.packageName)
                ).setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            )
        }
        return isAllowed
    }
}