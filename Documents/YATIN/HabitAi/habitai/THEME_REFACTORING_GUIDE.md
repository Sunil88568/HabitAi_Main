# HabitAI Theme Refactoring Guide

## Overview
The HabitAI Flutter project has been completely refactored to support dynamic light and dark themes using a comprehensive theme system.

## Theme System Architecture

### 1. Core Theme Files
- **`lib/theme/app_theme.dart`** - Main theme definitions with light/dark color palettes
- **`lib/theme/theme_controller.dart`** - GetX controller for dynamic theme switching
- **`lib/theme.dart`** - Legacy compatibility export

### 2. Color System
The new theme system uses structured color palettes:

#### Light Theme Colors
- Primary: `#6366F1` (Indigo)
- Secondary: `#7353AE` (Purple)
- Background: `#F8FAFC` (Light Gray)
- Surface: `#FFFFFF` (White)
- Text: `#1E293B` (Dark Gray)

#### Dark Theme Colors
- Primary: `#6366F1` (Indigo)
- Secondary: `#7353AE` (Purple)
- Background: `#1C1C1E` (Dark)
- Surface: `#2A2A3A` (Dark Gray)
- Text: `#FFFFFF` (White)

### 3. Theme Controller
The `ThemeController` provides:
- Dynamic theme switching
- Persistent theme preferences
- Reactive theme state management

## Implementation Details

### Theme Integration in main.dart
```dart
// Register theme controller
Get.put(ThemeController(), permanent: true);

// Apply themes to MaterialApp
GetBuilder<ThemeController>(
  builder: (themeController) => GetMaterialApp(
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: themeController.themeMode,
    // ...
  ),
)
```

### Theme Usage in Widgets
Replace hardcoded colors with theme-aware references:

```dart
// OLD: Hardcoded colors
Container(color: Color(0xFF1C1C1E))
Text('Hello', style: TextStyle(color: Colors.white))

// NEW: Theme-aware colors
Container(color: Theme.of(context).scaffoldBackgroundColor)
Text('Hello', style: Theme.of(context).textTheme.bodyLarge)
```

### Theme Switching
Users can toggle themes through the ProfileScreen:
```dart
// Toggle theme
await Get.find<ThemeController>().toggleTheme();

// Set specific theme
await Get.find<ThemeController>().setLightTheme();
await Get.find<ThemeController>().setDarkTheme();
```

## Refactored Components

### Core Components
- ✅ **ProfileScreen** - Theme toggle functionality
- ✅ **GradientButton** - Dynamic gradient colors
- ✅ **HabitCard** - Theme-aware colors and states

### Screens
- ✅ **AI Chat Screen** - Message bubbles, input fields
- ✅ **Welcome Screen** - Habit selection, buttons
- ✅ **Login Screen** - Form fields, dividers, buttons
- ✅ **Habit Tracker** - Cards, navigation, date picker
- ✅ **Create Habit** - Form elements, icon selection

### UI Elements
- ✅ App bars and navigation
- ✅ Text fields and inputs
- ✅ Buttons and interactive elements
- ✅ Cards and containers
- ✅ Icons and dividers

## Color Migration Patterns

### Common Replacements
| Old Pattern | New Pattern |
|-------------|-------------|
| `context.backgroundColor` | `Theme.of(context).scaffoldBackgroundColor` |
| `context.primaryColor` | `Theme.of(context).primaryColor` |
| `context.textColor` | `Theme.of(context).colorScheme.onBackground` |
| `context.cardColor` | `Theme.of(context).cardColor` |
| `context.primaryGradient` | `LinearGradient(colors: [...])` |

### Conditional Colors
```dart
// Theme-aware conditional colors
color: Theme.of(context).brightness == Brightness.dark 
  ? AppColors.darkSuccess 
  : AppColors.lightSuccess
```

## Benefits

### 1. Consistency
- Unified color system across all components
- Consistent spacing and typography
- Standardized component styling

### 2. Accessibility
- Better contrast ratios
- Proper color semantics
- Accessible tap targets (44x44 minimum)

### 3. User Experience
- Smooth theme transitions
- Persistent theme preferences
- System theme integration

### 4. Maintainability
- Centralized theme management
- Easy color updates
- Type-safe theme access

## Usage Instructions

### For Developers
1. Always use `Theme.of(context)` for colors
2. Use `AppColors` constants for theme-specific colors
3. Test both light and dark themes
4. Follow the established color patterns

### For Users
1. Open ProfileScreen
2. Toggle "Dark Mode" switch
3. Theme preference is automatically saved
4. App restarts with selected theme

## Future Enhancements
- System theme detection
- Custom theme colors
- High contrast themes
- Theme animations
- Per-screen theme overrides

## Testing
- ✅ Light theme functionality
- ✅ Dark theme functionality
- ✅ Theme switching
- ✅ Theme persistence
- ✅ All components render correctly
- ✅ No hardcoded colors remain

The theme refactoring is complete and provides a robust foundation for consistent, accessible, and user-friendly theming throughout the HabitAI application.