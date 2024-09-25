Comments App

A Flutter application that demonstrates the use of Firebase Authentication, Firestore, and Remote Config. The app allows users to sign up and log in using email, stores user information in Firestore, and fetches comments from JSONPlaceholder. The app also uses Firebase Remote Config to determine whether to mask the email addresses in the comments based on a boolean flag.
Features

    Email Sign Up & Login: Users can sign up and log in with email and password using Firebase Authentication.
    Firestore Integration: On sign-up, user data is stored in the Firestore users collection.
    Remote Config: The app fetches a boolean flag (maskEmail) from Firebase Remote Config to decide whether to mask the email address when displaying comments.
    Comments Feed: Fetches comments from JSONPlaceholder and displays them in the app. Email addresses are masked or unmasked based on the maskEmail flag.
    State Management: Uses Flutter Riverpod for managing the app's state and Flutter Hooks to simplify the UI logic.

Setup Guide

To run the app locally, you'll need to set up your own Firebase project and configure Firebase Authentication, Firestore, and Remote Config. Here’s how:
Prerequisites

    Flutter SDK installed: Flutter Installation Guide
    Firebase account: Firebase Console

Steps to Set Up Firebase

    Create a Firebase Project
        Go to the Firebase Console.
        Click on "Add Project" and follow the steps to create a new Firebase project.

    Set Up Firebase for Your Flutter App
        Go to the Project Settings in Firebase.
        Under "Your apps", select Add app and choose Android or iOS based on your platform.
        Follow the steps to register your app.
        Download the google-services.json (for Android) or GoogleService-Info.plist (for iOS).
        Place the google-services.json in the android/app folder or GoogleService-Info.plist in the ios/Runner folder.

    Add Firebase SDK to Your Flutter App
        Run the following command to add the Firebase and related dependencies:

        bash

flutter pub add firebase_core firebase_auth cloud_firestore firebase_remote_config flutter_riverpod flutter_hooks

Generate the firebase_options.dart file:

bash

    flutterfire configure

    Place the generated firebase_options.dart file in your project.

Enable Firebase Authentication

    In the Firebase Console, go to the Authentication section.
    Enable Email/Password as a sign-in method.

Set Up Firestore

    In the Firebase Console, go to Firestore Database and create a Firestore database in production or test mode.
    The user data will be stored in the users collection.

Set Up Remote Config

    In the Firebase Console, go to Remote Config.
    Add a new parameter with the following settings:
        Key: maskEmail
        Type: Boolean
        Default value: false (or true, depending on your preference).
    Publish the Remote Config changes.

Run the App

    Clone this repository:

    bash

git clone https://github.com/your-repo/comments-app.git

Replace the missing firebase_options.dart and google-services.json with your own Firebase configuration.
Run the app using the following command:

bash

        flutter run

Firebase Configuration (Not Pushed to Repo)

    google-services.json and firebase_options.dart files are not pushed to this repository.
    To run the app, you need to create your own Firebase project and generate these files by following the setup guide above.

How the App Works

    When a user signs up, their email and display name are stored in the users collection in Firestore.
    The app fetches comments from the JSONPlaceholder API and displays them in a list.
    Email Masking: The email addresses in the comments are either masked or unmasked based on the value of the maskEmail parameter fetched from Firebase Remote Config.
        Example:
            If maskEmail is true, emails will appear like: joh****@test.com.
            If maskEmail is false, emails will appear in full: johndoe@test.com.

Additional Features

    Error handling for Firebase Authentication and API errors.
    State management using Flutter Riverpod and Flutter Hooks for better code separation and logic handling.
    Form validation for sign-up and login screens.

To Do

    Add more error handling and unit tests.
    Implement additional authentication methods (e.g., Google Sign-In).

License

This project is licensed under the MIT License.
