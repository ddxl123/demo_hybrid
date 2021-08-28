package com.example.hybrid.engine.manager

import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.datatransfer.AbstractDataTransfer
import com.example.hybrid.engine.floatingwindow.AbstractFloatingWindow
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterSurfaceView
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import java.lang.Exception
import com.example.hybrid.engine.service.AbstractService
import com.example.hybrid.MainActivity
import com.example.hybrid.engine.constant.EngineEntryName

/**
 * 只要 [FlutterEnginer] 被创建，就会被添加到 [FlutterEnginerCache] 中，
 */
class FlutterEnginer {

    /**
     * 创建新的 [FlutterEngine] 构造器。
     *
     * 通常由 [AbstractService] 进行构造。
     */
    @RequiresApi(Build.VERSION_CODES.N)
    constructor(
        entryPointName: String,
        service: AbstractService,
        putDataTransfer: (FlutterEnginer) -> AbstractDataTransfer,
        putFloatingWindow: (FlutterEnginer) -> AbstractFloatingWindow
    ) {
        if (FlutterEnginerCache.containsKey(entryPointName)) {
            throw Exception("$entryPointName 入口的 FlutterEnginer 被重复创建！")
        }

        // 必须按照顺序。
        this.entryPointName = entryPointName
        FlutterEnginerCache.put(this.entryPointName, this)

        this.flutterEngine = FlutterEngineManager.flutterEngineGroup.createAndRunEngine(
            GlobalApplication.context,
            DartExecutor.DartEntrypoint(
                FlutterInjector.instance().flutterLoader().findAppBundlePath(), entryPointName
            )
        ).apply { lifecycleChannel.appIsResumed() }
        this.flutterView = FlutterView(
            GlobalApplication.context,
            FlutterSurfaceView(GlobalApplication.context, true)
        ).apply { attachToFlutterEngine(flutterEngine!!) }

        this.dataTransfer = putDataTransfer(this)
        this.floatingWindow = putFloatingWindow(this)

        this.service = service
    }

    /**
     * 使用已有的 [FlutterEngine] 的构造器。
     *
     * 通常由 [MainActivity] 进行构造。
     */
    @RequiresApi(Build.VERSION_CODES.N)
    constructor(
        entryPointName: String,
        putDataTransfer: (FlutterEnginer) -> AbstractDataTransfer,
        flutterEngine: FlutterEngine
    ) {
        if (FlutterEnginerCache.containsKey(entryPointName)) {
            throw Exception("$entryPointName 入口的 FlutterEnginer 被重复创建！")
        }

        // 必须按照顺序。
        this.entryPointName = entryPointName
        FlutterEnginerCache.put(this.entryPointName, this)
        this.flutterEngine = flutterEngine
        this.dataTransfer = putDataTransfer(this)
    }


    val channelName = "data_channel"
    var entryPointName: String
    var flutterEngine: FlutterEngine?
    var dataTransfer: AbstractDataTransfer

    var floatingWindow: AbstractFloatingWindow? = null
    var flutterView: FlutterView? = null

    private var service: AbstractService? = null


    /**
     * 可见但不响应用户输入，程序保持运行。
     */
    fun doInactive() {
        flutterEngine?.lifecycleChannel?.appIsInactive()
    }

    /**
     * 不可见且不响应用户输入，程序保持运行。
     */
    fun doPause() {
        flutterEngine?.lifecycleChannel?.appIsPaused()
    }

    /**
     * 彻底销毁该 [FlutterEnginer]，同时关闭对应的 [AbstractService]。
     */
    @RequiresApi(Build.VERSION_CODES.R)
    fun doDestroyCompletely() {
        this.floatingWindow?.removeView()
        this.flutterEngine = null
        this.floatingWindow = null
        this.flutterView = null
        FlutterEnginerCache.remove(this.entryPointName)
        this.service?.stopSelf()
        this.service = null
    }
}