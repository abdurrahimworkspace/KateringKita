package com.kateringkita.kateringkita.ui.screens

import androidx.activity.compose.BackHandler
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.LocalFireDepartment
import androidx.compose.material.icons.filled.Remove
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.outlined.FavoriteBorder
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.AsyncImage
import coil.request.ImageRequest
import com.kateringkita.kateringkita.model.FoodItem
import com.kateringkita.kateringkita.theme.BorderSubtle
import com.kateringkita.kateringkita.theme.CardBg
import com.kateringkita.kateringkita.theme.Primary
import com.kateringkita.kateringkita.theme.PrimarySoft
import com.kateringkita.kateringkita.theme.TextBody
import com.kateringkita.kateringkita.theme.TextTitle
import com.kateringkita.kateringkita.theme.UrgencyAmber

@Composable
fun ProductDetailScreen(
    food: FoodItem,
    selectedPortion: String,
    onPortionSelected: (String) -> Unit,
    quantity: Int,
    onIncrementQuantity: () -> Unit,
    onDecrementQuantity: () -> Unit,
    isLiked: Boolean,
    onToggleLike: () -> Unit,
    onBack: () -> Unit,
    onAddToOrder: () -> Unit
) {
    BackHandler { onBack() }

    val context = LocalContext.current
    val drawableResId = context.resources.getIdentifier(food.image, "drawable", context.packageName)

    val priceMultiplier = if (selectedPortion == "Jumbo") 1.3 else 1.0
    val displayPrice = (food.price * priceMultiplier).toInt()
    val formattedPrice = "Rp %,d".format(displayPrice).replace(',', '.')

    Box(
        modifier = Modifier
            .fillMaxSize()
            .testTag("product_detail_screen")
    ) {
        // Hero Image (top 45%)
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .fillMaxHeight(0.45f)
        ) {
            if (drawableResId != 0) {
                AsyncImage(
                    model = ImageRequest.Builder(context)
                        .data(drawableResId)
                        .crossfade(true)
                        .build(),
                    contentDescription = food.title,
                    contentScale = ContentScale.Crop,
                    modifier = Modifier.fillMaxSize()
                )
            } else {
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .background(PrimarySoft)
                )
            }

            // Top Buttons: Back & Favorite
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp, vertical = 40.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .size(44.dp)
                        .background(Color.White, CircleShape)
                        .clickable(onClick = onBack)
                        .testTag("back_button"),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                        contentDescription = "Kembali",
                        tint = TextTitle,
                        modifier = Modifier.size(20.dp)
                    )
                }

                Box(
                    modifier = Modifier
                        .size(44.dp)
                        .background(Color.White, CircleShape)
                        .clickable(onClick = onToggleLike)
                        .testTag("favorite_button"),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = if (isLiked) Icons.Filled.Favorite else Icons.Outlined.FavoriteBorder,
                        contentDescription = "Suka",
                        tint = if (isLiked) Primary else TextTitle,
                        modifier = Modifier.size(20.dp)
                    )
                }
            }
        }

        // Bottom Sheet Container (60% height)
        Surface(
            modifier = Modifier
                .fillMaxWidth()
                .fillMaxHeight(0.60f)
                .align(Alignment.BottomCenter),
            shape = RoundedCornerShape(topStart = 32.dp, topEnd = 32.dp),
            color = CardBg
        ) {
            Column(
                modifier = Modifier.fillMaxSize()
            ) {
                // Drag Handle
                Box(
                    modifier = Modifier
                        .padding(top = 12.dp)
                        .size(width = 48.dp, height = 4.dp)
                        .background(BorderSubtle, RoundedCornerShape(2.dp))
                        .align(Alignment.CenterHorizontally)
                )

                // Scrollable Content
                Column(
                    modifier = Modifier
                        .weight(1f)
                        .verticalScroll(rememberScrollState())
                        .padding(24.dp)
                ) {
                    // Stock Urgency Badge
                    Row(
                        modifier = Modifier
                            .background(PrimarySoft, RoundedCornerShape(16.dp))
                            .padding(horizontal = 12.dp, vertical = 6.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Default.LocalFireDepartment,
                            contentDescription = "Popular",
                            tint = Primary,
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Text(
                            text = "Sisa ${food.stock} Porsi Lagi!",
                            color = Primary,
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }

                    Spacer(modifier = Modifier.height(16.dp))
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.Top
                    ) {
                        Text(
                            text = food.title,
                            fontSize = 24.sp,
                            fontWeight = FontWeight.ExtraBold,
                            color = TextTitle,
                            modifier = Modifier.weight(1f)
                        )
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(
                                imageVector = Icons.Default.Star,
                                contentDescription = "Rating",
                                tint = Color(0xFFFFB800),
                                modifier = Modifier.size(20.dp)
                            )
                            Spacer(modifier = Modifier.width(4.dp))
                            Text(
                                text = "${food.rating}",
                                fontWeight = FontWeight.Bold,
                                fontSize = 18.sp,
                                color = TextTitle
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = formattedPrice,
                        fontSize = 22.sp,
                        fontWeight = FontWeight.ExtraBold,
                        color = Primary
                    )

                    Spacer(modifier = Modifier.height(24.dp))
                    Text(
                        text = "Pilihan Porsi",
                        fontSize = 17.sp,
                        fontWeight = FontWeight.Bold,
                        color = TextTitle
                    )
                    Spacer(modifier = Modifier.height(12.dp))
                    Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                        PortionChip(
                            label = "Standard",
                            isSelected = selectedPortion == "Standard",
                            onClick = { onPortionSelected("Standard") },
                            testTag = "portion_standard"
                        )
                        PortionChip(
                            label = "Jumbo",
                            isSelected = selectedPortion == "Jumbo",
                            onClick = { onPortionSelected("Jumbo") },
                            testTag = "portion_jumbo"
                        )
                    }

                    Spacer(modifier = Modifier.height(24.dp))
                    Text(
                        text = "Deskripsi",
                        fontSize = 17.sp,
                        fontWeight = FontWeight.Bold,
                        color = TextTitle
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = food.description,
                        fontSize = 14.sp,
                        lineHeight = 22.sp,
                        color = TextBody
                    )
                }

                // Sticky Bottom Bar
                Surface(
                    modifier = Modifier
                        .fillMaxWidth()
                        .shadow(12.dp),
                    color = CardBg
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(20.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        // Quantity Stepper
                        Row(
                            modifier = Modifier
                                .border(1.dp, BorderSubtle, RoundedCornerShape(12.dp))
                                .padding(horizontal = 4.dp, vertical = 2.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            IconButton(
                                onClick = onDecrementQuantity,
                                modifier = Modifier
                                    .size(36.dp)
                                    .testTag("quantity_decrease")
                            ) {
                                Icon(
                                    imageVector = Icons.Default.Remove,
                                    contentDescription = "Kurang",
                                    tint = Primary,
                                    modifier = Modifier.size(18.dp)
                                )
                            }
                            Text(
                                text = "$quantity",
                                fontWeight = FontWeight.Bold,
                                fontSize = 16.sp,
                                color = TextTitle,
                                modifier = Modifier.padding(horizontal = 8.dp)
                            )
                            IconButton(
                                onClick = onIncrementQuantity,
                                modifier = Modifier
                                    .size(36.dp)
                                    .testTag("quantity_increase")
                            ) {
                                Icon(
                                    imageVector = Icons.Default.Add,
                                    contentDescription = "Tambah",
                                    tint = Primary,
                                    modifier = Modifier.size(18.dp)
                                )
                            }
                        }

                        Spacer(modifier = Modifier.width(16.dp))
                        Button(
                            onClick = onAddToOrder,
                            shape = RoundedCornerShape(12.dp),
                            colors = ButtonDefaults.buttonColors(containerColor = Primary),
                            modifier = Modifier
                                .weight(1f)
                                .height(50.dp)
                                .testTag("add_to_orders_button")
                        ) {
                            Text(
                                text = "Add to Orders",
                                fontWeight = FontWeight.Bold,
                                fontSize = 16.sp,
                                color = Color.White
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun PortionChip(
    label: String,
    isSelected: Boolean,
    onClick: () -> Unit,
    testTag: String
) {
    Box(
        modifier = Modifier
            .background(
                color = if (isSelected) PrimarySoft else Color.Transparent,
                shape = RoundedCornerShape(20.dp)
            )
            .border(
                width = 1.dp,
                color = if (isSelected) Primary else BorderSubtle,
                shape = RoundedCornerShape(20.dp)
            )
            .clickable(onClick = onClick)
            .padding(horizontal = 20.dp, vertical = 8.dp)
            .testTag(testTag)
    ) {
        Text(
            text = label,
            color = if (isSelected) Primary else TextBody,
            fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
            fontSize = 14.sp
        )
    }
}
