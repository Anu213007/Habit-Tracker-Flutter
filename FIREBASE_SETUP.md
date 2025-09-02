# Firebase Setup Guide for Habit Tracker

## Prerequisites
- Flutter project created ✅
- Firebase project (you'll create this)

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: **"Habit Tracker"**
4. Follow the setup wizard
5. You can disable Google Analytics if you don't need it

## Step 2: Enable Authentication

1. In your Firebase project, go to **"Authentication"** in the left sidebar
2. Click **"Get started"**
3. Go to **"Sign-in method"** tab
4. Enable **"Email/Password"** provider
5. Click **"Save"**

## Step 3: Create Firestore Database

1. Go to **"Firestore Database"** in the left sidebar
2. Click **"Create database"**
3. Choose **"Start in test mode"** (for development)
4. Select a location close to you
5. Click **"Done"**

## Step 4: Get Firebase Configuration

1. Click the gear icon (⚙️) next to **"Project Overview"**
2. Select **"Project settings"**
3. Scroll down to **"Your apps"** section
4. Click the **Flutter icon (</>)** to add a Flutter app
5. Enter app nickname: **"Habit Tracker"**
6. Click **"Register app"**
7. **Download** the `google-services.json` file (for Android)

## Step 5: Configure Android

1. Place the downloaded `google-services.json` file in:
   ```
   android/app/google-services.json
   ```

2. The Android configuration files are already updated with:
   - Google Services plugin in `android/app/build.gradle.kts`
   - Google Services classpath in `android/build.gradle.kts`

## Step 6: Update Firebase Options

1. Open `lib/firebase_options.dart`
2. Replace all placeholder values with your actual Firebase configuration:

   **For Android:**
   ```dart
   static const FirebaseOptions android = FirebaseOptions(
     apiKey: 'your-actual-android-api-key',
     appId: 'your-actual-android-app-id',
     messagingSenderId: 'your-actual-sender-id',
     projectId: 'your-actual-project-id',
     storageBucket: 'your-actual-project-id.appspot.com',
   );
   ```

   **For iOS:**
   ```dart
   static const FirebaseOptions ios = FirebaseOptions(
     apiKey: 'your-actual-ios-api-key',
     appId: 'your-actual-ios-app-id',
     messagingSenderId: 'your-actual-sender-id',
     projectId: 'your-actual-project-id',
     storageBucket: 'your-actual-project-id.appspot.com',
     iosBundleId: 'com.example.habitTracker',
   );
   ```

## Step 7: Set Firestore Security Rules

1. Go to **"Firestore Database"** → **"Rules"** tab
2. Replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Users can only access their own habits
    match /habits/{habitId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Users can only access their own moods
    match /moods/{moodId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Users can only access their own favorite quotes
    match /favoriteQuotes/{quoteId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
  }
}
```

## Step 8: Test the Setup

1. Run the app:
   ```bash
   flutter run
   ```

2. The app should start without Firebase errors
3. Try to register a new user
4. Check if data is being stored in Firestore

## Troubleshooting

### Common Issues:

1. **"DefaultFirebaseOptions not configured"**
   - Make sure you've updated `firebase_options.dart` with your actual values

2. **"google-services.json not found"**
   - Ensure the file is placed in `android/app/google-services.json`

3. **Authentication errors**
   - Verify Email/Password is enabled in Firebase Console
   - Check if your app is properly registered

4. **Firestore permission denied**
   - Verify your security rules are correct
   - Make sure you're testing with an authenticated user

## Next Steps

After successful Firebase setup:
1. Test user registration and login
2. Test habit creation and tracking
3. Test mood tracking
4. Test quote favorites

## Support

If you encounter issues:
1. Check Firebase Console for error logs
2. Verify all configuration files are correct
3. Ensure all dependencies are properly installed
4. Check Flutter and Dart versions compatibility
