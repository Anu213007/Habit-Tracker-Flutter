# 🌸 Habit Tracker 

A beautiful habit tracking app built with Flutter. Track your daily habits, visualize progress, and stay motivated with inspirational quotes.

## ✨ Features

### 🎨 Beautiful Design
- **Soft, pleasant backgrounds** with warm earthy tones
- **Gentle animations** throughout the interface
- **Clean styling** with rounded corners and subtle shadows
- **Light and Dark mode** support
- **Custom typography** for an elegant look

### 🔐 **User Authentication**
- **Local authentication** with email/password
- **User registration** with comprehensive form validation
- **Session management** using SharedPreferences
- **Profile management** with editable fields

### 📝 **Habit Management**
- **Create, edit, and delete** habits
- **Category-based organization** (Health, Study, Fitness, Productivity, Mental Health, Others)
- **Frequency tracking** (Daily/Weekly)
- **Streak calculation** and progress visualization
- **Notes and start dates** for each habit

### 📊 **Progress Visualization**
- **Interactive charts** showing last 7 days completion
- **Real-time progress tracking** with visual feedback
- **Streak counters** with achievement indicators
- **Completion rate statistics**

### 💭 **Motivational Quotes**
- **Daily inspirational quotes** from public APIs
- **Favorite quotes system** with local storage
- **Copy to clipboard** functionality
- **Pull-to-refresh** for new quotes

### 🌙 **Theme & Customization**
- **Light/Dark mode toggle** with instant theme switching
- **Consistent color palette** throughout the app
- **Responsive design** for various screen sizes
- **Smooth animations** and transitions

## 🚀 Getting Started

### Prerequisites
- Flutter 3.0.0 or higher
- Dart 3.0.0 or higher
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/habit-tracker.git
   cd habit-tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_model.dart      # User data model
│   ├── habit_model.dart     # Habit data model
│   ├── quote_model.dart     # Quote data model
│   └── mood_model.dart      # Mood tracking model
├── providers/                # State management
│   ├── auth_provider.dart   # Authentication state (using SharedPreferences)
│   ├── theme_provider.dart  # Theme management (using SharedPreferences)
│   ├── habit_provider.dart  # Habit operations (using SharedPreferences)
│   └── quote_provider.dart  # Quote management (using SharedPreferences)
├── screens/                  # App screens
│   ├── splash_screen.dart   # Welcome screen
│   ├── login_screen.dart    # User login
│   ├── registration_screen.dart # User registration
│   ├── dashboard_screen.dart    # Main app interface
│   ├── profile_screen.dart      # User profile
│   ├── settings_screen.dart     # App settings
│   ├── habit_form_screen.dart   # Habit creation/editing
│   └── favorites_quotes_screen.dart # Favorite quotes
├── widgets/                  # Reusable components
│   ├── habit_card.dart      # Habit display card
│   ├── quote_card.dart      # Quote display card
│   └── progress_chart.dart  # Progress visualization
└── utils/                    # Utilities
    └── theme.dart           # App theme configuration
```

## 💾 Data Storage

This app uses **SharedPreferences** for local data storage:

- **User authentication** and session management
- **User profile data** and preferences
- **Habit data** with completion history
- **Favorite quotes** and user preferences
- **Theme settings** (light/dark mode)

All data is stored locally on the device, providing fast access and offline functionality.

## 📱 Screenshots

*[Add screenshots of your app here]*

## 🎨 Design System

### Color Palette
- **Primary**: Warm, inviting colors
- **Secondary**: Complementary accent colors
- **Background**: Soft, neutral backgrounds
- **Card**: Clean card designs with subtle shadows
- **Accent**: Gentle highlight colors

### Typography
- Clean, readable fonts throughout the app
- Consistent typography scale for headings and body text

### Animations
- **Fade-in effects** with smooth transitions
- **Gentle animations** on interactive elements
- **Smooth transitions** between screens

## 🔒 Security Features

- **Local authentication** with email/password validation
- **Input validation** on all forms
- **Secure password requirements** (minimum 8 characters with uppercase, lowercase, and numbers)
- **Session management** with automatic logout options

## 📊 Data Models

### User Model
```dart
class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String? gender;
  final String? dateOfBirth;
  final String? height;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool isDarkMode;
}
```

### Habit Model
```dart
class HabitModel {
  final String id;
  final String title;
  final String category;
  final String frequency;
  final DateTime creationDate;
  final int streakCount;
  final List<DateTime> completionHistory;
  final String? notes;
}
```

## 🚀 Deployment

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter team** for the amazing framework
- **Open source community** for the various packages used
- **Public quote APIs** for providing inspirational content

## 📞 Support

If you have any questions or need help:
- Create an issue in this repository
- Check the Flutter documentation

## 🔮 Future Enhancements

- [ ] **Mood tracking** with visual mood charts
- [ ] **Habit reminders** and notifications
- [ ] **Advanced analytics** and insights
- [ ] **Custom themes** and personalization
- [ ] **Data export functionality** for backups
- [ ] **Multi-language support**
- [ ] **Cloud sync** option for cross-device functionality

---

**Note**: This is a local-only application. All data is stored on your device using SharedPreferences. For cloud backup or multi-device sync, consider implementing a backend service in future versions.
