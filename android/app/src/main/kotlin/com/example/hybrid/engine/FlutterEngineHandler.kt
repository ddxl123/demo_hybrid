package com.example.hybrid

import android.content.Context
import com.example.hybrid.engine.FlutterEnginers
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterSurfaceView
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineGroup
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StandardMessageCodec

object FlutterEngineHandler {

    var isInit: Boolean = false
    lateinit var flutterEngineGroup: FlutterEngineGroup

    val flutterEnginers = FlutterEnginers

    fun init(context: Context) {
        if (isInit) return else isInit = true
        this.flutterEngineGroup = FlutterEngineGroup(context)
    }
}


class FlutterEnginer(
    private val entryPointName: String,
    val putEngineDataTransfer: (FlutterEnginer) -> BaseEngineDataTransfer
) {

    private val channelName = "data_channel"
    var flutterEngine: FlutterEngine? = null
    var flutterView: FlutterView? = null
    var basicMessageChannel: BasicMessageChannel<Any?>? = null
    var engineDataTransfer: BaseEngineDataTransfer? = null

    /**
     * 将已有的 [FlutterEngine] 附着在 [FlutterEnginer] 上。
     *
     * 当 [flutterEngine] != null 时，不会被重新 [attachMain]。
     */
    fun attachMain(flutterEngine: FlutterEngine) {
        if (this.flutterEngine != null) {
            return
        }

        this.flutterEngine = flutterEngine

        other()

    }

    /**
     * 创建一个新 [FlutterEngine] 并将其附着在当前 [FlutterEnginer] 上。
     *
     * 当 [flutterEngine] != null 时，不会被重新 [create] 。
     */
    fun create(context: Context) {
        if (flutterEngine != null) {
            return
        }

        val entryPoint = DartExecutor.DartEntrypoint(
            FlutterInjector.instance().flutterLoader().findAppBundlePath(), entryPointName
        )

        flutterEngine =
            FlutterEngineHandler.flutterEngineGroup.createAndRunEngine(context, entryPoint)

        flutterView = FlutterView(context, FlutterSurfaceView(context, true))

        flutterView!!.attachToFlutterEngine(flutterEngine!!)

        flutterEngine!!.lifecycleChannel.appIsResumed()

        other()

    }

    private fun other() {
        basicMessageChannel =
            BasicMessageChannel(
                this.flutterEngine!!.dartExecutor.binaryMessenger,
                channelName,
                StandardMessageCodec()
            )

        // 只有在引擎被创建/附着的时候才能获取这个。
        this.engineDataTransfer = putEngineDataTransfer(this)
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
    fun toDestroy() {
        flutterView?.removeAllViews()
        flutterEngine?.destroy()
        basicMessageChannel = null
        flutterView = null
        flutterEngine = null
    }
}

abstract class BaseEngineDataTransfer(flutterEnginer: FlutterEnginer)