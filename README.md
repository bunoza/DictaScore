# DictaScore

<img src="https://github.com/bunoza/DictaScore/assets/61355658/8f566878-af2e-4fbd-baa4-196f1f131037" width="200" height="200" />

**DictaScore** is an iOS application designed to track scores for various games using voice recognition technology. The app simplifies the process of scorekeeping by allowing users to update and manage scores through voice commands, making it ideal for situations where hands-free operation is beneficial, such as during physical activities or when playing multiple games simultaneously.

## Features

- **Voice Recognition**: The app listens for voice commands to update scores in real-time, reducing the need for manual entry.
- **Customizable Game Settings**: Tailor the app to different types of games by setting rules, scoring methods, and player configurations.
- **User-Friendly Interface**: Designed with simplicity in mind, the app provides an intuitive user experience, making it accessible for users of all ages.

## Implementation Details

DictaScore is implemented using the **Model-View-ViewModel (MVVM)** architecture, which ensures that the app is modular, maintainable, and easy to extend:

- **Model**: Manages the data and business logic, including handling score calculations and game configurations.
  
- **View**: The user interface where users interact with the app, designed to clearly display scores and respond to voice commands.
  
- **ViewModel**: Acts as a bridge between the View and the Model, processing voice input and updating the UI accordingly.

### Frameworks and Libraries Used

- **Speech Framework**: Utilized for voice recognition, allowing the app to interpret spoken commands and update scores accordingly.
- **UIKit**: Provides the fundamental UI components, ensuring a responsive and visually appealing interface.
- **Core Data**: Manages the persistent storage of scores and game settings, allowing users to resume games and view past results.

## Installation

To install and run DictaScore on your iOS device:

1. Clone this repository:
   ```bash
   git clone https://github.com/bunoza/DictaScore.git
   ```
2. Open the project in Xcode.
3. Build and run the application on your iOS device or simulator.
