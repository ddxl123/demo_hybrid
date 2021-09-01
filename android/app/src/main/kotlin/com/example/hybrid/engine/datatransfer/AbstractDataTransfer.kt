package com.example.hybrid.engine.datatransfer

import com.example.hybrid.engine.constant.EngineEntryName
import com.example.hybrid.engine.manager.FlutterEngineManager
import com.example.hybrid.engine.manager.FlutterEnginer
import com.example.hybrid.util.checkType
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StandardMessageCodec
import java.lang.Exception

/**
 * 当 [FlutterEngine] 被附着在 [FlutterEnginer] 时会生成 [AbstractDataTransfer]，这时 [AbstractDataTransfer] 会执行自身的构造函数进行初始化。
 *
 * 这里 [context] 使用 val 修饰不清楚到底会不会出现内存泄露。
 */
abstract class AbstractDataTransfer(flutterEnginer: FlutterEnginer) {

    private val basicMessageChannel: BasicMessageChannel<Any?> = BasicMessageChannel(
        flutterEnginer.flutterEngine!!.dartExecutor.binaryMessenger,
        flutterEnginer.channelName,
        StandardMessageCodec()
    )

    init {
        basicMessageChannel.setMessageHandler { message, reply ->

            val messageMap = message as Map<*, *>

            when (val sendToWhichEngine = messageMap["send_to_which_engine"].checkType<String>()) {
                EngineEntryName.native -> {
                    reply.reply(
                        listenFromFlutterEngineToNative(
                            messageMap["operation_id"].checkType(),
                            messageMap["data"]
                        )
                    )
                }

                else -> {
                    val toFlutterEnginer =
                        FlutterEngineManager.getFlutterEnginersByEntryPoint(sendToWhichEngine)!!
                    toFlutterEnginer.dataTransfer.basicMessageChannel.send(messageMap) {
                        reply.reply(it)
                    }
                }
            }
        }
        println("--------- ${flutterEnginer.entryPointName} 入口的 BaseDataTransfer 已被创建。")
    }


    fun throwUnhandledOperationIdException(currentOperationId: String) {
        throw Exception("Unhandled $currentOperationId")
    }

    abstract fun listenFromFlutterEngineToNative(operationId: String, data: Any?): Any?
}