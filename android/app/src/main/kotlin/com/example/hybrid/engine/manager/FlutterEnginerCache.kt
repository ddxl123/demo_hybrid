package com.example.hybrid.engine.manager

import android.os.Build
import androidx.annotation.RequiresApi

object FlutterEnginerCache {
    private val cacheEnginers = mutableMapOf<String, FlutterEnginer>()

    @RequiresApi(Build.VERSION_CODES.N)
    fun put(entryPointName: String, flutterEnginer: FlutterEnginer) {
        cacheEnginers.putIfAbsent(entryPointName, flutterEnginer)
    }

    fun get(entryPointName: String): FlutterEnginer? {
        return cacheEnginers[entryPointName]
    }

    fun remove(entryPointName: String) {
        cacheEnginers.remove(entryPointName)
    }

}