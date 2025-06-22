# 📊 Report Manager

An iOS app built with SwiftUI to help users:

- Securely sign in using Google (Firebase)
- View PDF reports in-app
- Work with live data from an API
- Save and manage data offline (Core Data)
- Select and view images (camera/gallery)
- Receive notifications on item deletion

---

## 🧩 Problem Statement

A company needs a simple iOS app that allows users to:

- Sign in with Google
- View PDF files directly
- Select images from device/camera
- Fetch and display data from a REST API
- Store data locally
- Update or delete items
- Receive notifications when items are deleted
- Enable/disable notifications
- Support Light & Dark mode

---

## ✅ Solution

Report Manager addresses these needs with:

- **Google Sign-In** via Firebase
- **PDFKit** for PDF viewing
- **Image Picker** (UIKit wrapped in SwiftUI) for camera/gallery
- **URLSession** for API requests
- **Core Data** for offline storage
- **Local Notifications** via UNUserNotificationCenter
- **Settings screen** to toggle notifications
- **MVVM architecture** for clean, reusable code
- Full **Light/Dark mode** support

---

## 🚀 Features

- 🔐 Secure Google Sign-In
- 📄 PDF report viewer
- 📸 Image picker (camera & gallery)
- 🌐 Fetch & display REST API data
- 🧠 Offline storage with Core Data
- 🗑️ Update & delete with confirmation
- 🔔 Notification on delete
- ⚙️ Settings: notification toggle
- 🌙 Light & Dark mode

---

## 🛠 Tech Stack

| Area         | Technology                  |
|--------------|----------------------------|
| Language     | Swift 5                    |
| UI           | SwiftUI, UIKit             |
| Architecture | MVVM                       |
| Persistence  | Core Data                  |
| Networking   | URLSession                 |
| Auth         | Firebase Google Sign-In    |
| PDF          | PDFKit                     |
| Notifications| UNUserNotificationCenter   |

---

## 📂 Folder Structure

Report Manager/
├── Views/ # UI screens
├── ViewModels/ # Logic & state management
├── Models/ # Core Data + Codable models
├── Services/ # API, Notifications, Permissions
├── Resources/ # Firebase plist file
├── Assets/ # Colors & icons
└── Report_ManagerApp.swift # Entry point
