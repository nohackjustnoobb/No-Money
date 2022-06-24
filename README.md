# No Money

A web application for recording income and expenditure.

## Build

You need flutter installed already. If you dont, please follow this link: [Flutter Installation](https://flutter.dev/docs/get-started/install)

### Install dependencies

```bash
git clone https://github.com/nohackjustnoobb/No-Money.git
```

```bash
cd No-Money && flutter pub get
```

### Build for different platform

<i>Although it can build for different platforms, only the web version will be maintenance.</i>

#### Web

```bash
flutter build web --web-renderer canvaskit
```

#### iOS

<i>macOS and Xcode is required.</br></i>
You may need to open the file `ios/Runner.xcworkspace` to sign it.

```bash
flutter build ios
```

#### Android

<i>Android Studio and its SDK is required.</i>

```bash
flutter build apk
```
