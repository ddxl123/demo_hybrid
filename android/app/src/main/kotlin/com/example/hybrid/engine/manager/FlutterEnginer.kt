package com.example.hybrid.engine.manager

import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.datatransfer.AbstractDataTransfer
import com.example.hybrid.engine.floatingwindow.AbstractFloatingWindow
import com.example.hybrid.engine.service.AbstractService
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterSurfaceView
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import com.example.hybrid.MainActivity

class FlutterEnginer(
    val entryPointName: String,
    private val putEngineDataTransfer: (FlutterEnginer) -> AbstractDataTransfer,
    private val putService: ((FlutterEnginer) -> AbstractService)?,
    private val putFloatingWindow: ((FlutterEnginer) -> AbstractFloatingWindow)?
) {
    init {
        println("--------- $entryPointName 入口的 FlutterEnginer 已被创建，但未附着对应的 FlutterEngine。")
    }

    val channelName = "data_channel"
    var flutterEngine: FlutterEngine? = null
    var flutterView: FlutterView? = null
    var dataTransfer: AbstractDataTransfer? = null
    var service: AbstractService? = null
    var floatingWindow: AbstractFloatingWindow? = null

    private val isAttach
        get() = flutterEngine != null

    /**
     * 将已有的 [MainActivity] 的 [FlutterEngine] 附着在 [FlutterEnginer] 上。
     *
     * 当 [flutterEngine] != null 时，不会被重新 [attachMain]。
     *
     * 构建内容:
     *  1. [flutterEngine] - 必选
     *  2. [dataTransfer] - 必选
     *  3. [FlutterEnginerCache] - 必选
     */
    @RequiresApi(Build.VERSION_CODES.N)
    fun attachMain(flutterEngine: FlutterEngine): FlutterEnginer {
        if (isAttach) {
            return this
        }

        this.flutterEngine = flutterEngine

        moreInit()

        return this
    }

    /**
     * 创建一个新 [FlutterEngine] 并将其附着在当前 [FlutterEnginer] 上。
     *
     * 当 [flutterEngine] != null 时，不会被重新 [createNewEngineAndAttach] 。
     *
     * 构建内容:
     *  1. [flutterEngine] - 必选
     *  2. [flutterView] - 必选
     *  3. [service] - 可选 (根据 [putService] 是否为空)
     *  4. [floatingWindow] - 可选 (根据 [putFloatingWindow] 是否为空)
     *  5. [dataTransfer] - 必选
     *  6. [FlutterEnginerCache] - 必选
     */
    @RequiresApi(Build.VERSION_CODES.O)
    fun createNewEngineAndAttach(): FlutterEnginer {
        if (isAttach) {
            return this
        }

        val entryPoint = DartExecutor.DartEntrypoint(
            FlutterInjector.instance().flutterLoader().findAppBundlePath(), entryPointName
        )

        flutterEngine = FlutterEngineManager.flutterEngineGroup.createAndRunEngine(
            GlobalApplication.context,
            entryPoint
        ).apply { lifecycleChannel.appIsResumed() }


        flutterView = FlutterView(
            GlobalApplication.context,
            FlutterSurfaceView(GlobalApplication.context, true)
        ).apply { attachToFlutterEngine((flutterEngine!!)) }

        service = putService?.invoke(this)
        floatingWindow = putFloatingWindow?.invoke(this)

        moreInit()

        return this
    }

    /**
     * 一旦 [FlutterEnginer] 被 [FlutterEngine] 附着，便 [moreInit]。
     */
    @RequiresApi(Build.VERSION_CODES.N)
    private fun moreInit() {
        this.dataTransfer = putEngineDataTransfer(this)

        FlutterEnginerCache.put(this.entryPointName, this)

        println("--------- $entryPointName 入口的 FlutterEngine 已附着。")
    }

    /**
     * 可见但不响应用户输入，程序保持运行。
     */
    fun toInactive() {
        flutterEngine!!.lifecycleChannel.appIsInactive()
    }

    /**
     * 不可见且不响应用户输入，程序保持运行。
     */
    fun toPaused() {
        flutterEngine!!.lifecycleChannel.appIsPaused()
    }

    /**
     * 销毁该引擎。
     */
    @RequiresApi(Build.VERSION_CODES.O)
    fun toDestroy() {
        dataTransfer = null

        floatingWindow?.removeFlutterView()
        floatingWindow = null
        flutterView = null

        FlutterEnginerCache.remove(this.entryPointName)
        flutterEngine?.destroy()
        flutterEngine = null

        service?.stopSelf()
        service = null
    }
}