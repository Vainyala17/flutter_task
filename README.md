
# 📱 Flutter User Management App

## 🔍 Overview
A Flutter-based user management application built as part of an assessment for the Flutter Developer role. It demonstrates API integration, BLoC state management, clean architecture, and modern UI design.

---

## 🚀 Features

- Fetch users from [DummyJSON API](https://dummyjson.com/users)
- Paginated user list with infinite scroll
- Real-time search by user name
- User detail screen with:
    - Posts from `https://dummyjson.com/posts/user/{userId}`
    - Todos from `https://dummyjson.com/todos/user/{userId}`
- Create post screen (adds post locally)
- Loading indicators & error handling
- Follows BLoC pattern with clean architecture

---

## 📁 Folder Structure

```
lib/
├── blocs/
│   ├── user/          # UserList BLoC
│   ├── post/          # Posts BLoC
│   └── todo/          # Todos BLoC
├── models/            # Data models (User, Post, Todo)
├── repositories/      # API service layer
|      ├── api_service
├── screens/
│   ├── user_list/
│   ├── user_detail/
│   └── create_post/
|── utils/
|    ├── constants
├── widgets/           # Custom reusable widgets
└── main.dart
```

---

## 🧠 Architecture

This project uses the **BLoC pattern** (`flutter_bloc` package) to handle state management.  
Each major data unit (Users, Posts, Todos) has its own BLoC, Events, and States:

- **UserListBloc** handles:
    - Initial fetch
    - Pagination
    - Search

- **PostBloc / TodoBloc** handle:
    - Loading data for a selected user
    - Display states (loading/success/error)

The project separates **business logic** from **UI**, ensuring maintainability and scalability.

---

## ⚙️ Getting Started

### ✅ Prerequisites:
- Flutter 3.x
- Dart SDK
- Android Studio or VS Code

### 🛠️ Setup Instructions:

```bash
git clone https://github.com/yourusername/flutter-user-management-app.git
cd flutter-user-management-app
flutter pub get
flutter run
```

Replace `yourusername` with your actual GitHub username.

---

## 🌙 Bonus Features (If Implemented)

- [ ] Pull-to-refresh
- [ ] Offline caching with Hive/SharedPreferences
- [ ] Light/Dark theme switching

---

## 🧪 API Reference

- Users: `https://dummyjson.com/users`
- Posts by User: `https://dummyjson.com/posts/user/{userId}`
- Todos by User: `https://dummyjson.com/todos/user/{userId}`

Refer to the [DummyJSON Docs](https://dummyjson.com/docs) for more.

---

## 🤝 Contributions

This project was developed by **Vainyala Samal** as part of the Flutter Developer Assessment Task (Deadline: 4th June 2025).

---


---## 📸 Demo Video

👉 [Watch the demo video on Google Drive](https://drive.google.com/file/d/1NbETL08x192JYnDC-BV5DjruPYVX88pj/view?usp=drive_link)
