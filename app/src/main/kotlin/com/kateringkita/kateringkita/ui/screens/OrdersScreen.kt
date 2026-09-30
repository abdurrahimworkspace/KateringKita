package com.kateringkita.kateringkita.ui.screens

import android.content.Intent
import android.net.Uri
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.HourglassTop
import androidx.compose.material.icons.filled.Receipt
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Tab
import androidx.compose.material3.TabRow
import androidx.compose.material3.TabRowDefaults
import androidx.compose.material3.TabRowDefaults.tabIndicatorOffset
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.kateringkita.kateringkita.model.OrderItem
import com.kateringkita.kateringkita.model.OrderStatus
import com.kateringkita.kateringkita.theme.BgMain
import com.kateringkita.kateringkita.theme.BorderSubtle
import com.kateringkita.kateringkita.theme.CardBg
import com.kateringkita.kateringkita.theme.Primary
import com.kateringkita.kateringkita.theme.PrimarySoft
import com.kateringkita.kateringkita.theme.TextBody
import com.kateringkita.kateringkita.theme.TextMuted
import com.kateringkita.kateringkita.theme.TextTitle
import com.kateringkita.kateringkita.theme.WaGreen

@Composable
fun OrdersScreen(
    orders: List<OrderItem>,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    var selectedTabIndex by remember { mutableStateOf(0) }
    val tabs = listOf("Pesanan Aktif", "Riwayat Selesai")

    val filteredOrders = if (selectedTabIndex == 0) {
        orders.filter { it.status == OrderStatus.ACTIVE }
    } else {
        orders.filter { it.status == OrderStatus.COMPLETED }
    }

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(BgMain)
            .padding(top = 16.dp)
            .testTag("orders_screen")
    ) {
        Text(
            text = "Daftar Pesanan",
            fontSize = 22.sp,
            fontWeight = FontWeight.ExtraBold,
            color = TextTitle,
            modifier = Modifier.padding(horizontal = 24.dp, vertical = 8.dp)
        )

        TabRow(
            selectedTabIndex = selectedTabIndex,
            containerColor = BgMain,
            contentColor = Primary,
            indicator = { tabPositions ->
                TabRowDefaults.SecondaryIndicator(
                    modifier = Modifier.tabIndicatorOffset(tabPositions[selectedTabIndex]),
                    color = Primary
                )
            },
            modifier = Modifier.padding(horizontal = 16.dp)
        ) {
            tabs.forEachIndexed { index, title ->
                Tab(
                    selected = selectedTabIndex == index,
                    onClick = { selectedTabIndex = index },
                    text = {
                        Text(
                            text = title,
                            fontWeight = if (selectedTabIndex == index) FontWeight.Bold else FontWeight.Medium,
                            fontSize = 14.sp
                        )
                    },
                    modifier = Modifier.testTag("order_tab_$index")
                )
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        if (filteredOrders.isEmpty()) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(32.dp),
                contentAlignment = Alignment.Center
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Icon(
                        imageVector = Icons.Default.Receipt,
                        contentDescription = "Empty",
                        tint = TextMuted,
                        modifier = Modifier.size(64.dp)
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                    Text(
                        text = "Belum ada pesanan pada tab ini",
                        color = TextMuted,
                        fontSize = 15.sp
                    )
                }
            }
        } else {
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(horizontal = 24.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                items(filteredOrders, key = { it.id }) { order ->
                    OrderCard(order = order, onContactWA = {
                        val uri = Uri.parse("https://wa.me/6281234567890?text=Halo%20Admin%20Danus,%20saya%20mau%20tanya%20status%20pesanan%20${order.id}")
                        context.startActivity(Intent(Intent.ACTION_VIEW, uri))
                    })
                }
                item {
                    Spacer(modifier = Modifier.height(100.dp))
                }
            }
        }
    }
}

@Composable
private fun OrderCard(
    order: OrderItem,
    onContactWA: () -> Unit
) {
    Card(
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = CardBg),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp),
        modifier = Modifier
            .fillMaxWidth()
            .testTag("order_card_${order.id}")
    ) {
        Column(modifier = Modifier.padding(18.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = order.id,
                    fontWeight = FontWeight.Bold,
                    fontSize = 14.sp,
                    color = TextMuted
                )
                Box(
                    modifier = Modifier
                        .background(
                            if (order.status == OrderStatus.ACTIVE) PrimarySoft else Color(0xFFE8F5E9),
                            RoundedCornerShape(8.dp)
                        )
                        .padding(horizontal = 10.dp, vertical = 4.dp)
                ) {
                    Text(
                        text = if (order.status == OrderStatus.ACTIVE) "Diproses" else "Selesai",
                        color = if (order.status == OrderStatus.ACTIVE) Primary else WaGreen,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }

            Spacer(modifier = Modifier.height(12.dp))
            Text(
                text = "${order.title} (${order.portion})",
                fontWeight = FontWeight.Bold,
                fontSize = 16.sp,
                color = TextTitle
            )
            Spacer(modifier = Modifier.height(4.dp))
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(
                    text = "Jumlah: ${order.quantity} porsi",
                    fontSize = 14.sp,
                    color = TextBody
                )
                Text(
                    text = order.formattedTotal,
                    fontWeight = FontWeight.ExtraBold,
                    fontSize = 15.sp,
                    color = Primary
                )
            }

            if (order.notes.isNotBlank()) {
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = "Catatan: ${order.notes}",
                    fontSize = 12.sp,
                    color = TextMuted
                )
            }

            Spacer(modifier = Modifier.height(14.dp))
            if (order.status == OrderStatus.ACTIVE) {
                Button(
                    onClick = onContactWA,
                    shape = RoundedCornerShape(10.dp),
                    colors = ButtonDefaults.buttonColors(containerColor = WaGreen),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text("Hubungi Admin Danus via WA", fontWeight = FontWeight.Bold)
                }
            } else {
                OutlinedButton(
                    onClick = onContactWA,
                    shape = RoundedCornerShape(10.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text("Pesan Lagi", color = Primary, fontWeight = FontWeight.Bold)
                }
            }
        }
    }
}
