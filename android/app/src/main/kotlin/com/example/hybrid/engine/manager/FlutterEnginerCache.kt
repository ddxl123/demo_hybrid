package com.example.hybrid.engine.manager

import android.annotation.TargetApi
import android.os.Build

object FlutterEnginerCache {
    private val cacheEnginers = mutableMapOf<String, FlutterEnginer>()

    @TargetApi(Build.VERSION_CODES.N)
    fun put(entryPointName: String, flutterEnginer: FlutterEnginer) {
        cacheEnginers.putIfAbsent(entryPointName, flutterEnginer)
    }

    fun get(entryPointName: String): FlutterEnginer? {
        return cacheEnginers[entryPointName]
    }

    fun containsKey(entryPointName: String): Boolean {
        return cacheEnginers.containsKey(entryPointName)
    }

    fun remove(entryPointName: String) {
        cacheEnginers.remove(entryPointName)
    }

}