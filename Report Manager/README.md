# 📊 Report Manager

An iOS app built with SwiftUI that helps users:
- Sign in securely using Google
- View PDF reports
- Work with live data from an API
- Save and manage data offline
- Select and view images
- Get notified when something is deleted


## 🧩 Problem Statement

A company needs a simple iOS app that can:

- Let users sign in with their Google account  
- Show a PDF file directly inside the app  
- Allow users to select images from their phone or camera  
- Load and display data from a REST API  
- Save that data locally using Core Data  
- Let users update or delete items  
- Show a notification when an item is deleted  
- Give users control to enable/disable notifications  
- Work in both Light and Dark mode


## ✅ Our Solution

This app solves all the above problems using:

- **Google Sign-In** (via Firebase) for secure login  
- **PDFKit** to display the PDF file  
- **UIKit image picker** (wrapped in SwiftUI) for camera & gallery  
- **URLSession** to load data from the API  
- **Core Data** to store and manage that data offline  
- **Local notifications** using UNUserNotificationCenter  
- A **Settings screen** with a toggle to control notifications  
- Clean **MVVM architecture** to keep code organized and reusable  
- Full **Light/Dark mode support** for better UX


## 🚀 Features

- 🔐 Google Sign-In (Firebase)
- 📄 PDF report viewer
- 📸 Image picker (camera & gallery)
- 🌐 Fetch + display data from REST API
- 🧠 Save API data to Core Data
- 🗑️ Delete + update with confirmation
- 🔔 Local notifications on delete
- ⚙️ Settings screen with notification toggle
- 🌙 Light & Dark mode support


## 🛠 Tech Stack

- **Language**: Swift 5  
- **UI**: SwiftUI + UIKit  
- **Architecture**: MVVM  
- **Persistence**: Core Data  
- **Network**: URLSession  
- **Notifications**: UNUserNotificationCenter  
- **Auth**: Firebase Google Sign-In  
- **PDF**: PDFKit  


## 📂 Folder Structure

Report Manager/
├── Views/ # UI screens
├── ViewModels/ # Logic & state management
├── Models/ # Core Data + Codable models
├── Services/ # API, Notifications, Permissions
├── Resources/ # Firebase plist file
├── Assets/ # Colors & icons
└── Report_ManagerApp.swift # Entry point
