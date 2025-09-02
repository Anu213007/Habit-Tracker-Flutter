# 🌸 Habit Tracker - Studio Ghibli Inspired

A magical habit tracking app built with Flutter, featuring a Studio Ghibli-inspired aesthetic with soft, vintage journal styling. Track your daily habits, visualize progress, and stay motivated with inspirational quotes.

## ✨ Features

### 🎨 **Studio Ghibli Aesthetic**
- **Soft, parchment-like backgrounds** with warm earthy tones
- **Gentle animations** including floating stars and leaves
- **Vintage journal styling** with rounded corners and subtle shadows
- **Light and Dark mode** support
- **Custom typography** using Sawarabi Mincho and Quicksand fonts

### 🔐 **User Authentication**
- **Firebase Authentication** with email/password
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
- **Streak counters** with fire emoji indicators
- **Completion rate statistics**

### 💭 **Motivational Quotes**
- **Daily inspirational quotes** from public APIs
- **Favorite quotes system** with Firestore storage
- **Copy to clipboard** functionality
- **Pull-to-refresh** for new quotes

### 🌙 **Theme & Customization**
- **Light/Dark mode toggle** with instant theme switching
- **Consistent Studio Ghibli color palette** throughout the app
- **Responsive design** for various screen sizes
- **Smooth animations** and transitions

## 🚀 Getting Started

### Prerequisites
- Flutter 3.0.0 or higher
- Dart 3.0.0 or higher
- Firebase project setup
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

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password)
   - Enable Firestore Database
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate platform folders

4. **Configure Firebase Options**
   - Run `flutterfire configure` to generate Firebase configuration
   - Or manually update `lib/firebase_options.dart` with your Firebase project details

5. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   ├── user_model.dart      # User data model
│   ├── habit_model.dart     # Habit data model
│   ├── quote_model.dart     # Quote data model
│   └── mood_model.dart      # Mood tracking model
├── providers/                # State management
│   ├── auth_provider.dart   # Authentication state
│   ├── theme_provider.dart  # Theme management
│   ├── habit_provider.dart  # Habit operations
│   └── quote_provider.dart  # Quote management
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

## 🔧 Configuration

### Firebase Setup
1. **Authentication Rules** (Firestore)
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
         
         match /habits/{habitId} {
           allow read, write: if request.auth != null && request.auth.uid == userId;
         }
         
         match /favorites/quotes/{quoteId} {
           allow read, write: if request.auth != null && request.auth.uid == userId;
         }
         
         match /moods/{moodId} {
           allow read, write: if request.auth != null && request.auth.uid == userId;
         }
       }
     }
   }
   ```

2. **Authentication Methods**
   - Enable Email/Password authentication in Firebase Console
   - Configure password requirements (minimum 8 characters, uppercase, lowercase, number)

### Environment Variables
Create a `.env` file in the root directory:
```env
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
```

## 📱 Screenshots

*[Add screenshots of your app here]*

## 🎨 Design System

### Color Palette
- **Primary**: `#8D6E63` (Warm Brown)
- **Secondary**: `#A5D6A7` (Sage Green)
- **Background**: `#FFF5E1` (Parchment)
- **Card**: `#FFFDF5` (Soft White)
- **Accent**: `#FFE082` (Soft Yellow)

### Typography
- **Headings**: Sawarabi Mincho (Japanese serif)
- **Body**: Quicksand (Modern sans-serif)

### Animations
- **Fade-in effects** with staggered delays
- **Floating elements** (stars, leaves)
- **Smooth transitions** between screens
- **Gentle hover effects** on interactive elements

## 🔒 Security Features

- **Firebase Authentication** with secure user management
- **Firestore security rules** for data protection
- **Input validation** on all forms
- **Secure password requirements**
- **Session management** with automatic logout

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
  final String userId;
  final String title;
  final HabitCategory category;
  final HabitFrequency frequency;
  final DateTime? startDate;
  final String? notes;
  final DateTime createdAt;
  final int currentStreak;
  final List<DateTime> completionHistory;
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

- **Studio Ghibli** for the magical aesthetic inspiration
- **Flutter team** for the amazing framework
- **Firebase** for the backend services
- **Open source community** for the various packages used

## 📞 Support

If you have any questions or need help:
- Create an issue in this repository
- Contact the development team
- Check the Firebase documentation

## 🔮 Future Enhancements

- [ ] **Mood tracking** with visual mood charts
- [ ] **Habit reminders** and notifications
- [ ] **Social features** for sharing progress
- [ ] **Advanced analytics** and insights
- [ ] **Custom themes** and personalization
- [ ] **Offline support** with local caching
- [ ] **Export functionality** for data backup
- [ ] **Multi-language support**

