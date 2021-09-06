package com.example.hybrid.engine.floatingwindow

import android.app.Service
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.view.Gravity
import android.view.WindowManager
import androidx.annotation.RequiresApi
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.manager.FlutterEnginer
import com.example.hybrid.engine.permission.CheckPermission
import io.flutter.embedding.android.FlutterSurfaceView
import io.flutter.embedding.android.FlutterView
import java.lang.Exception


data class ViewParams(val width: Int, val height: Int, val x: Int, val y: Int, val alpha: Float)

@RequiresApi(Build.VERSION_CODES.O)
abstract class AbstractFloatingWindow(val flutterEnginer: FlutterEnginer) {
    private var windowManager: WindowManager =
        GlobalApplication.context.getSystemService(Service.WINDOW_SERVICE) as WindowManager

    private var layoutParams: WindowManager.LayoutParams = WindowManager.LayoutParams()

    private var flutterView: FlutterView? = null

    private var updateFlutterViewConcurrentCount = 0

    /**
     * 初始化只创建了一个透明的 window，而未对其附着 flutterView。
     */
    init {
        layoutParams.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        // 可点击非悬浮窗部分。
        layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
        // 防止其他应用和当前应用返回键失效。
        layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
        layoutParams.gravity = Gravity.START or Gravity.TOP

        // 默认 view 配置。
        setViewParams(ViewParams(0, 0, 0, 0, 1.0f))

        println("--------- ${flutterEnginer.entryPointName} 入口的 AbstractFloatingWindow 的透明 window 已被创建，但未对其附着 flutterView。")
    }

    private fun setViewParams(viewParams: ViewParams): WindowManager.LayoutParams {
        layoutParams.width = viewParams.width
        layoutParams.height = viewParams.height
        layoutParams.x = viewParams.x
        layoutParams.y = viewParams.y
        layoutParams.alpha = viewParams.alpha
        return layoutParams
    }


    /**
     * 更新 [FlutterView] 配置。
     *
     * 有悬浮窗权限才能操作，没有则在下拉栏里显示未运行悬浮窗权限。
     * 若无悬浮窗权限，且仍对悬浮窗进行操作，则会抛异常，消息通道会返回 null，操作者会对 null 进行异常处理。
     *
     * - 关于 [startViewParams]：
     *
     *      - 从 [startViewParams] 配置过渡到 [endViewParams] 配置。
     *
     *      - 当 [startViewParams] 为空，[endViewParams] 不为空时，表示从上一次配置过渡到 [endViewParams] 配置。
     *
     *      - 当 [startViewParams] 不为空，[endViewParams] 为空时，表示从 [startViewParams] 配置过渡到上一次配置。
     *
     *      - 当 [startViewParams] 为空，[endViewParams] 为空时，表示保持上一次配置不变。
     *
     * - 关于 [closeViewAfterSeconds]：
     *
     *      - 一旦 [startViewParams]，多少秒后关闭 view。
     *
     *      - 为空或为负数时，保持现状不关闭。
     *
     * - 关于 [flutterView]：
     *
     *      - 若 [flutterView] 为空或未被附着，则新建 [flutterView] 并附着。
     *
     *      - 若 [flutterView] 不为空且已被附着，则对当前 [flutterView] 操作。
     */
    fun updateFlutterView(
        startViewParams: ViewParams?,
        endViewParams: ViewParams?,
        closeViewAfterSeconds: Int?
    ) {


        if (CheckPermission.checkFloatingWindow(false)) {
            if (flutterView == null || !flutterView!!.isAttachedToWindow) {
                flutterView = FlutterView(
                    GlobalApplication.context,
                    FlutterSurfaceView(GlobalApplication.context, true)
                ).apply { attachToFlutterEngine(flutterEnginer.flutterEngine!!) }
            }

            val lastViewParams = ViewParams(
                layoutParams.width,
                layoutParams.height,
                layoutParams.x,
                layoutParams.y,
                layoutParams.alpha
            )

            windowManager.addView(
                flutterView!!,
                if (startViewParams == null) setViewParams(lastViewParams) else setViewParams(
                    startViewParams
                )
            )

            // 解决并发问题的处理。
            updateFlutterViewConcurrentCount += 1
            val currentUpdateFlutterViewConcurrentCount = updateFlutterViewConcurrentCount

            Handler(Looper.getMainLooper()).postDelayed({
                windowManager.updateViewLayout(
                    flutterView!!,
                    if (endViewParams == null) setViewParams(lastViewParams) else setViewParams(
                        endViewParams
                    )
                )
            }, 0)


            // 多久后立即关闭。
            // 为空或为负数时，保持现状。
            if (closeViewAfterSeconds != null && closeViewAfterSeconds >= 0) {
                Handler(Looper.getMainLooper()).postDelayed({
                    // 当发生并发时，以最后一次请求为准。
                    if (updateFlutterViewConcurrentCount == currentUpdateFlutterViewConcurrentCount) {
                        updateFlutterViewConcurrentCount = 0
                        removeFlutterViewImmediately()
                    }
                }, closeViewAfterSeconds.toLong() * 1000)
            }

            println("---------------- ${flutterEnginer.entryPointName} 入口的 AbstractFloatingWindow 已被 FlutterView 附着！")

        } else {
            throw Exception("未允许悬浮窗权限！")
        }
    }

    /**
     * 立即移除 view。
     */
    fun removeFlutterViewImmediately() {
        if (flutterView == null || (flutterView != null && flutterView!!.isAttachedToWindow)) {
            flutterView = null
            return
        }
        windowManager.removeView(flutterView)
        flutterView = null

        println("---------------- ${flutterEnginer.entryPointName} 入口的 AbstractFloatingWindow 的 FlutterView 已被移除！")
    }


}