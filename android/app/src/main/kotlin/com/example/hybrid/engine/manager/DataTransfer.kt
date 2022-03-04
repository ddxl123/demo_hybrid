package com.example.hybrid.engine.manager

import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.constant.execute.EngineEntryName
import com.example.hybrid.engine.constant.execute.OToNative
import com.example.hybrid.engine.permission.CheckPermission
import com.example.hybrid.util.checkType
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StandardMessageCodec

/**
 * 当 [FlutterEngine] 被附着在 [FlutterEnginer] 时会生成 [DataTransfer]，这时 [DataTransfer] 会执行自身的构造函数进行初始化。
 *
 * 这里 [context] 使用 val 修饰不清楚到底会不会出现内存泄露。
 */
@RequiresApi(Build.VERSION_CODES.O)
class DataTransfer(private val flutterEnginer: FlutterEnginer) {

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
                            messageMap["operation_data"]
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

    /**
     * 固定拦截。
     *
     * 不能返回空。
     */
    @RequiresApi(Build.VERSION_CODES.O)
    private fun nativeInterception(
        flutterEnginer: FlutterEnginer,
        operationId: String,
        data: Any?
    ): Any {
        return startEngineInterception(flutterEnginer, operationId, data)
            ?: androidPermissionInterception(operationId)
            ?: otherInterception(operationId, data)
            ?: listenFromFlutterEngineToNative(operationId, data)
    }

    /**
     * 若返回 null，则继续下一个拦截。
     */
    @RequiresApi(Build.VERSION_CODES.O)
    private fun startEngineInterception(
        flutterEnginer: FlutterEnginer,
        operationId: String,
        data: Any?
    ): Any? {
        return when (operationId) {
            // 来自引擎A的操作，启动新引擎B。如果引擎已存在，则使用已存在的。
            OToNative.START_ENGINE -> {
                println("starting: ${flutterEnginer.entryPointName}");
                val dataMap = data.checkType<Map<String, Any?>>()
                val startWhichEngine: String = dataMap["start_which_engine"].checkType()
                val startWhenClose: Boolean = dataMap["start_when_close"].checkType()

                val isStarted: FlutterEnginer? = FlutterEnginerCache.get(startWhichEngine)

                if (isStarted != null) {
                    // 已启动，返回 true。
                    true
                }

                if (startWhenClose) {
                    println("starting startWhenClose: ${flutterEnginer.entryPointName}");
                    FlutterEngineManager.startFlutterEngine(startWhichEngine)
                    println("started startWhenClose: ${flutterEnginer.entryPointName}");
                    // 返回 true 启动成功。
                    true
                } else {
                    false
                }

            }
            // set view。
            OToNative.SET_VIEW_PARAMS -> {
                val dataMap = data.checkType<Map<String, Any?>>()

                @RequiresApi(Build.VERSION_CODES.O)
                fun setViewParams(viewParamsKey: String): ViewParams? {
                    return if (dataMap[viewParamsKey] != null) {
                        val viewParamsMap: Map<String, Any?> = dataMap[viewParamsKey].checkType()
                        ViewParams(
                            width = viewParamsMap["width"].checkType(),
                            height = viewParamsMap["height"].checkType(),
                            x = viewParamsMap["x"].checkType(),
                            y = viewParamsMap["y"].checkType(),
                            isFocus = viewParamsMap["is_focus"].checkType()
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
            OToNative.CHECK_FLOATING_WINDOW_PERMISSION -> {
                // 是否已允许悬浮窗权限。
                CheckPermission.checkFloatingWindow(false)
            }
            OToNative.CHECK_AND_PUSH_PAGE_FLOATING_WINDOW_PERMISSION -> {
                // 是否已允许悬浮窗权限。（若未允许则打开悬浮窗权限设置页面）
                CheckPermission.checkFloatingWindow(true)
            }
            else -> null
        }
    }

    /**
     *
     */
    @RequiresApi(Build.VERSION_CODES.O)
    private fun otherInterception(operationId: String, data: Any?): Any? {
        return when (operationId) {
            OToNative.GET_NATIVE_WINDOW_VIEW_PARAMS -> {
                return FlutterEngineManager.getFlutterEnginersByEntryPoint(data.checkType())!!.floatingWindow!!.viewer.currentViewParams.toJson()
            }
            OToNative.GET_SCREEN_SIZE -> {
                println("GlobalApplication.context.resources.displayMetrics.heightPixels ${GlobalApplication.context.resources.displayMetrics.heightPixels}")
                return mapOf(
                    "width" to GlobalApplication.context.resources.displayMetrics.widthPixels,
                    "height" to GlobalApplication.context.resources.displayMetrics.heightPixels
                )
            }
            else -> null
        }
    }

    /**
     * 监听来自不同的 [FlutterEnginer] 的传输数据。
     *
     * 不能返回空。
     */
    private fun listenFromFlutterEngineToNative(operationId: String, data: Any?): Any {
        throw Exception("Unhandled $operationId")
    }
}