package com.example.hybrid.engine.floatingwindow

import android.annotation.SuppressLint
import android.app.Service
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.Button
import androidx.annotation.RequiresApi
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.manager.FlutterEnginer
import com.example.hybrid.engine.permission.CheckPermission
import io.flutter.embedding.android.FlutterSurfaceView
import io.flutter.embedding.android.FlutterView
import java.lang.Exception


@RequiresApi(Build.VERSION_CODES.O)
data class ViewParams(
    val width: Int,
    val height: Int,
    val left: Int?,
    val right: Int?,
    val top: Int?,
    val bottom: Int?,
    val isFocus: Boolean?
) {
    val layoutParams: WindowManager.LayoutParams = WindowManager.LayoutParams()
    val dragLayoutParams: WindowManager.LayoutParams = WindowManager.LayoutParams()
    val dragMoveView: View = Button(GlobalApplication.context)
    val dragLeftView: View = Button(GlobalApplication.context)
    val dragRightView: View = Button(GlobalApplication.context)

    init {
        layoutParams.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        dragLayoutParams.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY

        setLocation(width, height, left, right, top, bottom)
        setFocus(isFocus)
    }

    private fun setLocation(
        nWidth: Int,
        nHeight: Int,
        nLeft: Int?,
        nRight: Int?,
        nTop: Int?,
        nBottom: Int?
    ) {
        layoutParams.width = nWidth
        layoutParams.height = nHeight

        dragLayoutParams.width = nWidth / 3
        dragLayoutParams.height = dragLayoutParams.width / 2

        val isCenterVert = (nTop == null && nBottom == null) || (nTop != null && nBottom != null)
        val isCenterHorizon = (nLeft == null && nRight == null) || (nLeft != null && nRight != null)
        if (isCenterVert && !isCenterHorizon) {
            if (nLeft != null) {
                layoutParams.gravity = Gravity.CENTER_VERTICAL or Gravity.START
                layoutParams.x = nLeft
                layoutParams.y = 0

            } else {
                layoutParams.gravity = Gravity.CENTER_VERTICAL or Gravity.END
                layoutParams.x = nRight!!
                layoutParams.y = 0
            }
        } else if (!isCenterVert && isCenterHorizon) {
            if (nTop != null) {
                layoutParams.gravity = Gravity.CENTER_HORIZONTAL or Gravity.TOP
                layoutParams.x = 0
                layoutParams.y = nTop
            } else {
                layoutParams.gravity = Gravity.CENTER_HORIZONTAL or Gravity.BOTTOM
                layoutParams.x = 0
                layoutParams.y = nBottom!!
            }
        } else if (isCenterVert && isCenterHorizon) {
            layoutParams.gravity = Gravity.CENTER_HORIZONTAL or Gravity.CENTER_HORIZONTAL
            layoutParams.x = 0
            layoutParams.y = 0
        } else {
            if (nLeft != null && nTop != null) {
                layoutParams.gravity = Gravity.START or Gravity.TOP
                layoutParams.x = nLeft
                layoutParams.y = nTop
            } else if (nLeft != null && nTop == null) {
                layoutParams.gravity = Gravity.START or Gravity.BOTTOM
                layoutParams.x = nLeft
                layoutParams.y = nBottom!!
            } else if (nLeft == null && nTop != null) {
                layoutParams.gravity = Gravity.END or Gravity.TOP
                layoutParams.x = nRight!!
                layoutParams.y = nTop
            } else {
                layoutParams.gravity = Gravity.END or Gravity.BOTTOM
                layoutParams.x = nRight!!
                layoutParams.y = nBottom!!
            }

        }
    }

    /**
     * 设置是否获取焦点。
     *
     * @param nIsFocus 若为 true，则获取焦点；若为 false，则失去焦点；若为 null，则失去焦点但不半透明。
     */
    private fun setFocus(nIsFocus: Boolean?) {
        when (nIsFocus) {
            true -> {
                layoutParams.alpha = 1.0f
                layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                        WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH
            }
            false -> {
                layoutParams.alpha = 0.5f
                layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                        WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH
            }
            else -> {
                layoutParams.alpha = 1.0f
                layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                        WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH
            }
        }
    }

}

@RequiresApi(Build.VERSION_CODES.O)
abstract class AbstractFloatingWindow(val flutterEnginer: FlutterEnginer) {
    private var windowManager: WindowManager =
        GlobalApplication.context.getSystemService(Service.WINDOW_SERVICE) as WindowManager

    private val viewParams = ViewParams(50, 50, 0, 0, 0, 0, null)


    private var flutterView: FlutterView? = null
        @SuppressLint("ClickableViewAccessibility")
        set(value) {
            field = value
            field!!.setOnTouchListener { _: View?, event: MotionEvent? ->
                if (!isFocus && event!!.action == MotionEvent.ACTION_DOWN) {
                    setFocus(true)
                    windowManager.updateViewLayout(flutterView!!, layoutParams)
                    println("------------------ MotionEvent.ACTION_DOWN")
                } else if (isFocus && event!!.action == MotionEvent.ACTION_OUTSIDE) {
                    setFocus(false)
                    windowManager.updateViewLayout(flutterView!!, layoutParams)
                    println("------------------ MotionEvent.ACTION_OUTSIDE")
                }
                println("---------------------1111111111 $event")
                // 若为 ture，则下次无法触发，否则当前触发完成后下次仍然会触发。
                false
            }
        }

    private var isFocus: Boolean = false
    private var updateFlutterViewConcurrentCount = 0

    /**
     * 初始化只创建了一个透明的 window，而未对其附着 flutterView。
     */
    init {
        println("--------- ${flutterEnginer.entryPointName} 入口的 AbstractFloatingWindow 的 window 已被创建，但未对其附着 flutterView。")
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
            if (flutterView == null) {
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
                layoutParams.alpha.toDouble()
            )

            if (flutterView!!.isAttachedToWindow) {
                windowManager.updateViewLayout(
                    flutterView!!,
                    if (startViewParams == null) setViewParams(lastViewParams) else setViewParams(
                        startViewParams
                    )
                )
            } else {
                windowManager.addView(
                    flutterView!!,
                    if (startViewParams == null) setViewParams(lastViewParams) else setViewParams(
                        startViewParams
                    )
                )
            }

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