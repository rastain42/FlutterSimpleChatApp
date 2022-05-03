# Flutter chat app

## Features

- Sign in - SignUp - logout .
- Real-time send and receive messages using stream and linking with Firebaes Firestore database.
- Nice looking UI and user-friendly animation

## Dependencies used

- [Flutter & Dart](http://flutter.dev)
- [Google Fonts](https://pub.dev/packages/google_fonts)
- [Firebase Core](https://pub.dev/packages/firebase_core)
- [Firebase Auth](https://pub.dev/packages/firebase_auth)
- [Cloud Firestore](https://pub.dev/packages/cloud_firestore)
- [Emoji Picker](https://pub.dev/packages/emoji_picker)

## How to run

- Clone this Repo
- Run ``` flutter packages get ```
```
flutter packages get
```
- Connect the app to your Firebase Project from your [Firebase Console](http://console.firebase.google.com) and add the `google-services.json` in the `/android/app` directory.
- Run ``` flutter run ``` (remember to open simulator or connect physical device, iOS auto run additional command pod install)
```
flutter run --release
```