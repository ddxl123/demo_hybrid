package com.example.hybrid.util

import java.lang.Exception

/**
 * 检查当前值类型是否为 [T] 类型，并返回类型为 [T] 的值。
 *
 * 若 [T] 是 Any? 可空类型，T::class 会被输出 Any，但 [T] 实际仍然是 Any? 类型。
 */
inline fun <reified T> Any?.checkType(): T {
    if (this !is T) {
        throw  Exception("Type does not match! current: ${if (this == null) null else this::class}, target: ${T::class}")
    }
    return this
}
