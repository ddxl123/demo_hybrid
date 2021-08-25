package com.example.hybrid.engine.datatransfer

import android.content.Context
import com.example.hybrid.engine.FlutterEngineHandler
import com.example.hybrid.engine.FlutterEnginer
import java.lang.Exception

/**
 * 当 [FlutterEngine] 被附着在 [FlutterEnginer] 时会生成 [BaseDataTransfer]，这时 [BaseDataTransfer] 会执行自身的构造函数进行初始化。
 *
 * 这里 [context] 使用 val 修饰不清楚到底会不会出现内存泄露。
 */
abstract class BaseDataTransfer(flutterEnginer: FlutterEnginer) {
    init {
        flutterEnginer.basicMessageChannel!!.setMessageHandler { message, reply ->

            val messageMap = message as Map<*, *>
            when (val sendToWhichEngine = messageMap["send_to_which_engine"] as String) {
                "native" -> reply.reply(
                    listenFromFlutterEngineToNative(
                        messageMap["operation_id"] as String,
                        messageMap["data"]
                    )
                )

                else -> {
                    val toFlutterEnginer =
                        FlutterEngineHandler.getFlutterEnginersByEntryPoint(sendToWhichEngine)!!

                    toFlutterEnginer.basicMessageChannel!!.send(messageMap) {
                        reply.reply(it)
                    }
                }
            }
        }
        println("--------- ${flutterEnginer.entryPointName} 入口的 BaseDataTransfer 已被创建。")
    }

    abstract fun listenFromFlutterEngineToNative(operationId: String, data: Any?): Any?
}