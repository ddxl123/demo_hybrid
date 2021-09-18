package com.example.hybrid.engine.floatingwindow

import android.annotation.SuppressLint
import android.app.Service
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.view.*
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
    var width: Int,
    var height: Int,
    var left: Int?,
    var right: Int?,
    var top: Int?,
    var bottom: Int?,
    /**
     * 设置是否获取焦点。
     *
     * 若为 true，则获取焦点；若为 false，则失去焦点；若为 null，则失去焦点但不半透明。
     */
    var isFocus: Boolean?
) {
    fun changeFrom(nViewParams: ViewParams): ViewParams {
        width = nViewParams.width
        height = nViewParams.height
        left = nViewParams.left
        right = nViewParams.right
        top = nViewParams.top
        bottom = nViewParams.bottom
        isFocus = nViewParams.isFocus
        return this
    }
}

@RequiresApi(Build.VERSION_CODES.O)
class Viewer(private val entryPointName: String, private val windowManager: WindowManager) {


    @RequiresApi(Build.VERSION_CODES.O)
    val currentViewParams: ViewParams = ViewParams(100, 100, 50, 0, 50, 0, false)

    @RequiresApi(Build.VERSION_CODES.O)
    val layoutParams: WindowManager.LayoutParams = WindowManager.LayoutParams().apply {
        type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    }

    @RequiresApi(Build.VERSION_CODES.O)
    val dragLayoutParams: WindowManager.LayoutParams = WindowManager.LayoutParams().apply {
        type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    }


    var flutterView: FlutterView? = null
        @RequiresApi(Build.VERSION_CODES.O) @SuppressLint("ClickableViewAccessibility")
        set(value) {
            field = value
            field!!.setOnTouchListener { _: View?, event: MotionEvent? ->
                if (currentViewParams.isFocus == false && event!!.action == MotionEvent.ACTION_DOWN) {
                    resetAll(currentViewParams.copy(isFocus = true))
                    windowManager.updateViewLayout(flutterView!!, layoutParams)
                } else if (currentViewParams.isFocus == true && event!!.action == MotionEvent.ACTION_OUTSIDE) {
                    resetAll(currentViewParams.copy(isFocus = false))
                    windowManager.updateViewLayout(flutterView!!, layoutParams)
                }
                // isFocus 为 null 时不做处理。

                // 若为 ture，则下次无法触发，否则当前触发完成后下次仍然会触发。
                false
            }
        }


    val dragMoveView: View = Button(GlobalApplication.context)
    val dragLeftView: View = Button(GlobalApplication.context)
    val dragRightView: View = Button(GlobalApplication.context)

    init {
//        resetAll(currentViewParams)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun resetAll(nViewParams: ViewParams): Viewer {
        currentViewParams.changeFrom(nViewParams)
        forLocation()
        forFocus()
        return this
    }


    @RequiresApi(Build.VERSION_CODES.O)
    private fun forLocation() {
        layoutParams.width = currentViewParams.width
        layoutParams.height = currentViewParams.height

        dragLayoutParams.width = currentViewParams.width / 3
        dragLayoutParams.height = dragLayoutParams.width / 2

        val isCenterVert =
            (currentViewParams.top == null && currentViewParams.bottom == null) ||
                    (currentViewParams.top != null && currentViewParams.bottom != null)
        val isCenterHorizon =
            (currentViewParams.left == null && currentViewParams.right == null) ||
                    (currentViewParams.left != null && currentViewParams.right != null)
        if (isCenterVert && !isCenterHorizon) {
            if (currentViewParams.left != null) {
                layoutParams.gravity = Gravity.CENTER_VERTICAL or Gravity.START
                layoutParams.x = currentViewParams.left!!
                layoutParams.y = 0
                dragLayoutParams.gravity = Gravity.CENTER_VERTICAL or Gravity.START
                dragLayoutParams.x =
                    currentViewParams.left!! + layoutParams.width / 2 - dragLayoutParams.width / 2
            } else {
                layoutParams.gravity = Gravity.CENTER_VERTICAL or Gravity.END
                layoutParams.x = currentViewParams.right!!
                layoutParams.y = 0
                dragLayoutParams.gravity = Gravity.CENTER_VERTICAL or Gravity.END
                dragLayoutParams.x =
                    currentViewParams.right!! + layoutParams.width / 2 - dragLayoutParams.width / 2
            }
        } else if (!isCenterVert && isCenterHorizon) {
            if (currentViewParams.top != null) {
                layoutParams.gravity = Gravity.CENTER_HORIZONTAL or Gravity.TOP
                layoutParams.x = 0
                layoutParams.y = currentViewParams.top!!
                dragLayoutParams.gravity = Gravity.CENTER_HORIZONTAL or Gravity.TOP
                dragLayoutParams.y =
                    currentViewParams.top!! + layoutParams.height / 2 - dragLayoutParams.height / 2
            } else {
                layoutParams.gravity = Gravity.CENTER_HORIZONTAL or Gravity.BOTTOM
                layoutParams.x = 0
                layoutParams.y = currentViewParams.bottom!!
                dragLayoutParams.gravity = Gravity.CENTER_HORIZONTAL or Gravity.BOTTOM
                dragLayoutParams.y =
                    currentViewParams.bottom!! + layoutParams.height / 2 - dragLayoutParams.height / 2
            }
        } else if (isCenterVert && isCenterHorizon) {
            layoutParams.gravity = Gravity.CENTER_HORIZONTAL or Gravity.CENTER_HORIZONTAL
            layoutParams.x = 0
            layoutParams.y = 0
        } else {
            if (currentViewParams.left != null && currentViewParams.top != null) {
                layoutParams.gravity = Gravity.START or Gravity.TOP
                layoutParams.x = currentViewParams.left!!
                layoutParams.y = currentViewParams.top!!
            } else if (currentViewParams.left != null && currentViewParams.top == null) {
                layoutParams.gravity = Gravity.START or Gravity.BOTTOM
                layoutParams.x = currentViewParams.left!!
                layoutParams.y = currentViewParams.bottom!!
            } else if (currentViewParams.left == null && currentViewParams.top != null) {
                layoutParams.gravity = Gravity.END or Gravity.TOP
                layoutParams.x = currentViewParams.right!!
                layoutParams.y = currentViewParams.top!!
            } else {
                layoutParams.gravity = Gravity.END or Gravity.BOTTOM
                layoutParams.x = currentViewParams.right!!
                layoutParams.y = currentViewParams.bottom!!
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun forFocus() {
        when (currentViewParams.isFocus) {
            true -> {
                layoutParams.alpha = 1.0f
                layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                        WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH

                dragLayoutParams.alpha = 1.0f
                dragLayoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                        WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH
            }
            false -> {
                layoutParams.alpha = 0.5f
                layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                        WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH
                dragLayoutParams.alpha = 0.5f
                dragLayoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                        WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH
            }
            else -> {
                layoutParams.alpha = 1.0f
                layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                        WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH
                dragLayoutParams.alpha = 1.0f
                dragLayoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
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

    val viewer: Viewer = Viewer(flutterEnginer.entryPointName, windowManager)

    private var updateFlutterViewConcurrentCount = 0

    init {
        println("--------- ${flutterEnginer.entryPointName} 入口的 AbstractFloatingWindow 已被创建，但未对其附着 flutterView。")
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
            // 解决并发问题的处理。
            updateFlutterViewConcurrentCount += 1
            val currentUpdateFlutterViewConcurrentCount = updateFlutterViewConcurrentCount


            val lastViewParams: ViewParams = viewer.currentViewParams.copy();

            if (viewer.flutterView == null || (viewer.flutterView != null && !viewer.flutterView!!.isAttachedToWindow)) {
                viewer.flutterView = FlutterView(
                    GlobalApplication.context,
                    FlutterSurfaceView(GlobalApplication.context, true)
                ).apply { attachToFlutterEngine(flutterEnginer.flutterEngine!!) }

                windowManager.addView(
                    viewer.flutterView!!,
                    if (startViewParams == null) viewer.layoutParams
                    else viewer.resetAll(startViewParams).layoutParams
                )

                Handler(Looper.getMainLooper()).postDelayed({
                    windowManager.updateViewLayout(
                        viewer.flutterView!!,
                        if (endViewParams == null) viewer.resetAll(lastViewParams).layoutParams
                        else viewer.resetAll(endViewParams).layoutParams
                    )
                }, 5000)

                println("---------------- ${flutterEnginer.entryPointName} 入口的 AbstractFloatingWindow 已附着 FlutterView！")
            } else {
                windowManager.updateViewLayout(
                    viewer.flutterView!!,
                    if (startViewParams == null) viewer.layoutParams
                    else viewer.resetAll(startViewParams).layoutParams
                )
                Handler(Looper.getMainLooper()).postDelayed({
                    windowManager.updateViewLayout(
                        viewer.flutterView!!,
                        if (endViewParams == null) viewer.resetAll(lastViewParams).layoutParams
                        else viewer.resetAll(endViewParams).layoutParams
                    )
                }, 0)
                println("---------------- ${flutterEnginer.entryPointName} 入口的 AbstractFloatingWindow 附着的 FlutterView 已被 update！")
            }


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


        } else {
            throw Exception("未允许悬浮窗权限！")
        }
    }

    /**
     * 立即移除 view。
     */
    fun removeFlutterViewImmediately() {
        if (viewer.flutterView == null || (viewer.flutterView != null && !viewer.flutterView!!.isAttachedToWindow)) {
            viewer.flutterView = null
            return
        }
        windowManager.removeView(viewer.flutterView)
        viewer.flutterView = null

        println("---------------- ${flutterEnginer.entryPointName} 入口的 AbstractFloatingWindow 附着的 FlutterView 已被移除！")
    }


}