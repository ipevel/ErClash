package com.erclash.app.service.models

data class NotificationParams(
    val title: String = "ErClash",
    val stopText: String = "STOP",
    val onlyStatisticsProxy: Boolean = false,
    val showStopAction: Boolean = true,
)
