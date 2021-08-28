package com.example.hybrid.engine.floatingwindow

import android.app.ActivityManager
import android.app.Application
import android.app.Service
import android.graphics.Rect
import android.os.Build
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.widget.Button
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat.getSystemService
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.manager.FlutterEnginer
import com.example.hybrid.engine.permission.CheckPermission
import kotlin.system.exitProcess


@RequiresApi(Build.VERSION_CODES.R)
abstract class AbstractFloatingWindow(
    val flutterEnginer: FlutterEnginer,
    val defaultRect: Rect,
    val isAddFlutterView: Boolean
) {
    private var windowManager: WindowManager =
        GlobalApplication.context.getSystemService(Service.WINDOW_SERVICE) as WindowManager

    private var layoutParams: WindowManager.LayoutParams = WindowManager.LayoutParams()

    init {
        layoutParams.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        // 可点击非悬浮窗部分。
        layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
        // 防止其他应用和当前应用返回键失效。
        layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
        layoutParams.gravity = Gravity.START or Gravity.TOP
        layoutParams.width = defaultRect.width()
        layoutParams.height = defaultRect.height()
        layoutParams.x = defaultRect.left
        layoutParams.y = defaultRect.top
        addView()
        println("--------- ${flutterEnginer.entryPointName} 入口的 AbstractFloatingWindow 已被创建。")
    }

    fun setRectAndUpdate(rect: Rect): AbstractFloatingWindow {
        layoutParams.width = rect.width()
        layoutParams.height = rect.height()
        layoutParams.x = rect.left
        layoutParams.y = rect.top
        windowManager.updateViewLayout(flutterEnginer.flutterView!!, layoutParams)
        return this;
    }


    private fun addView() {
        // 有悬浮窗权限才能添加，没有则直接退出程序。
        if (CheckPermission.checkFloatingWindow(false)) {
            if (isAddFlutterView) {
                windowManager.addView(flutterEnginer.flutterView!!, layoutParams)
                println("---------------- ${flutterEnginer.entryPointName} 入口的悬浮窗已开启，并添加了 FlutterView！")
            } else {
                windowManager.addView(View(GlobalApplication.context), layoutParams);
                println("---------------- ${flutterEnginer.entryPointName} 入口的悬浮窗已开启，但未添加 FlutterView！")
            }
        } else {
            exitProcess(0)
        }
    }

    fun updateView() {
        windowManager.updateViewLayout(flutterEnginer.flutterView!!, layoutParams)
    }

    /**
     * 移除 view。
     */
    fun removeView() {
        windowManager.removeView(flutterEnginer.flutterView!!)
    }


}