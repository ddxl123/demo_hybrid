package com.example.hybrid.engine.datatransfer

import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.constant.EngineEntryName
import com.example.hybrid.engine.constant.OAndroidPermission_FlutterSend
import com.example.hybrid.engine.constant.OExecute_FlutterSend
import com.example.hybrid.engine.floatingwindow.ViewParams
import com.example.hybrid.engine.manager.FlutterEngineManager
import com.example.hybrid.engine.manager.FlutterEnginer
import com.example.hybrid.engine.permission.CheckPermission
import com.example.hybrid.util.checkType
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StandardMessageCodec

/**
 * 当 [FlutterEngine] 被附着在 [FlutterEnginer] 时会生成 [AbstractDataTransfer]，这时 [AbstractDataTransfer] 会执行自身的构造函数进行初始化。
 *
 * 这里 [context] 使用 val 修饰不清楚到底会不会出现内存泄露。
 */
@RequiresApi(Build.VERSION_CODES.O)
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
                        nativeInterception(
                            flutterEnginer,
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
     *
     * 不能返回空。
     */
    private fun nativeInterception(
        flutterEnginer: FlutterEnginer,
        operationId: String,
        data: Any?
    ): Any {
        return startEngineInterception(flutterEnginer, operationId, data)
            ?: androidPermissionInterception(operationId)
            ?: listenFromFlutterEngineToNative(operationId, data)
    }

    /**
     * 若返回 null，则继续下一个拦截。
     */
    private fun startEngineInterception(
        flutterEnginer: FlutterEnginer,
        operationId: String,
        data: Any?
    ): Any? {
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
                FlutterEngineManager.getFlutterEnginersByEntryPoint(data.checkType())!!.hadFirstFrameInitialized
            }
            // set view。
            OExecute_FlutterSend.SET_VIEW -> {
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

                val setWhichEngineView: String = dataMap["set_which_engine_view"].checkType()
                val startViewParams: ViewParams? = setViewParams("start_view_params")
                val endViewParams: ViewParams? = setViewParams("end_view_params")
                val closeViewAfterSeconds: Int? =
                    dataMap["close_view_after_seconds"].checkType()

                FlutterEngineManager.updateView(
                    setWhichEngineView,
                    startViewParams,
                    endViewParams,
                    closeViewAfterSeconds
                )
                // 是否 update view 成功。
                true
            }

            else -> null
        }
    }

    /**
     * 若返回 null，则继续下一个拦截。
     */
    private fun androidPermissionInterception(operationId: String): Any? {
        return when (operationId) {
            OAndroidPermission_FlutterSend.CHECK_FLOATING_WINDOW_PERMISSION -> {
                // 是否已允许悬浮窗权限。
                CheckPermission.checkFloatingWindow(false)
            }
            OAndroidPermission_FlutterSend.CHECK_AND_PUSH_PAGE_FLOATING_WINDOW_PERMISSION -> {
                // 是否已允许悬浮窗权限。（若未允许则打开悬浮窗权限设置页面）
                CheckPermission.checkFloatingWindow(true)
            }
            else -> null
        }
    }


    /**
     * 监听来自不同的 [FlutterEnginer] 的传输数据。
     *
     * 不能返回空。
     */
    abstract fun listenFromFlutterEngineToNative(operationId: String, data: Any?): Any
}