package com.example.hybrid.engine.floatingwindow

import android.app.Service
import android.os.Build
import android.view.Gravity
import android.view.WindowManager
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.manager.FlutterEnginer
import com.example.hybrid.engine.permission.CheckPermission
import java.util.*

@RequiresApi(Build.VERSION_CODES.O)
abstract class AbstractFloatingWindow(val flutterEnginer: FlutterEnginer) {
    private var windowManager: WindowManager =
        flutterEnginer.service!!.getSystemService(Service.WINDOW_SERVICE) as WindowManager

    private var layoutParams: WindowManager.LayoutParams = WindowManager.LayoutParams()

    init {
        layoutParams.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
        layoutParams.gravity = Gravity.START or Gravity.TOP
        layoutParams.width = 1
        layoutParams.height = 1
        layoutParams.x = 1
        layoutParams.y = 1
        addFlutterView()
    }

    fun setSize(width: Int, height: Int): AbstractFloatingWindow {
        layoutParams.width = width
        layoutParams.height = height
        return this
    }

    fun setPosition(x: Int, y: Int): AbstractFloatingWindow {
        layoutParams.x = x
        layoutParams.y = y
        return this
    }

    private fun addFlutterView() {
        // 有权限才能打开悬浮窗，但即使无权限，其引擎仍然在后台执行。
        if (CheckPermission.checkFloatingWindow(true)) {
            windowManager.addView(flutterEnginer.flutterView!!, layoutParams)
        } else {
            // 以保证授权成功后进行 addView
            val timer = Timer()
            timer.schedule(
                object : TimerTask() {
                    override fun run() {
                        if (CheckPermission.checkFloatingWindow(false)) {
                            windowManager.addView(flutterEnginer.flutterView!!, layoutParams)
                            timer.cancel()
                        }
                    }
                }, 1000
            )
        }
    }

    /**
     * 移除 view。
     */
    fun removeFlutterView() {
        windowManager.removeView(flutterEnginer.flutterView!!)
    }


}