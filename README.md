# Campus Pulse - Campus Event Notification App 📱

<div align="center">
  <img src="assets/images/logo.png" alt="Campus Pulse Logo" width="200"/>
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.16+-blue.svg)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.2+-blue.svg)](https://dart.dev)
  [![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
  
  A beautiful, real-time notification system for campus events built with Flutter.
</div>

## 🌟 Features

### 📨 **Smart Notifications**
- Real-time push notifications for 4 event categories: Seminars, Exams, Fests & Notices
- Customizable notification preferences per category
- Reminder system with customizable alert times

### 🎨 **Beautiful UI/UX**
- Clean Material Design with green & white color scheme
- Light green cards with subtle shadows and rounded corners
- Smooth animations and transitions
- Student-friendly, intuitive interface

### 📅 **Event Management**
- Browse upcoming campus events
- Filter events by category
- Set reminders for important events
- Detailed event view with location and time

### 👤 **User Features**
- Simple onboarding flow
- Customizable notification settings
- Profile management
- Mark notifications as read/unread

## 🚀 Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform UI framework |
| **Dart** | Programming language |
| **Firebase Cloud Messaging** | Push notifications |
| **Firebase Realtime Database** | Cloud data storage |
| **SQLite** | Local data persistence |
| **Provider** | State management |
| **Material Design 3** | UI/UX components |


## 🏗️ Architecture

```
lib/
├── models/         # Data models (Event, Notification, User)
├── providers/      # State management (Provider pattern)
├── services/       # Firebase, Database, Notification services
├── screens/        # UI Screens with bottom navigation
│   ├── onboarding/ # Welcome, Preferences, Permission screens
│   ├── home/       # Main dashboard with event cards
│   ├── events/     # Categorized events list
│   ├── notifications/ # Notification center
│   └── profile/    # User profile & settings
├── widgets/        # Reusable UI components
└── utils/          # Theme, Constants, Helpers
```

## 🚦 Getting Started

### Prerequisites
- Flutter SDK (3.16+)
- Android Studio / VS Code
- Firebase account
- Android device/emulator (API 21+)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/campus-pulse.git
cd campus-pulse
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Set up Firebase**
   - Create a new Firebase project
   - Add Android app with package name `com.example.campus_pulse`
   - Download `google-services.json` and place in `android/app/`
   - Enable Email/Password authentication
   - Set up Realtime Database

4. **Configure Firebase options**
   - Update `lib/firebase_options.dart` with your Firebase configuration

5. **Run the app**
```bash
flutter run
```

## 🎯 Core Functionality

### 📍 Event Categories with Icons
| Category | Icon | Description |
|----------|------|-------------|
| Seminar | 🎤 | Workshops, lectures, academic sessions |
| Exam | 📝 | Tests, midterms, final examinations |
| Fest | 🎉 | Cultural events, celebrations, fests |
| Notice | 📢 | Important announcements, holidays |

### 🔔 Notification Types
- **Instant alerts** for new events
- **Reminders** before events (15min, 30min, 1hr, 1day)
- **Category-based** notification control
- **Read/unread** tracking

## 🛠️ Configuration

### Firebase Cloud Messaging
```dart
// Enable notifications in your app
await NotificationService().initialize();
await NotificationService().requestPermissions();
```

### Database Setup
The app uses both:
- **SQLite** for offline-first local storage
- **Firebase** for real-time sync across devices

## 📱 App Screens

### Main Dashboard
- Welcome banner with personalized greeting
- Upcoming events cards
- Quick actions for event categories
- Bottom navigation for easy access

### Events Screen
- Tab-based category filtering
- Add new events (admin/staff)
- Search and filter functionality
- Event details with location & time

### Notifications Center
- List of all notifications
- Unread indicator
- Mark as read functionality
- Quick navigation to related events

### Profile & Settings
- User information
- Notification preferences
- Reminder time settings
- App preferences

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer

**Your Name**
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/yourprofile)
- GitHub: [@yourusername](https://github.com/yourusername)
- Portfolio: [yourportfolio.com](https://yourportfolio.com)

## 🙏 Acknowledgments

- Flutter team for amazing framework
- Firebase for robust backend services
- Material Design for beautiful UI components
- All contributors and testers

---

<div align="center">
  <sub>Built with ❤️ for students, by students</sub>
  <br/>
  <sub>© 2026 Campus Pulse. All rights reserved.</sub>
</div>
```



