package com.example.hybrid.engine

import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.datatransfer.BaseDataTransfer
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterSurfaceView
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineGroup
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StandardMessageCodec
import com.example.hybrid.GlobalApplication

object FlutterEngineHandler {

    /**
     * 由 [GlobalApplication.onCreate] 进行初始化。
     */
    fun init() {}

    val flutterEngineGroup: FlutterEngineGroup = FlutterEngineGroup(GlobalApplication.context)

    /**
     * 根据 api 直接调用 [FlutterEnginer]。
     */
    val getFlutterEnginersByObject: FlutterEnginers = FlutterEnginers()

    /**
     * 根据 [entryPointName] 来获取对应的 [FlutterEnginer]。
     */
    fun getFlutterEnginersByEntryPoint(entryPointName: String): FlutterEnginer? {
        return FlutterEnginerCache.get(entryPointName)
    }

}

private object FlutterEnginerCache {
    private val cacheEnginers = mutableMapOf<String, FlutterEnginer>()

    @RequiresApi(Build.VERSION_CODES.N)
    fun put(entryPointName: String, flutterEnginer: FlutterEnginer) {
        cacheEnginers.putIfAbsent(entryPointName, flutterEnginer)
    }

    fun get(entryPointName: String): FlutterEnginer? {
        return cacheEnginers[entryPointName]
    }

    fun remove(entryPointName: String) {
        cacheEnginers.remove(entryPointName)
    }

}


/**
 * 这里 [context] 使用 val 修饰不清楚到底会不会出现内存泄露。
 */
class FlutterEnginer(
    val entryPointName: String,
    private val putEngineDataTransfer: (FlutterEnginer) -> BaseDataTransfer
) {
    init {
        println("--------- $entryPointName 入口的 FlutterEnginer 已被创建，但未附着对应的 FlutterEngine。")
    }

    private val channelName = "data_channel"
    var flutterEngine: FlutterEngine? = null
    var flutterView: FlutterView? = null
    var basicMessageChannel: BasicMessageChannel<Any?>? = null
    var dataTransfer: BaseDataTransfer? = null

    /**
     * 将已有的 [FlutterEngine] 附着在 [FlutterEnginer] 上。
     *
     * 当 [flutterEngine] != null 时，不会被重新 [attachMain]。
     */
    @RequiresApi(Build.VERSION_CODES.N)
    fun attachMain(flutterEngine: FlutterEngine) {
        if (this.flutterEngine != null) {
            return
        }

        this.flutterEngine = flutterEngine

        init()

    }

    /**
     * 创建一个新 [FlutterEngine] 并将其附着在当前 [FlutterEnginer] 上。
     *
     * 当 [flutterEngine] != null 时，不会被重新 [create] 。
     */
    @RequiresApi(Build.VERSION_CODES.N)
    fun create() {
        if (flutterEngine != null) {
            return
        }

        val entryPoint = DartExecutor.DartEntrypoint(
            FlutterInjector.instance().flutterLoader().findAppBundlePath(), entryPointName
        )

        flutterEngine =
            FlutterEngineHandler.flutterEngineGroup.createAndRunEngine(
                GlobalApplication.context,
                entryPoint
            )

        flutterView = FlutterView(
            GlobalApplication.context,
            FlutterSurfaceView(GlobalApplication.context, true)
        )

        flutterView!!.attachToFlutterEngine(flutterEngine!!)

        flutterEngine!!.lifecycleChannel.appIsResumed()

        init()

    }

    /**
     * 一旦 [FlutterEnginer] 被 [FlutterEngine] 附着，便 [init]。
     */
    @RequiresApi(Build.VERSION_CODES.N)
    private fun init() {
        // 绑定通道。
        this.basicMessageChannel =
            BasicMessageChannel(
                this.flutterEngine!!.dartExecutor.binaryMessenger,
                channelName,
                StandardMessageCodec()
            )

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
    fun toDestroy() {
        flutterView?.removeAllViews()
        flutterEngine?.destroy()
        FlutterEnginerCache.remove(this.entryPointName)
        basicMessageChannel = null
        flutterView = null
        flutterEngine = null
    }
}
