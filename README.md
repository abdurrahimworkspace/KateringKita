# KateringKita (Kuliner Danus) - Android Application

KateringKita is a modern Android application built with **Kotlin** and **Jetpack Compose** (Material Design 3) designed for campus catering and dana usaha (danus) student orders.

## Features

- **Splash Screen**: Branded splash screen with auto-navigation.
- **Authentication**: Campus student email login and sign-up entry point.
- **Home Feed**:
  - Delivery location switcher (Campus UI Depok)
  - Search bar for quick snack discovery
  - Category filters: *Semua*, *Snack Gurih*, *Manis*, *Paket Hemat*
  - Promotional event banners
  - Interactive snack menu cards with real-time stock urgency indicators (*"Sisa 3"*)
- **Product Detail**:
  - Hero image with smooth layout
  - Portion selection (*Standard* vs *Jumbo*) with dynamic price recalculation
  - Quantity counter stepper
  - Wishlist / favorite bookmarking
- **Checkout & Quota Hold**:
  - Kuota Terkunci (holding timer countdown banner)
  - Customer contact details form (Name, WhatsApp, notes)
  - Automatic subtotal, platform service fee, and total breakdown
- **WhatsApp Order Generator**:
  - WhatsApp speech bubble preview
  - One-click copy message to clipboard
  - Message editing modal
  - Direct WhatsApp launch intent with pre-filled message URL
- **Bottom Navigation Dock**:
  - **Home**: Main storefront
  - **Orders**: Active & completed orders tracking with direct WhatsApp follow-up
  - **Danus AI Planner**: Budget and headcount catering package calculator
  - **Liked**: Wishlist collection
  - **Profile**: Student information, delivery addresses, and account management

## Tech Stack & Architecture

- **Language**: Kotlin 2.0+
- **UI Framework**: Jetpack Compose with Material 3 (M3)
- **Architecture**: MVVM (Model-View-ViewModel) with StateFlow
- **Image Loading**: Coil Compose
- **Design System**: Plus Jakarta Sans typography, custom adaptive launcher icon
