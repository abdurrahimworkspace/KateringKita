package com.kateringkita.kateringkita.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val LightColorScheme = lightColorScheme(
    primary = Primary,
    onPrimary = Color.White,
    primaryContainer = PrimarySoft,
    onPrimaryContainer = Primary,
    secondary = PrimaryLight,
    onSecondary = Color.White,
    secondaryContainer = BlueSoft,
    onSecondaryContainer = BlueTech,
    background = BgMain,
    onBackground = TextTitle,
    surface = CardBg,
    onSurface = TextTitle,
    error = UrgencyRed,
    onError = Color.White,
    outline = BorderSubtle
)

@Composable
fun KateringKitaTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = LightColorScheme,
        typography = AppTypography,
        content = content
    )
}
