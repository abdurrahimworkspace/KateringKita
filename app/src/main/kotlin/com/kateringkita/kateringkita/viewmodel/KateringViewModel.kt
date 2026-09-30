package com.kateringkita.kateringkita.viewmodel

import androidx.lifecycle.ViewModel
import com.kateringkita.kateringkita.model.FoodItem
import com.kateringkita.kateringkita.model.OrderItem
import com.kateringkita.kateringkita.model.OrderStatus
import com.kateringkita.kateringkita.ui.navigation.KateringScreen
import com.kateringkita.kateringkita.ui.navigation.MainTab
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update

data class KateringUiState(
    val currentScreen: KateringScreen = KateringScreen.Splash,
    val selectedTab: MainTab = MainTab.HOME,
    val foods: List<FoodItem> = defaultFoodItems,
    val searchQuery: String = "",
    val selectedCategory: String = "Semua",
    val selectedFood: FoodItem? = null,
    val selectedPortion: String = "Standard",
    val quantity: Int = 1,
    val customerName: String = "Ahmad Pratama",
    val customerPhone: String = "081234567890",
    val customerNotes: String = "Mohon diantar ke Ruang B.204 Gedung Baru",
    val generatedOrderText: String = "",
    val orders: List<OrderItem> = defaultOrders,
    val likedFoodIds: Set<String> = setOf("1", "3")
)

private val defaultFoodItems = listOf(
    FoodItem(
        id = "1",
        title = "Lumpia Diego",
        image = "lumpia",
        price = 15000,
        stock = 3,
        category = "Snack Gurih",
        rating = 4.9,
        description = "Lumpia goreng isi rebung dan ayam segar racikan khas Diego. Kulit luar super renyah dengan saus manis gurih khas yang menggugah selera."
    ),
    FoodItem(
        id = "2",
        title = "Martabak Mini",
        image = "martabak",
        price = 12000,
        stock = 8,
        category = "Manis",
        rating = 4.8,
        description = "Martabak manis ukuran personal dengan taburan cokelat meises lumer, keju parut cheddar melimpah, dan susu kental manis legit."
    ),
    FoodItem(
        id = "3",
        title = "Nasi Kuning Bento",
        image = "nasi_kuning",
        price = 22000,
        stock = 2,
        category = "Paket Hemat",
        rating = 5.0,
        description = "Nasi kuning harum rempah alami disajikan lengkap dengan ayam suwir pedas manis, telur balado, orek tempe renyah, dan sambal terasi."
    ),
    FoodItem(
        id = "4",
        title = "Risoles Mayo",
        image = "risoles",
        price = 10000,
        stock = 15,
        category = "Snack Gurih",
        rating = 4.9,
        description = "Risoles lembut berbalut tepung roti emas, berisi telur rebus, smoked beef gurih, dan saus mayones creamy lumer di mulut."
    ),
    FoodItem(
        id = "5",
        title = "Donat Gula Salju",
        image = "donat",
        price = 8000,
        stock = 5,
        category = "Manis",
        rating = 4.7,
        description = "Donat kentang tradisional lembut dan empuk mengembang sempurna, dibalut taburan gula halus dingin khas kudapan kampus."
    ),
    FoodItem(
        id = "6",
        title = "Paket Rapat Hemat",
        image = "banner_sale",
        price = 35000,
        stock = 10,
        category = "Paket Hemat",
        rating = 4.9,
        description = "Kombinasi 3 macam snack (Risoles, Lumpia, Donat) plus air mineral dingin. Pilihan tepat untuk rapat himpunan atau seminar mahasiswa."
    )
)

private val defaultOrders = listOf(
    OrderItem(
        id = "ORD-001",
        title = "Lumpia Diego",
        portion = "Standard",
        price = 15000,
        quantity = 2,
        customerName = "Ahmad Pratama",
        customerPhone = "081234567890",
        notes = "Tolong sambalnya dipisah",
        status = OrderStatus.ACTIVE
    ),
    OrderItem(
        id = "ORD-002",
        title = "Risoles Mayo",
        portion = "Standard",
        price = 10000,
        quantity = 4,
        customerName = "Ahmad Pratama",
        customerPhone = "081234567890",
        notes = "Untuk rapat harian panitia",
        status = OrderStatus.COMPLETED
    )
)

class KateringViewModel : ViewModel() {
    private val _uiState = MutableStateFlow(KateringUiState())
    val uiState: StateFlow<KateringUiState> = _uiState.asStateFlow()

    fun navigateTo(screen: KateringScreen) {
        _uiState.update { it.copy(currentScreen = screen) }
    }

    fun selectTab(tab: MainTab) {
        _uiState.update { it.copy(selectedTab = tab) }
    }

    fun onSearchQueryChanged(query: String) {
        _uiState.update { it.copy(searchQuery = query) }
    }

    fun selectCategory(category: String) {
        _uiState.update { it.copy(selectedCategory = category) }
    }

    fun selectFood(food: FoodItem) {
        _uiState.update {
            it.copy(
                selectedFood = food,
                selectedPortion = "Standard",
                quantity = 1,
                currentScreen = KateringScreen.ProductDetail
            )
        }
    }

    fun setPortion(portion: String) {
        _uiState.update { it.copy(selectedPortion = portion) }
    }

    fun incrementQuantity() {
        _uiState.update { it.copy(quantity = it.quantity + 1) }
    }

    fun decrementQuantity() {
        _uiState.update {
            if (it.quantity > 1) it.copy(quantity = it.quantity - 1) else it
        }
    }

    fun updateCustomerDetails(name: String, phone: String, notes: String) {
        _uiState.update {
            it.copy(
                customerName = name,
                customerPhone = phone,
                customerNotes = notes
            )
        }
    }

    fun toggleLike(foodId: String) {
        _uiState.update { current ->
            val updated = current.likedFoodIds.toMutableSet()
            if (updated.contains(foodId)) {
                updated.remove(foodId)
            } else {
                updated.add(foodId)
            }
            current.copy(likedFoodIds = updated)
        }
    }

    fun confirmOrder() {
        val food = _uiState.value.selectedFood ?: defaultFoodItems.first()
        val quantity = _uiState.value.quantity
        val portion = _uiState.value.selectedPortion
        val priceMultiplier = if (portion == "Jumbo") 1.3 else 1.0
        val finalPrice = (food.price * priceMultiplier).toInt()
        val subtotal = finalPrice * quantity
        val total = subtotal + 2000

        val waText = buildString {
            append("Halo Kuliner Danus, saya mau pesan:\n")
            append("- ${food.title} ($portion) x$quantity porsi\n")
            append("- Subtotal: Rp %,d\n".format(subtotal).replace(',', '.'))
            append("- Biaya Layanan: Rp 2.000\n")
            append("- Total Pembayaran: Rp %,d\n".format(total).replace(',', '.'))
            append("\nDetail Pemesan:\n")
            append("Nama: ${_uiState.value.customerName}\n")
            append("No WA: ${_uiState.value.customerPhone}\n")
            if (_uiState.value.customerNotes.isNotBlank()) {
                append("Catatan: ${_uiState.value.customerNotes}\n")
            }
            append("\nMohon konfirmasi ketersediaan dan nomor rekening/QRIS. Terima kasih!")
        }

        val newOrder = OrderItem(
            id = "ORD-${System.currentTimeMillis() % 10000}",
            title = food.title,
            portion = portion,
            price = finalPrice,
            quantity = quantity,
            customerName = _uiState.value.customerName,
            customerPhone = _uiState.value.customerPhone,
            notes = _uiState.value.customerNotes,
            status = OrderStatus.ACTIVE
        )

        _uiState.update {
            it.copy(
                generatedOrderText = waText,
                orders = listOf(newOrder) + it.orders,
                currentScreen = KateringScreen.WAGenerator
            )
        }
    }

    fun updateGeneratedOrderText(newText: String) {
        _uiState.update { it.copy(generatedOrderText = newText) }
    }
}
