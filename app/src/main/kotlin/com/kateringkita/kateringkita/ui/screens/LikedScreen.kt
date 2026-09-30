package com.kateringkita.kateringkita.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.GridItemSpan
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.kateringkita.kateringkita.model.FoodItem
import com.kateringkita.kateringkita.theme.BgMain
import com.kateringkita.kateringkita.theme.TextMuted
import com.kateringkita.kateringkita.theme.TextTitle
import com.kateringkita.kateringkita.ui.components.FoodCard

@Composable
fun LikedScreen(
    foods: List<FoodItem>,
    likedIds: Set<String>,
    onFoodClick: (FoodItem) -> Unit,
    modifier: Modifier = Modifier
) {
    val likedFoods = foods.filter { likedIds.contains(it.id) }

    if (likedFoods.isEmpty()) {
        Box(
            modifier = modifier
                .fillMaxSize()
                .background(BgMain)
                .padding(32.dp)
                .testTag("liked_screen"),
            contentAlignment = Alignment.Center
        ) {
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Icon(
                    imageVector = Icons.Default.Favorite,
                    contentDescription = "Liked",
                    tint = TextMuted,
                    modifier = Modifier.size(64.dp)
                )
                Spacer(modifier = Modifier.height(16.dp))
                Text(
                    text = "Belum ada snack yang disukai",
                    color = TextMuted,
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Medium
                )
            }
        }
    } else {
        LazyVerticalGrid(
            columns = GridCells.Fixed(2),
            modifier = modifier
                .fillMaxSize()
                .background(BgMain)
                .testTag("liked_screen"),
            contentPadding = PaddingValues(start = 20.dp, end = 20.dp, top = 20.dp, bottom = 100.dp),
            horizontalArrangement = Arrangement.spacedBy(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            item(span = { GridItemSpan(2) }) {
                Text(
                    text = "Snack Favorit Saya",
                    fontSize = 22.sp,
                    fontWeight = FontWeight.ExtraBold,
                    color = TextTitle
                )
            }

            items(likedFoods, key = { it.id }) { food ->
                FoodCard(
                    food = food,
                    onClick = { onFoodClick(food) }
                )
            }
        }
    }
}
