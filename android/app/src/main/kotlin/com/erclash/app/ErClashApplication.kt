package com.erclash.app

import android.app.Application
import android.content.Context
import com.erclash.app.common.GlobalState

class ErClashApplication : Application() {
    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        GlobalState.init(this)
    }
}
