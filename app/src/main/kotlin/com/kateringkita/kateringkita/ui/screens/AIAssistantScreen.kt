package com.kateringkita.kateringkita.ui.screens

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
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AutoAwesome
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.kateringkita.kateringkita.theme.BgMain
import com.kateringkita.kateringkita.theme.BlueSoft
import com.kateringkita.kateringkita.theme.BlueTech
import com.kateringkita.kateringkita.theme.BorderSubtle
import com.kateringkita.kateringkita.theme.CardBg
import com.kateringkita.kateringkita.theme.Primary
import com.kateringkita.kateringkita.theme.TextBody
import com.kateringkita.kateringkita.theme.TextMuted
import com.kateringkita.kateringkita.theme.TextTitle

@Composable
fun AIAssistantScreen(
    onSelectRecommendedPackage: (String, Int, Int) -> Unit,
    modifier: Modifier = Modifier
) {
    var attendeeCount by remember { mutableStateOf("25") }
    var budgetPerPerson by remember { mutableStateOf("15000") }
    var eventType by remember { mutableStateOf("Rapat Organisasi") }

    val attendees = attendeeCount.toIntOrNull() ?: 25
    val budget = budgetPerPerson.toIntOrNull() ?: 15000
    val totalBudget = attendees * budget

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(BgMain)
            .verticalScroll(rememberScrollState())
            .padding(24.dp)
            .testTag("ai_assistant_screen")
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .background(BlueSoft, CircleShape),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Default.AutoAwesome,
                    contentDescription = "AI",
                    tint = BlueTech,
                    modifier = Modifier.size(24.dp)
                )
            }
            Spacer(modifier = Modifier.width(12.dp))
            Column {
                Text(
                    text = "Danus AI Planner",
                    fontSize = 20.sp,
                    fontWeight = FontWeight.ExtraBold,
                    color = TextTitle
                )
                Text(
                    text = "Kalkulator Paket Snack & Konsumsi Mahasiswa",
                    fontSize = 12.sp,
                    color = TextMuted
                )
            }
        }

        Spacer(modifier = Modifier.height(24.dp))

        Card(
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = CardBg),
            elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
        ) {
            Column(modifier = Modifier.padding(18.dp)) {
                Text(
                    text = "Parameter Acara",
                    fontWeight = FontWeight.Bold,
                    fontSize = 16.sp,
                    color = TextTitle
                )
                Spacer(modifier = Modifier.height(14.dp))

                Text(
                    text = "Jumlah Peserta (Orang)",
                    fontSize = 13.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = TextBody
                )
                Spacer(modifier = Modifier.height(6.dp))
                OutlinedTextField(
                    value = attendeeCount,
                    onValueChange = { attendeeCount = it },
                    shape = RoundedCornerShape(10.dp),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedContainerColor = CardBg,
                        unfocusedContainerColor = CardBg,
                        focusedBorderColor = BlueTech,
                        unfocusedBorderColor = BorderSubtle
                    ),
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true
                )

                Spacer(modifier = Modifier.height(14.dp))
                Text(
                    text = "Target Budget per Orang (Rp)",
                    fontSize = 13.sp,
                    fontWeight = FontWeight.SemiBold,
                    color = TextBody
                )
                Spacer(modifier = Modifier.height(6.dp))
                OutlinedTextField(
                    value = budgetPerPerson,
                    onValueChange = { budgetPerPerson = it },
                    shape = RoundedCornerShape(10.dp),
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedContainerColor = CardBg,
                        unfocusedContainerColor = CardBg,
                        focusedBorderColor = BlueTech,
                        unfocusedBorderColor = BorderSubtle
                    ),
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true
                )
            }
        }

        Spacer(modifier = Modifier.height(24.dp))

        // AI Recommendation Output Box
        Card(
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = BlueSoft.copy(alpha = 0.5f)),
            elevation = CardDefaults.cardElevation(defaultElevation = 0.dp),
            modifier = Modifier.border(1.dp, BlueTech.copy(alpha = 0.2f), RoundedCornerShape(16.dp))
        ) {
            Column(modifier = Modifier.padding(20.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(
                        imageVector = Icons.Default.AutoAwesome,
                        contentDescription = "AI",
                        tint = BlueTech,
                        modifier = Modifier.size(20.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = "Rekomendasi Paket Paling Pas",
                        fontWeight = FontWeight.Bold,
                        fontSize = 16.sp,
                        color = BlueTech
                    )
                }

                Spacer(modifier = Modifier.height(14.dp))
                Text(
                    text = "Paket Kombinasi Danus Hemat ($attendees Porsi)",
                    fontWeight = FontWeight.Bold,
                    fontSize = 17.sp,
                    color = TextTitle
                )
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = "• 1x Risoles Mayo Premium (gurih)\n• 1x Lumpia Diego Khas\n• 1x Donat Gula Salju\n• Free Box & Tisu",
                    fontSize = 14.sp,
                    lineHeight = 22.sp,
                    color = TextBody
                )

                Spacer(modifier = Modifier.height(16.dp))
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column {
                        Text(text = "Total Estimasi:", fontSize = 12.sp, color = TextMuted)
                        Text(
                            text = "Rp %,d".format(totalBudget).replace(',', '.'),
                            fontWeight = FontWeight.ExtraBold,
                            fontSize = 20.sp,
                            color = Primary
                        )
                    }
                    Button(
                        onClick = {
                            onSelectRecommendedPackage("Paket Danus Rapat ($attendees porsi)", budget, attendees)
                        },
                        shape = RoundedCornerShape(10.dp),
                        colors = ButtonDefaults.buttonColors(containerColor = Primary),
                        modifier = Modifier.testTag("apply_ai_package_button")
                    ) {
                        Text("Pesan Paket Ini", fontWeight = FontWeight.Bold)
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(100.dp))
    }
}
