package com.kateringkita.kateringkita

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.BackHandler
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import com.kateringkita.kateringkita.model.FoodItem
import com.kateringkita.kateringkita.theme.BgMain
import com.kateringkita.kateringkita.theme.KateringKitaTheme
import com.kateringkita.kateringkita.ui.components.BottomNavBar
import com.kateringkita.kateringkita.ui.navigation.KateringScreen
import com.kateringkita.kateringkita.ui.navigation.MainTab
import com.kateringkita.kateringkita.ui.screens.AIAssistantScreen
import com.kateringkita.kateringkita.ui.screens.CheckoutScreen
import com.kateringkita.kateringkita.ui.screens.HomeScreen
import com.kateringkita.kateringkita.ui.screens.LikedScreen
import com.kateringkita.kateringkita.ui.screens.LoginScreen
import com.kateringkita.kateringkita.ui.screens.OrdersScreen
import com.kateringkita.kateringkita.ui.screens.ProductDetailScreen
import com.kateringkita.kateringkita.ui.screens.ProfileScreen
import com.kateringkita.kateringkita.ui.screens.SplashScreen
import com.kateringkita.kateringkita.ui.screens.WAGeneratorScreen
import com.kateringkita.kateringkita.viewmodel.KateringViewModel

class MainActivity : ComponentActivity() {
    private val viewModel: KateringViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            KateringKitaTheme {
                KateringKitaApp(viewModel = viewModel)
            }
        }
    }
}

@Composable
fun KateringKitaApp(viewModel: KateringViewModel) {
    val uiState by viewModel.uiState.collectAsState()

    Box(
        modifier = Modifier
            .fillMaxSize()
            .windowInsetsPadding(WindowInsets.safeDrawing)
    ) {
        when (val screen = uiState.currentScreen) {
            is KateringScreen.Splash -> {
                SplashScreen(
                    onTimeout = {
                        viewModel.navigateTo(KateringScreen.Login)
                    }
                )
            }

            is KateringScreen.Login -> {
                LoginScreen(
                    onLoginSuccess = {
                        viewModel.navigateTo(KateringScreen.Main)
                    }
                )
            }

            is KateringScreen.Main -> {
                Scaffold(
                    bottomBar = {
                        BottomNavBar(
                            selectedTab = uiState.selectedTab,
                            onTabSelected = { viewModel.selectTab(it) }
                        )
                    },
                    containerColor = BgMain
                ) { paddingValues ->
                    Box(modifier = Modifier.fillMaxSize()) {
                        when (uiState.selectedTab) {
                            MainTab.HOME -> {
                                HomeScreen(
                                    foods = uiState.foods,
                                    searchQuery = uiState.searchQuery,
                                    onSearchQueryChanged = { viewModel.onSearchQueryChanged(it) },
                                    selectedCategory = uiState.selectedCategory,
                                    onCategorySelected = { viewModel.selectCategory(it) },
                                    onFoodClick = { viewModel.selectFood(it) }
                                )
                            }

                            MainTab.ORDERS -> {
                                OrdersScreen(orders = uiState.orders)
                            }

                            MainTab.AI -> {
                                AIAssistantScreen(
                                    onSelectRecommendedPackage = { title, price, count ->
                                        val customFood = FoodItem(
                                            id = "custom-${System.currentTimeMillis() % 1000}",
                                            title = title,
                                            image = "banner_sale",
                                            price = price,
                                            stock = 50,
                                            category = "Paket Hemat",
                                            description = "Paket kombinasi konsumsi pesanan via Danus AI Planner ($count porsi)."
                                        )
                                        viewModel.selectFood(customFood)
                                    }
                                )
                            }

                            MainTab.LIKED -> {
                                LikedScreen(
                                    foods = uiState.foods,
                                    likedIds = uiState.likedFoodIds,
                                    onFoodClick = { viewModel.selectFood(it) }
                                )
                            }

                            MainTab.PROFILE -> {
                                ProfileScreen(
                                    customerName = uiState.customerName,
                                    customerPhone = uiState.customerPhone,
                                    onLogout = {
                                        viewModel.navigateTo(KateringScreen.Login)
                                    }
                                )
                            }
                        }
                    }
                }
            }

            is KateringScreen.ProductDetail -> {
                val food = uiState.selectedFood ?: uiState.foods.first()
                ProductDetailScreen(
                    food = food,
                    selectedPortion = uiState.selectedPortion,
                    onPortionSelected = { viewModel.setPortion(it) },
                    quantity = uiState.quantity,
                    onIncrementQuantity = { viewModel.incrementQuantity() },
                    onDecrementQuantity = { viewModel.decrementQuantity() },
                    isLiked = uiState.likedFoodIds.contains(food.id),
                    onToggleLike = { viewModel.toggleLike(food.id) },
                    onBack = { viewModel.navigateTo(KateringScreen.Main) },
                    onAddToOrder = { viewModel.navigateTo(KateringScreen.Checkout) }
                )
            }

            is KateringScreen.Checkout -> {
                val food = uiState.selectedFood ?: uiState.foods.first()
                CheckoutScreen(
                    food = food,
                    portion = uiState.selectedPortion,
                    quantity = uiState.quantity,
                    customerName = uiState.customerName,
                    customerPhone = uiState.customerPhone,
                    customerNotes = uiState.customerNotes,
                    onCustomerDetailsChanged = { name, phone, notes ->
                        viewModel.updateCustomerDetails(name, phone, notes)
                    },
                    onBack = { viewModel.navigateTo(KateringScreen.ProductDetail) },
                    onConfirmOrder = { viewModel.confirmOrder() }
                )
            }

            is KateringScreen.WAGenerator -> {
                WAGeneratorScreen(
                    orderText = uiState.generatedOrderText,
                    onOrderTextChanged = { viewModel.updateGeneratedOrderText(it) },
                    onClose = {
                        viewModel.navigateTo(KateringScreen.Main)
                        viewModel.selectTab(MainTab.ORDERS)
                    }
                )
            }
        }
    }
}
