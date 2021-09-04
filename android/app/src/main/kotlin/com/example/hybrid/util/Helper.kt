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

/**
 * 蛇形转驼峰。
 *
 * "abc_def_g" -> "AbcDefG"
 */
fun String.snakeCaseToCamelCase(): String {
    var currentStr = "_$this"
    Regex("_").findAll("_$this").forEach { matchResult: MatchResult ->
        val startIndex = matchResult.range.first
        currentStr = currentStr.replaceRange(
            startIndex,
            startIndex + 1,
            "_$this"[startIndex + 1].toUpperCase().toString()
        )
    }
    return currentStr
}