package com.kateringkita.kateringkita.ui.navigation

sealed class KateringScreen(val route: String) {
    object Splash : KateringScreen("splash")
    object Login : KateringScreen("login")
    object Main : KateringScreen("main")
    object ProductDetail : KateringScreen("product_detail")
    object Checkout : KateringScreen("checkout")
    object WAGenerator : KateringScreen("wa_generator")
}

enum class MainTab {
    HOME,
    ORDERS,
    AI,
    LIKED,
    PROFILE
}
