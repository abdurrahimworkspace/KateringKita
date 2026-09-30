package com.kateringkita.kateringkita.model

data class OrderItem(
    val id: String,
    val title: String,
    val portion: String = "Standard",
    val price: Int,
    val quantity: Int,
    val customerName: String,
    val customerPhone: String,
    val notes: String = "",
    val timestamp: Long = System.currentTimeMillis(),
    val status: OrderStatus = OrderStatus.ACTIVE
) {
    val subtotal: Int
        get() = price * quantity

    val serviceFee: Int = 2000

    val total: Int
        get() = subtotal + serviceFee

    val formattedTotal: String
        get() = "Rp %,d".format(total).replace(',', '.')
}

enum class OrderStatus {
    ACTIVE,
    COMPLETED
}
