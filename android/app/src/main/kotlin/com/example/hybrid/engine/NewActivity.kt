package com.example.hybrid.engine

import android.app.Activity
import android.os.Bundle
import android.view.ViewGroup
import android.widget.Button

class NewActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        addContentView(Button(this), ViewGroup.LayoutParams(100, 200))
    }
}