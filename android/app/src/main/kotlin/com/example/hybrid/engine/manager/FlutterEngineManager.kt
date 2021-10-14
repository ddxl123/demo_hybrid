package com.example.hybrid.engine.manager

import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.FlutterEngineGroup
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.constant.execute.EngineEntryName
import io.flutter.embedding.engine.FlutterEngine

object FlutterEngineManager {

    val flutterEngineGroup: FlutterEngineGroup = FlutterEngineGroup(GlobalApplication.context)

    /**
     * 根据 [entryPointName] 来获取对应的 [FlutterEnginer]。
     */
    fun getFlutterEnginersByEntryPoint(entryPointName: String): FlutterEnginer? {
        return FlutterEnginerCache.get(entryPointName)
    }

    /**
     * 根据 [entryPointName] 来启动对应的 [FlutterEnginer]。
     *
     * 仅启动 [FlutterEngine]、[DataTransfer]、[FloatingWindow]，
     * 而 [FloatingWindow.flutterView] 需调用 [FloatingWindow.updateFlutterView] 进行手动启动。
     *
     * 如果已被启动，则直接返回现有的。
     */
    @RequiresApi(Build.VERSION_CODES.O)
    fun startFlutterEngine(
        entryPointName: String,
        mainEngine: FlutterEngine? = null
    ): FlutterEnginer {
        if (FlutterEnginerCache.containsKey(entryPointName)) {
            return FlutterEnginerCache.get(entryPointName)!!
        }

        val flutterEnginer: FlutterEnginer
        if (entryPointName == EngineEntryName.main) {
            flutterEnginer = FlutterEnginer(
                entryPointName,
                { fe ->
                    Class.forName("${GlobalApplication.context.packageName}.engine.manager.DataTransfer")
                        .getDeclaredConstructor(FlutterEnginer::class.java)
                        .newInstance(fe) as DataTransfer
                }, mainEngine!!
            )
        } else {
            flutterEnginer = FlutterEnginer(
                entryPointName,
                { fe ->
                    Class.forName("${GlobalApplication.context.packageName}.engine.manager.DataTransfer")
                        .getDeclaredConstructor(FlutterEnginer::class.java)
                        .newInstance(fe) as DataTransfer
                },
                { fe ->
                    Class.forName("${GlobalApplication.context.packageName}.engine.manager.FloatingWindow")
                        .getDeclaredConstructor(FlutterEnginer::class.java)
                        .newInstance(fe) as FloatingWindow
                })
        }

        FlutterEnginerCache.put(entryPointName, flutterEnginer)

        return flutterEnginer
    }

    /**
     * 必须在 [startFlutterEngine] 之后调用，否则会抛出异常。
     */
    @RequiresApi(Build.VERSION_CODES.O)
    fun updateView(
        entryPointName: String,
        startViewParams: ViewParams?,
        endViewParams: ViewParams?,
        closeViewAfterSeconds: Int?
    ) {
        FlutterEnginerCache.get(entryPointName)!!.floatingWindow!!.updateFlutterView(
            startViewParams,
            endViewParams,
            closeViewAfterSeconds
        )
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun closeView(entryPointName: String) {
        FlutterEnginerCache.get(entryPointName)?.floatingWindow?.removeFlutterViewImmediately()
    }
}


