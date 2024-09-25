# Comments App

A Flutter application that demonstrates the use of Firebase Authentication, Firestore, and Remote Config. The app allows users to sign up and log in using email, stores user information in Firestore, and fetches comments from JSONPlaceholder. The app also uses Firebase Remote Config to determine whether to mask the email addresses in the comments based on a boolean flag.

## Features

- **Email Sign Up & Login**: Users can sign up and log in with email and password using Firebase Authentication.
- **Firestore Integration**: On sign-up, user data is stored in the Firestore users collection.
- **Remote Config**: The app fetches a boolean flag (`maskEmail`) from Firebase Remote Config to decide whether to mask the email address when displaying comments.
- **Comments Feed**: Fetches comments from JSONPlaceholder and displays them in the app. Email addresses are masked or unmasked based on the `maskEmail` flag.
- **State Management**: Uses Flutter Riverpod for managing the app's state and Flutter Hooks to simplify the UI logic.

## Screenshots

[Add your screenshots here]

## Setup Guide

To run the app locally, you'll need to set up your own Firebase project and configure Firebase Authentication, Firestore, and Remote Config. Here’s how:

### Prerequisites

- Flutter SDK installed: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- Firebase account: [Firebase Console](https://console.firebase.google.com/)

### Steps to Set Up Firebase

1. **Create a Firebase Project**
   - Go to the [Firebase Console](https://console.firebase.google.com/).
   - Click on "Add Project" and follow the steps to create a new Firebase project.

2. **Set Up Firebase for Your Flutter App**
   - Go to the Project Settings in Firebase.
   - Under "Your apps", select "Add app" and choose Android or iOS based on your platform.
   - Follow the steps to register your app.
   - Download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS).
   - Place the `google-services.json` in the `android/app` folder or `GoogleService-Info.plist` in the `ios/Runner` folder.

3. **Add Firebase SDK to Your Flutter App**
   - Run the following command to add the Firebase and related dependencies:

   ```bash
   flutter pub add firebase_core firebase_auth cloud_firestore firebase_remote_config flutter_riverpod flutter_hooks
