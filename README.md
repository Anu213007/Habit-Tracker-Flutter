# Habit Tracker App 📱

A beautiful and feature-rich Flutter application for tracking daily habits, managing productivity goals, and staying motivated through inspirational quotes. Built with modern Flutter architecture and local data persistence.

## ✨ Features

### 🔐 User Authentication
- **User Registration & Login**: Secure email/password authentication
- **Remember Me**: Persistent login sessions using SharedPreferences
- **Profile Management**: View and edit user profile information
- **Data Validation**: Comprehensive form validation with user feedback

### 📊 Habit Management
- **Create & Edit Habits**: Add habits with title, category, frequency, and notes
- **Category System**: Predefined categories (Health, Study, Fitness, Productivity, Mental Health, Others)
- **Frequency Tracking**: Daily and weekly habit tracking
- **Progress Visualization**: Track completion streaks and progress over time
- **Smart Completion**: Mark habits as complete with date validation

### 💬 Motivational Quotes
- **Daily Inspiration**: Fetch fresh quotes from external API
- **Offline Support**: Fallback quotes when internet is unavailable
- **Favorites System**: Save and manage favorite quotes locally
- **Copy & Share**: Easy quote sharing functionality

### 🎨 User Experience
- **Responsive Design**: Optimized for all screen sizes
- **Theme Support**: Light and dark mode with smooth transitions
- **Pull-to-Refresh**: Refresh data on all screens
- **Offline Banner**: Visual indicator when working offline
- **Smooth Animations**: Beautiful UI transitions and micro-interactions

### 🔧 Technical Features
- **Local Data Storage**: SharedPreferences for fast, reliable data persistence
- **State Management**: Provider pattern for efficient app state management
- **Offline First**: App works seamlessly without internet connection
- **Error Handling**: Graceful error handling with user-friendly messages
- **Performance Optimized**: Efficient data loading and caching

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- Android Emulator or Physical Device

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Anu213007/habit-tracker.git
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
│   ├── habit_model.dart     # Habit data structure
│   ├── mood_model.dart      # Mood tracking model
│   ├── quote_model.dart     # Quote data model
│   └── user_model.dart      # User profile model
├── providers/                # State management
│   ├── auth_provider.dart   # Authentication state
│   ├── habit_provider.dart  # Habit management
│   ├── quote_provider.dart  # Quote management
│   ├── theme_provider.dart  # Theme state
│   └── connectivity_provider.dart # Network status
├── screens/                  # UI screens
│   ├── splash_screen.dart   # App launch screen
│   ├── login_screen.dart    # User login
│   ├── registration_screen.dart # User registration
│   ├── dashboard_screen.dart # Main app interface
│   └── habit_form_screen.dart # Habit creation/editing
├── widgets/                  # Reusable components
│   ├── offline_banner.dart  # Offline status indicator
│   └── custom_widgets.dart  # Other custom widgets
└── utils/                    # Utilities
    ├── theme.dart           # App theme configuration
    └── constants.dart       # App constants
```

## 🛠️ Dependencies

### Core Dependencies
- **flutter**: UI framework
- **provider**: State management
- **shared_preferences**: Local data storage
- **http**: API communication
- **connectivity_plus**: Network status monitoring
- **flutter_animate**: Smooth animations

### Development Dependencies
- **flutter_lints**: Code quality
- **flutter_test**: Testing framework



## 🔧 Configuration

### API Configuration
The app fetches quotes from the Quotable API. No API key is required as it's a free public API.

### Local Storage
All user data is stored locally using SharedPreferences:
- User authentication tokens
- Habit data and progress
- Favorite quotes
- Theme preferences
- User profile information

## 🚀 Deployment

### Android
1. Update `android/app/build.gradle.kts` version information
2. Run `flutter build apk --release`
3. Test the APK on target devices

### iOS
1. Update iOS version in `ios/Runner/Info.plist`
2. Run `flutter build ios --release`
3. Archive and distribute through App Store Connect

## 🧪 Testing

Run the test suite:
```bash
flutter test
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


## 🔮 Future Enhancements

- [ ] Cloud sync capabilities
- [ ] Social features and sharing
- [ ] Advanced analytics and insights
- [ ] Custom habit templates
- [ ] Integration with health apps
- [ ] Multi-language support


