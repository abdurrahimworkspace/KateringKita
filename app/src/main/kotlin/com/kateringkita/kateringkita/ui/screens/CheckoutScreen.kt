package com.kateringkita.kateringkita.ui.screens

import androidx.activity.compose.BackHandler
import androidx.compose.foundation.background
import androidx.compose.foundation.border
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
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Timer
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.kateringkita.kateringkita.model.FoodItem
import com.kateringkita.kateringkita.theme.BgMain
import com.kateringkita.kateringkita.theme.BorderSubtle
import com.kateringkita.kateringkita.theme.CardBg
import com.kateringkita.kateringkita.theme.Primary
import com.kateringkita.kateringkita.theme.PrimarySoft
import com.kateringkita.kateringkita.theme.TextBody
import com.kateringkita.kateringkita.theme.TextTitle
import com.kateringkita.kateringkita.theme.UrgencyAmber

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CheckoutScreen(
    food: FoodItem,
    portion: String,
    quantity: Int,
    customerName: String,
    customerPhone: String,
    customerNotes: String,
    onCustomerDetailsChanged: (String, String, String) -> Unit,
    onBack: () -> Unit,
    onConfirmOrder: () -> Unit
) {
    BackHandler { onBack() }

    val priceMultiplier = if (portion == "Jumbo") 1.3 else 1.0
    val singlePrice = (food.price * priceMultiplier).toInt()
    val subtotal = singlePrice * quantity
    val fee = 2000
    val total = subtotal + fee

    val formattedSinglePrice = "Rp %,d".format(singlePrice).replace(',', '.')
    val formattedSubtotal = "Rp %,d".format(subtotal).replace(',', '.')
    val formattedFee = "Rp %,d".format(fee).replace(',', '.')
    val formattedTotal = "Rp %,d".format(total).replace(',', '.')

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = "Checkout",
                        fontWeight = FontWeight.Bold,
                        fontSize = 18.sp,
                        color = TextTitle
                    )
                },
                navigationIcon = {
                    IconButton(
                        onClick = onBack,
                        modifier = Modifier.testTag("checkout_back_button")
                    ) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Kembali",
                            tint = TextTitle
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = BgMain)
            )
        },
        containerColor = BgMain
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .verticalScroll(rememberScrollState())
                .padding(24.dp)
                .testTag("checkout_screen")
        ) {
            // Holding Timer Banner
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(PrimarySoft, RoundedCornerShape(12.dp))
                    .padding(vertical = 12.dp, horizontal = 16.dp),
                contentAlignment = Alignment.Center
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(
                        imageVector = Icons.Default.Timer,
                        contentDescription = "Timer",
                        tint = UrgencyAmber,
                        modifier = Modifier.size(20.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = "KUOTA TERKUNCI 04:59",
                        color = UrgencyAmber,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }

            Spacer(modifier = Modifier.height(24.dp))
            Text(
                text = "Ringkasan Pesanan",
                fontSize = 18.sp,
                fontWeight = FontWeight.Bold,
                color = TextTitle
            )
            Spacer(modifier = Modifier.height(12.dp))

            // Order Summary Card
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(CardBg, RoundedCornerShape(16.dp))
                    .border(1.dp, BorderSubtle, RoundedCornerShape(16.dp))
                    .padding(16.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column {
                        Text(
                            text = "${food.title} ($portion)",
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Bold,
                            color = TextTitle
                        )
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(
                            text = formattedSinglePrice,
                            fontSize = 14.sp,
                            color = TextBody
                        )
                    }
                    Text(
                        text = "x$quantity",
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold,
                        color = TextTitle
                    )
                }
            }

            Spacer(modifier = Modifier.height(24.dp))
            Text(
                text = "Detail Pemesan",
                fontSize = 18.sp,
                fontWeight = FontWeight.Bold,
                color = TextTitle
            )
            Spacer(modifier = Modifier.height(12.dp))

            OutlinedTextField(
                value = customerName,
                onValueChange = {
                    onCustomerDetailsChanged(it, customerPhone, customerNotes)
                },
                label = { Text("Nama Lengkap") },
                shape = RoundedCornerShape(12.dp),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedContainerColor = CardBg,
                    unfocusedContainerColor = CardBg,
                    focusedBorderColor = Primary,
                    unfocusedBorderColor = BorderSubtle
                ),
                modifier = Modifier
                    .fillMaxWidth()
                    .testTag("customer_name_input"),
                singleLine = true
            )

            Spacer(modifier = Modifier.height(12.dp))
            OutlinedTextField(
                value = customerPhone,
                onValueChange = {
                    onCustomerDetailsChanged(customerName, it, customerNotes)
                },
                label = { Text("No WhatsApp") },
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone),
                shape = RoundedCornerShape(12.dp),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedContainerColor = CardBg,
                    unfocusedContainerColor = CardBg,
                    focusedBorderColor = Primary,
                    unfocusedBorderColor = BorderSubtle
                ),
                modifier = Modifier
                    .fillMaxWidth()
                    .testTag("customer_phone_input"),
                singleLine = true
            )

            Spacer(modifier = Modifier.height(12.dp))
            OutlinedTextField(
                value = customerNotes,
                onValueChange = {
                    onCustomerDetailsChanged(customerName, customerPhone, it)
                },
                label = { Text("Catatan (Opsional)") },
                shape = RoundedCornerShape(12.dp),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedContainerColor = CardBg,
                    unfocusedContainerColor = CardBg,
                    focusedBorderColor = Primary,
                    unfocusedBorderColor = BorderSubtle
                ),
                modifier = Modifier
                    .fillMaxWidth()
                    .testTag("customer_notes_input"),
                maxLines = 3
            )

            Spacer(modifier = Modifier.height(24.dp))
            Text(
                text = "Rincian Pembayaran",
                fontSize = 18.sp,
                fontWeight = FontWeight.Bold,
                color = TextTitle
            )
            Spacer(modifier = Modifier.height(12.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(text = "Subtotal", fontSize = 14.sp, color = TextBody)
                Text(
                    text = formattedSubtotal,
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Bold,
                    color = TextTitle
                )
            }
            Spacer(modifier = Modifier.height(8.dp))
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(text = "Biaya Layanan", fontSize = 14.sp, color = TextBody)
                Text(
                    text = formattedFee,
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Bold,
                    color = TextTitle
                )
            }

            Spacer(modifier = Modifier.height(16.dp))
            HorizontalDivider(color = BorderSubtle, thickness = 1.dp)
            Spacer(modifier = Modifier.height(16.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Total",
                    fontSize = 18.sp,
                    fontWeight = FontWeight.Bold,
                    color = TextTitle
                )
                Text(
                    text = formattedTotal,
                    fontSize = 20.sp,
                    fontWeight = FontWeight.ExtraBold,
                    color = Primary
                )
            }

            Spacer(modifier = Modifier.height(36.dp))
            Button(
                onClick = onConfirmOrder,
                shape = RoundedCornerShape(12.dp),
                colors = ButtonDefaults.buttonColors(containerColor = Primary),
                modifier = Modifier
                    .fillMaxWidth()
                    .height(52.dp)
                    .testTag("confirm_order_button")
            ) {
                Text(
                    text = "Konfirmasi Pesanan",
                    fontWeight = FontWeight.Bold,
                    fontSize = 16.sp,
                    color = Color.White
                )
            }
        }
    }
}
