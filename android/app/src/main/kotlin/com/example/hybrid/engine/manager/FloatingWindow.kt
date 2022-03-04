package com.example.hybrid.engine.manager

import android.annotation.SuppressLint
import android.app.Service
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.view.*
import android.widget.Button
import androidx.annotation.RequiresApi
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.permission.CheckPermission
import io.flutter.embedding.android.FlutterSurfaceView
import io.flutter.embedding.android.FlutterView

@RequiresApi(Build.VERSION_CODES.O)
data class ViewParams(
    var width: Int,
    var height: Int,
    var x: Int,
    var y: Int,
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
        x = nViewParams.x
        y = nViewParams.y
        isFocus = nViewParams.isFocus
        return this
    }

    fun toJson(): Map<String, Any?> {
        return mapOf(
            "width" to width,
            "height" to height,
            "x" to x,
            "y" to y,
            "is_focus" to isFocus
        )
    }
}

object FlagType {
    // 键盘可弹起、返回键对其他位置无效。
    const val focusable: Int =
        WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH

    // 键盘不可弹起、返回键对其他位置有效。
    const val notFocusable: Int =
        WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH
}

@RequiresApi(Build.VERSION_CODES.O)
class Viewer(private val windowManager: WindowManager) {


    private var flutterView: FlutterView? = null

    fun getFlutterView(): FlutterView? {
        return flutterView;
    }

    var dragMoveView: View? = null
    var dragRightView: View? = null

    @RequiresApi(Build.VERSION_CODES.O)
    val currentViewParams: ViewParams = ViewParams(100, 100, 100, 100, false)


    @RequiresApi(Build.VERSION_CODES.O)
    val flutterViewLayoutParams: WindowManager.LayoutParams = WindowManager.LayoutParams().apply {
        type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        gravity = Gravity.START or Gravity.TOP
    }

    @RequiresApi(Build.VERSION_CODES.O)
    val dragMoveViewLayoutParams: WindowManager.LayoutParams = WindowManager.LayoutParams().apply {
        type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        gravity = Gravity.START or Gravity.TOP
        flags = FlagType.notFocusable
    }

    @RequiresApi(Build.VERSION_CODES.O)
    val dragRightViewLayoutParams: WindowManager.LayoutParams = WindowManager.LayoutParams().apply {
        type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        gravity = Gravity.START or Gravity.TOP
        flags = FlagType.notFocusable
    }

    private var lastRawX: Int = 0
    private var lastRawY: Int = 0
    private var currentRawX: Int = 0
    private var currentRawY: Int = 0

    @RequiresApi(Build.VERSION_CODES.O)
    fun addInitView(flutterView: FlutterView) {
        this.flutterView = flutterView
        dragMoveView = Button(GlobalApplication.context)
        dragRightView = Button(GlobalApplication.context)
        addOnTouchListener()
    }

    /**
     * 在 [flutterView] 中，若把 [clickToTop] 放到 [MotionEvent.ACTION_DOWN] 中，
     * 则当拖动或 up [flutterView] 时，无法输出事件，同时也会出现 [flutterView] 无法控制的问题。
     * 因此把 [clickToTop] 放到 [MotionEvent.ACTION_UP] 中，就不会触发 up，即避免了该问题的出现。
     */
    @SuppressLint("ClickableViewAccessibility")
    fun addOnTouchListener() {
        // 点击外部变半透明，点击内部恢复。
        this.flutterView!!.setOnTouchListener { _: View?, event: MotionEvent? ->
            // 点击松开时，内部恢复。
            if (currentViewParams.isFocus == false && event!!.action == MotionEvent.ACTION_UP) {
                resetLayoutParams(currentViewParams.copy(isFocus = true))
                clickToTop()
            }
            if (currentViewParams.isFocus == true && event!!.action == MotionEvent.ACTION_OUTSIDE) {
                resetLayoutParams(currentViewParams.copy(isFocus = false))
                updateViewLayout()
            }

            // isFocus 为 null 时不做处理。

            // 若为 ture，则下次无法触发，否则当前触发完成后下次仍然会触发。
            false
        }
        dragMoveView!!.setOnTouchListener { v, event ->
            when (event.action) {
                MotionEvent.ACTION_UP -> {
                    // 点击松开时，内部恢复。
                    if (currentViewParams.isFocus == false) {
                        resetLayoutParams(currentViewParams.copy(isFocus = true))
//                        updateViewLayout()
                        clickToTop()
                    }
                }
                MotionEvent.ACTION_DOWN -> {
                    // rawXY 表示相对于屏幕左上角的位置，XY 表示相对当前 view 左上角的位置。
                    lastRawX = event.rawX.toInt()
                    lastRawY = event.rawY.toInt()
                }
                MotionEvent.ACTION_MOVE -> {
                    currentRawX = event.rawX.toInt()
                    currentRawY = event.rawY.toInt()
                    // 增量
                    currentViewParams.x += currentRawX - lastRawX
                    currentViewParams.y += currentRawY - lastRawY

                    lastRawX = currentRawX
                    lastRawY = currentRawY

                    resetLayoutParams(currentViewParams)
                    windowManager.updateViewLayout(flutterView, flutterViewLayoutParams)
                    windowManager.updateViewLayout(dragMoveView, dragMoveViewLayoutParams)
                    windowManager.updateViewLayout(dragRightView, dragRightViewLayoutParams)
                }
            }
            false
        }
        dragRightView!!.setOnTouchListener { v, event ->
            when (event.action) {
                MotionEvent.ACTION_UP -> {
                    // 点击松开时，内部恢复。
                    if (currentViewParams.isFocus == false) {
                        resetLayoutParams(currentViewParams.copy(isFocus = true))
//                        updateViewLayout()
                        clickToTop()
                    }
                }
                MotionEvent.ACTION_DOWN -> {
                    lastRawX = event.rawX.toInt()
                    lastRawY = event.rawY.toInt()
                }
                MotionEvent.ACTION_MOVE -> {
                    currentRawX = event.rawX.toInt()
                    currentRawY = event.rawY.toInt()
                    // 增量
                    currentViewParams.width += currentRawX - lastRawX
                    currentViewParams.height += currentRawY - lastRawY

                    lastRawX = currentRawX
                    lastRawY = currentRawY

                    resetLayoutParams(currentViewParams)
                    windowManager.updateViewLayout(flutterView, flutterViewLayoutParams)
                    windowManager.updateViewLayout(dragMoveView, dragMoveViewLayoutParams)
                    windowManager.updateViewLayout(dragRightView, dragRightViewLayoutParams)
                }
            }
            false
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun resetLayoutParams(nViewParams: ViewParams): Viewer {
        currentViewParams.changeFrom(nViewParams)
        // 最小限制。
        if (currentViewParams.width < 100) {
            currentViewParams.width = 100
        }
        if (currentViewParams.height < 100) {
            currentViewParams.height = 100
        }
        setLayoutParamsForLocation()
        setLayoutParamsForFocus()
        return this
    }


    @RequiresApi(Build.VERSION_CODES.O)
    private fun setLayoutParamsForLocation() {
        flutterViewLayoutParams.width = currentViewParams.width
        flutterViewLayoutParams.height = currentViewParams.height
        flutterViewLayoutParams.x = currentViewParams.x
        flutterViewLayoutParams.y = currentViewParams.y

        dragRightViewLayoutParams.width = flutterViewLayoutParams.width / 3
        dragRightViewLayoutParams.height = dragRightViewLayoutParams.width / 2
        dragRightViewLayoutParams.x =
            flutterViewLayoutParams.x + flutterViewLayoutParams.width - dragRightViewLayoutParams.width
        dragRightViewLayoutParams.y =
            flutterViewLayoutParams.y + flutterViewLayoutParams.height - dragRightViewLayoutParams.height

        dragMoveViewLayoutParams.width = dragRightViewLayoutParams.width
        dragMoveViewLayoutParams.height = dragRightViewLayoutParams.height
        dragMoveViewLayoutParams.x = dragRightViewLayoutParams.x - dragRightViewLayoutParams.width
        dragMoveViewLayoutParams.y = dragRightViewLayoutParams.y
        if (dragMoveViewLayoutParams.width <= 100) {
            dragMoveViewLayoutParams.width = 100
        }
        if (dragMoveViewLayoutParams.height <= 50) {
            dragMoveViewLayoutParams.height = 50
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun setLayoutParamsForFocus() {
        when (currentViewParams.isFocus) {
            true -> {
                flutterViewLayoutParams.alpha = 1.0f
                flutterViewLayoutParams.flags = FlagType.focusable
            }
            false -> {
                flutterViewLayoutParams.alpha = 0.5f
                flutterViewLayoutParams.flags = FlagType.notFocusable
            }
            else -> {
                flutterViewLayoutParams.alpha = 1.0f
                flutterViewLayoutParams.flags = FlagType.notFocusable
            }
        }
        dragMoveViewLayoutParams.alpha = flutterViewLayoutParams.alpha
        dragRightViewLayoutParams.alpha = flutterViewLayoutParams.alpha
    }

    private fun updateViewLayout() {
        windowManager.updateViewLayout(flutterView, flutterViewLayoutParams)
        windowManager.updateViewLayout(dragRightView, dragRightViewLayoutParams)
        windowManager.updateViewLayout(dragMoveView, dragMoveViewLayoutParams)
    }

    /**
     * 点击当前创建，让当前窗口置顶。
     */
    private fun clickToTop() {
        windowManager.removeView(flutterView)
        windowManager.removeView(dragRightView)
        windowManager.removeView(dragMoveView)
        windowManager.addView(flutterView, flutterViewLayoutParams)
        windowManager.addView(dragRightView, dragRightViewLayoutParams)
        windowManager.addView(dragMoveView, dragMoveViewLayoutParams)
    }
}


@RequiresApi(Build.VERSION_CODES.O)
class FloatingWindow(private val flutterEnginer: FlutterEnginer) {
    private var windowManager: WindowManager =
        GlobalApplication.context.getSystemService(Service.WINDOW_SERVICE) as WindowManager

    val viewer: Viewer = Viewer(windowManager)

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
        if (CheckPermission.checkFloatingWindow(true)) {
            // 解决并发问题的处理。
            updateFlutterViewConcurrentCount += 1
            val currentUpdateFlutterViewConcurrentCount = updateFlutterViewConcurrentCount


            val lastViewParams: ViewParams = viewer.currentViewParams.copy();

            if (viewer.getFlutterView() == null || (viewer.getFlutterView() != null && !viewer.getFlutterView()!!.isAttachedToWindow)) {
                viewer.addInitView(
                    FlutterView(
                        GlobalApplication.context,
                        FlutterSurfaceView(GlobalApplication.context, true)
                    ).apply { attachToFlutterEngine(flutterEnginer.flutterEngine!!) })

                windowManager.addView(
                    viewer.getFlutterView()!!,
                    if (startViewParams == null) viewer.flutterViewLayoutParams
                    // -= 1 防止第一次 addView 后再立即 updateView 时，flutter 渲染的图形是第一次 addView 的大小。
                    else viewer.resetLayoutParams(
                        startViewParams.apply { width -= 1 }
                    ).flutterViewLayoutParams
                )
                windowManager.addView(viewer.dragRightView, viewer.dragRightViewLayoutParams)
                windowManager.addView(viewer.dragMoveView, viewer.dragMoveViewLayoutParams)

                Handler(Looper.getMainLooper()).postDelayed({
                    windowManager.updateViewLayout(
                        viewer.getFlutterView()!!,
                        if (endViewParams == null) viewer.resetLayoutParams(
                            lastViewParams
                        ).flutterViewLayoutParams
                        else viewer.resetLayoutParams(endViewParams).flutterViewLayoutParams
                    )
                    windowManager.updateViewLayout(
                        viewer.dragRightView,
                        viewer.dragRightViewLayoutParams
                    )
                    windowManager.updateViewLayout(
                        viewer.dragMoveView,
                        viewer.dragMoveViewLayoutParams
                    )

                }, 0)

                println("---------------- ${flutterEnginer.entryPointName} 入口的 AbstractFloatingWindow 已附着 FlutterView！")
            } else {
                windowManager.updateViewLayout(
                    viewer.getFlutterView()!!,
                    if (startViewParams == null) viewer.flutterViewLayoutParams
                    else viewer.resetLayoutParams(startViewParams).flutterViewLayoutParams
                )
                windowManager.updateViewLayout(
                    viewer.dragRightView,
                    viewer.dragRightViewLayoutParams
                )
                windowManager.updateViewLayout(viewer.dragMoveView, viewer.dragMoveViewLayoutParams)

                Handler(Looper.getMainLooper()).postDelayed({
                    windowManager.updateViewLayout(
                        viewer.getFlutterView()!!,
                        if (endViewParams == null) viewer.resetLayoutParams(
                            lastViewParams
                        ).flutterViewLayoutParams
                        else viewer.resetLayoutParams(endViewParams).flutterViewLayoutParams
                    )
                    windowManager.updateViewLayout(
                        viewer.dragRightView,
                        viewer.dragRightViewLayoutParams
                    )
                    windowManager.updateViewLayout(
                        viewer.dragMoveView,
                        viewer.dragMoveViewLayoutParams
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
        if (viewer.getFlutterView() == null || (viewer.getFlutterView() != null && !viewer.getFlutterView()!!.isAttachedToWindow)) {
//            viewer.flutterView = null
            return
        }
//        windowManager.removeView(viewer.flutterView)
//        viewer.flutterView = null

        println("---------------- ${flutterEnginer.entryPointName} 入口的 AbstractFloatingWindow 附着的 FlutterView 已被移除！")
    }


}