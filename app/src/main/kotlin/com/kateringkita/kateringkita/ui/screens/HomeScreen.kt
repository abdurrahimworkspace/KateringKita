package com.kateringkita.kateringkita.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.GridItemSpan
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.Icon
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
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
import com.kateringkita.kateringkita.theme.BgMain
import com.kateringkita.kateringkita.theme.BorderSubtle
import com.kateringkita.kateringkita.theme.CardBg
import com.kateringkita.kateringkita.theme.Primary
import com.kateringkita.kateringkita.theme.PrimarySoft
import com.kateringkita.kateringkita.theme.TextBody
import com.kateringkita.kateringkita.theme.TextMuted
import com.kateringkita.kateringkita.theme.TextTitle
import com.kateringkita.kateringkita.theme.UrgencyRed
import com.kateringkita.kateringkita.ui.components.FoodCard

@Composable
fun HomeScreen(
    foods: List<FoodItem>,
    searchQuery: String,
    onSearchQueryChanged: (String) -> Unit,
    selectedCategory: String,
    onCategorySelected: (String) -> Unit,
    onFoodClick: (FoodItem) -> Unit,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val avatarResId = context.resources.getIdentifier("avatar_user", "drawable", context.packageName)
    val bannerResId = context.resources.getIdentifier("banner_sale", "drawable", context.packageName)

    val categories = listOf("Semua", "Snack Gurih", "Manis", "Paket Hemat")

    val filteredFoods = foods.filter { food ->
        val matchesCategory = selectedCategory == "Semua" || food.category == selectedCategory
        val matchesQuery = food.title.contains(searchQuery, ignoreCase = true) ||
                food.description.contains(searchQuery, ignoreCase = true)
        matchesCategory && matchesQuery
    }

    LazyVerticalGrid(
        columns = GridCells.Fixed(2),
        modifier = modifier
            .fillMaxSize()
            .background(BgMain)
            .testTag("home_screen"),
        contentPadding = PaddingValues(start = 20.dp, end = 20.dp, top = 16.dp, bottom = 100.dp),
        horizontalArrangement = Arrangement.spacedBy(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Header
        item(span = { GridItemSpan(2) }) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column {
                    Text(
                        text = "Lokasi Pengiriman",
                        fontSize = 11.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = TextMuted
                    )
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text(
                            text = "Kampus UI Depok",
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold,
                            color = TextTitle
                        )
                        Spacer(modifier = Modifier.width(4.dp))
                        Icon(
                            imageVector = Icons.Default.KeyboardArrowDown,
                            contentDescription = "Pilih Lokasi",
                            tint = Primary,
                            modifier = Modifier.size(20.dp)
                        )
                    }
                }

                Box(
                    modifier = Modifier.testTag("user_avatar")
                ) {
                    if (avatarResId != 0) {
                        AsyncImage(
                            model = ImageRequest.Builder(context)
                                .data(avatarResId)
                                .crossfade(true)
                                .build(),
                            contentDescription = "Avatar Pengguna",
                            contentScale = ContentScale.Crop,
                            modifier = Modifier
                                .size(48.dp)
                                .clip(CircleShape)
                        )
                    } else {
                        Box(
                            modifier = Modifier
                                .size(48.dp)
                                .background(PrimarySoft, CircleShape),
                            contentAlignment = Alignment.Center
                        ) {
                            Text("AP", fontWeight = FontWeight.Bold, color = Primary)
                        }
                    }

                    // Notification red dot badge
                    Box(
                        modifier = Modifier
                            .size(12.dp)
                            .background(UrgencyRed, CircleShape)
                            .align(Alignment.TopEnd)
                    )
                }
            }
        }

        // Search Bar
        item(span = { GridItemSpan(2) }) {
            OutlinedTextField(
                value = searchQuery,
                onValueChange = onSearchQueryChanged,
                placeholder = {
                    Text("Cari snack rapat...", color = TextMuted, fontSize = 14.sp)
                },
                leadingIcon = {
                    Icon(
                        imageVector = Icons.Default.Search,
                        contentDescription = "Cari",
                        tint = TextMuted
                    )
                },
                shape = RoundedCornerShape(16.dp),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedContainerColor = CardBg,
                    unfocusedContainerColor = CardBg,
                    focusedBorderColor = Primary,
                    unfocusedBorderColor = BorderSubtle
                ),
                modifier = Modifier
                    .fillMaxWidth()
                    .testTag("search_bar"),
                singleLine = true
            )
        }

        // Category Chips
        item(span = { GridItemSpan(2) }) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .horizontalScroll(rememberScrollState()),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                categories.forEach { category ->
                    val isSelected = category == selectedCategory
                    Box(
                        modifier = Modifier
                            .background(
                                color = if (isSelected) Primary else CardBg,
                                shape = RoundedCornerShape(24.dp)
                            )
                            .border(
                                width = 1.dp,
                                color = if (isSelected) Primary else BorderSubtle,
                                shape = RoundedCornerShape(24.dp)
                            )
                            .clickable { onCategorySelected(category) }
                            .padding(horizontal = 20.dp, vertical = 10.dp)
                            .testTag("category_chip_$category")
                    ) {
                        Text(
                            text = category,
                            color = if (isSelected) Color.White else TextBody,
                            fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
                            fontSize = 14.sp
                        )
                    }
                }
            }
        }

        // Promo Banner
        item(span = { GridItemSpan(2) }) {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(160.dp)
                    .clip(RoundedCornerShape(20.dp))
                    .testTag("banner_image")
            ) {
                if (bannerResId != 0) {
                    AsyncImage(
                        model = ImageRequest.Builder(context)
                            .data(bannerResId)
                            .crossfade(true)
                            .build(),
                        contentDescription = "Promo Banner",
                        contentScale = ContentScale.Crop,
                        modifier = Modifier.fillMaxSize()
                    )
                } else {
                    Box(
                        modifier = Modifier
                            .fillMaxSize()
                            .background(PrimarySoft),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = "Promo Spesial Rapat Danus!",
                            color = Primary,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }
            }
        }

        // Section Title
        item(span = { GridItemSpan(2) }) {
            Text(
                text = "Rekomendasi Hari Ini",
                fontSize = 20.sp,
                fontWeight = FontWeight.ExtraBold,
                color = TextTitle,
                modifier = Modifier.padding(top = 8.dp)
            )
        }

        // Food Items Grid
        items(filteredFoods, key = { it.id }) { food ->
            FoodCard(
                food = food,
                onClick = { onFoodClick(food) }
            )
        }
    }
}
