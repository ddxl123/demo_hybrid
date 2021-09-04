package com.example.hybrid.engine.manager

import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.FlutterEngineGroup
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.datatransfer.AbstractDataTransfer
import com.example.hybrid.engine.floatingwindow.AbstractFloatingWindow
import com.example.hybrid.engine.floatingwindow.ViewParams
import com.example.hybrid.util.snakeCaseToCamelCase
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
     * 仅启动 [FlutterEngine]、[AbstractDataTransfer]、[AbstractFloatingWindow]，
     * 而 [AbstractFloatingWindow.flutterView] 需调用 [AbstractFloatingWindow.updateFlutterView] 进行手动启动。
     *
     * 如果已被启动，则直接返回现有的。
     */
    @RequiresApi(Build.VERSION_CODES.O)
    fun startFlutterEngine(entryPointName: String): FlutterEnginer {
        if (FlutterEnginerCache.containsKey(entryPointName)) {
            return FlutterEnginerCache.get(entryPointName)!!
        }

        val entryPointNameCamelCase = entryPointName.snakeCaseToCamelCase()

        val flutterEnginer = FlutterEnginer(
            entryPointName,
            {
                Class.forName("${entryPointNameCamelCase}DataTransfer")
                    .getDeclaredConstructor(FlutterEnginer::class.java)
                    .newInstance(it) as AbstractDataTransfer
            },
            {
                Class.forName("${entryPointNameCamelCase}FloatingWindow")
                    .getDeclaredConstructor(FlutterEnginer::class.java)
                    .newInstance(it) as AbstractFloatingWindow
            })

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
        closeViewAfterSeconds: Int
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


