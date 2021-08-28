package com.example.hybrid.engine.manager

import android.content.Intent
import io.flutter.embedding.engine.FlutterEngineGroup
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.service.AbstractService

object FlutterEngineManager {

    val flutterEngineGroup: FlutterEngineGroup = FlutterEngineGroup(GlobalApplication.context)

    /**
     * 根据 [entryPointName] 来获取对应的 [FlutterEnginer]。
     */
    fun getFlutterEnginersByEntryPoint(entryPointName: String): FlutterEnginer? {
        return FlutterEnginerCache.get(entryPointName)
    }

    /**
     * 根据 [serviceClass] 来启动对应的 [AbstractService]。
     */
    fun startService(serviceClass: Class<out AbstractService>) {
        GlobalApplication.context.startService(Intent(GlobalApplication.context, serviceClass))
    }
}


