package com.kateringkita.kateringkita.model

data class FoodItem(
    val id: String,
    val title: String,
    val image: String,
    val price: Int, // numeric price e.g. 15000
    val stock: Int,
    val category: String,
    val rating: Double = 4.9,
    val description: String = "Snack lezat dan gurih, sangat cocok untuk menemani rapat atau belajar kelompok. Dibuat dengan bahan premium dan higienis.",
    val isLiked: Boolean = false
) {
    val formattedPrice: String
        get() = "Rp %,d".format(price).replace(',', '.')
}
