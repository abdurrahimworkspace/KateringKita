package com.kateringkita.kateringkita.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AutoAwesome
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.ReceiptLong
import androidx.compose.material.icons.outlined.FavoriteBorder
import androidx.compose.material.icons.outlined.Person
import androidx.compose.material.icons.outlined.ReceiptLong
import androidx.compose.material3.Icon
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.unit.dp
import com.kateringkita.kateringkita.theme.BlueSoft
import com.kateringkita.kateringkita.theme.BlueTech
import com.kateringkita.kateringkita.theme.CardBg
import com.kateringkita.kateringkita.theme.Primary
import com.kateringkita.kateringkita.theme.TextMuted
import com.kateringkita.kateringkita.ui.navigation.MainTab

@Composable
fun BottomNavBar(
    selectedTab: MainTab,
    onTabSelected: (MainTab) -> Unit,
    modifier: Modifier = Modifier
) {
    Surface(
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = 24.dp, vertical = 16.dp)
            .shadow(elevation = 16.dp, shape = RoundedCornerShape(30.dp)),
        shape = RoundedCornerShape(30.dp),
        color = CardBg
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 10.dp, horizontal = 16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Home Tab
            Box(
                modifier = Modifier
                    .clip(CircleShape)
                    .clickable { onTabSelected(MainTab.HOME) }
                    .padding(8.dp)
                    .testTag("nav_tab_home"),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Default.Home,
                    contentDescription = "Home",
                    tint = if (selectedTab == MainTab.HOME) Primary else TextMuted,
                    modifier = Modifier.size(26.dp)
                )
            }

            // Orders Tab
            Box(
                modifier = Modifier
                    .clip(CircleShape)
                    .clickable { onTabSelected(MainTab.ORDERS) }
                    .padding(8.dp)
                    .testTag("nav_tab_orders"),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = if (selectedTab == MainTab.ORDERS) Icons.Filled.ReceiptLong else Icons.Outlined.ReceiptLong,
                    contentDescription = "Orders",
                    tint = if (selectedTab == MainTab.ORDERS) Primary else TextMuted,
                    modifier = Modifier.size(26.dp)
                )
            }

            // AI Tab (Center Star Accent)
            Box(
                modifier = Modifier
                    .size(44.dp)
                    .background(BlueSoft, shape = CircleShape)
                    .clip(CircleShape)
                    .clickable { onTabSelected(MainTab.AI) }
                    .testTag("nav_tab_ai"),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Default.AutoAwesome,
                    contentDescription = "Danus AI",
                    tint = BlueTech,
                    modifier = Modifier.size(24.dp)
                )
            }

            // Liked Tab
            Box(
                modifier = Modifier
                    .clip(CircleShape)
                    .clickable { onTabSelected(MainTab.LIKED) }
                    .padding(8.dp)
                    .testTag("nav_tab_liked"),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = if (selectedTab == MainTab.LIKED) Icons.Filled.Favorite else Icons.Outlined.FavoriteBorder,
                    contentDescription = "Liked",
                    tint = if (selectedTab == MainTab.LIKED) Primary else TextMuted,
                    modifier = Modifier.size(26.dp)
                )
            }

            // Profile Tab
            Box(
                modifier = Modifier
                    .clip(CircleShape)
                    .clickable { onTabSelected(MainTab.PROFILE) }
                    .padding(8.dp)
                    .testTag("nav_tab_profile"),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = if (selectedTab == MainTab.PROFILE) Icons.Filled.Person else Icons.Outlined.Person,
                    contentDescription = "Profile",
                    tint = if (selectedTab == MainTab.PROFILE) Primary else TextMuted,
                    modifier = Modifier.size(26.dp)
                )
            }
        }
    }
}
