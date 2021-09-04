package com.example.hybrid.engine.datatransfer

import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.constant.EngineEntryName
import com.example.hybrid.engine.constant.OExecute_FlutterSend
import com.example.hybrid.engine.floatingwindow.ViewParams
import com.example.hybrid.engine.manager.FlutterEngineManager
import com.example.hybrid.engine.manager.FlutterEnginer
import com.example.hybrid.util.checkType
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StandardMessageCodec

/**
 * 当 [FlutterEngine] 被附着在 [FlutterEnginer] 时会生成 [AbstractDataTransfer]，这时 [AbstractDataTransfer] 会执行自身的构造函数进行初始化。
 *
 * 这里 [context] 使用 val 修饰不清楚到底会不会出现内存泄露。
 */
@RequiresApi(Build.VERSION_CODES.O)
abstract class AbstractDataTransfer(val flutterEnginer: FlutterEnginer) {

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
                        fixedInterception(
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

    /**
     * 固定拦截。
     */
    private fun fixedInterception(operationId: String, data: Any?): Any? {
        return when (operationId) {
            // 来自引擎A的操作，启动新引擎B。如果引擎已存在，则使用已存在的。
            OExecute_FlutterSend.START_ENGINE -> {
                val dataMap = data.checkType<Map<String, Any?>>()
                val startWhichEngine: String = dataMap["start_which_engine"].checkType()
                FlutterEngineManager.startFlutterEngine(startWhichEngine)
                // 返回 true 启动成功。
                true
            }
            // 当被启动的引擎第一帧已被初始化完成，则触发这个。
            OExecute_FlutterSend.SET_FIRST_FRAME_INITIALIZED -> {
                flutterEnginer.hadFirstFrameInitialized = true
                // 返回 true 第一帧初始化成功。
                true
            }
            // 获取第一帧是否已被初始化完成。
            OExecute_FlutterSend.IS_FIRST_FRAME_INITIALIZED -> {
                // 返回 true 第一帧已初始化成功，返回 false 第一帧未初始化。
                flutterEnginer.hadFirstFrameInitialized
            }
            // set view。
            OExecute_FlutterSend.SET_VIEW -> {
                // 不需要设置 view 的引擎。
                if (flutterEnginer.entryPointName == EngineEntryName.main) {
                    true
                } else {
                    val dataMap = data.checkType<Map<String, Any?>>()

                    fun setViewParams(viewParamsKey: String): ViewParams? {
                        return if (dataMap[viewParamsKey] != null) {
                            val viewParamsMap =
                                dataMap[viewParamsKey].checkType<Map<String, Any?>>()
                            ViewParams(
                                width = viewParamsMap["width"].checkType(),
                                height = viewParamsMap["height"].checkType(),
                                x = viewParamsMap["x"].checkType(),
                                y = viewParamsMap["y"].checkType(),
                                alpha = viewParamsMap["alpha"].checkType()
                            )
                        } else {
                            null
                        }
                    }

                    val startViewParams: ViewParams? = setViewParams("start_view_params")
                    val endViewParams: ViewParams? = setViewParams("end_view_params")
                    val closeViewAfterSeconds = dataMap["close_view_after_seconds"].checkType<Int>()

                    FlutterEngineManager.updateView(
                        flutterEnginer.entryPointName,
                        startViewParams,
                        endViewParams,
                        closeViewAfterSeconds
                    )
                    // 是否 update view 成功。
                    true
                }
            }

            else -> {
                listenFromFlutterEngineToNative(operationId, data)
            }
        }
    }

    /**
     * 监听来自不同的 [FlutterEnginer] 的传输数据。
     */
    abstract fun listenFromFlutterEngineToNative(operationId: String, data: Any?): Any?
}