package com.example.hybrid.engine.manager

import io.flutter.embedding.engine.FlutterEngineGroup
import com.example.hybrid.GlobalApplication

object FlutterEngineManager {

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


