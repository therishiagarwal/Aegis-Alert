#  Aegis Alert – Women Safety Analytics 
**SIH 2K24 | Problem Statement: Women Safety Analytics – Protecting Women from Safety Threats (1605)**  

## Overview  
Aegis Alert is a **real-time women safety** application designed for **Smart India Hackathon 2024 (SIH 2K24)**. It combines **AI-driven audio analysis**, **gesture-based alerts**, and **instant emergency communication** to enhance women's security.  

##  Key Features  
✅ **Shake Gesture SOS Activation** – Triggers emergency alerts via shaking.  
✅ **AI-based Voice Analysis** – Detects distress through speech & emotion recognition.  
✅ **Real-time Gender Classification** – Differentiates between male & female voices.  
✅ **Automatic Emergency Calls & SMS** – Sends distress messages with live location.  
✅ **Native SOS Integration** – Enables the device’s built-in emergency features.  
✅ **Secure Contact Management** – Users can add emergency contacts from their phonebook.  

## Tech Stack  
- **Flutter** – Cross-platform mobile app development.  
- **Firebase** – User authentication & real-time database.  
- **TensorFlow Lite (TFLite)** – On-device AI models for voice analysis.  
- **Background Services** – Runs in the background for continuous monitoring.  
- **Google Maps API** – Location tracking for emergency response.  

##  How It Works  
1. **User registers & sets emergency contacts.**  
2. **Shake or voice distress triggers the SOS alert.**  
3. **App analyzes voice for distress signals using AI.**  
4. **SOS message with live location is sent to emergency contacts.**  
5. **Emergency call is placed & native SOS is activated.**  

##  Setup & Installation  
  ```sh
  # Clone the repository
  git clone https://github.com/your-username/aegis-alert.git

  # Navigate to the project directory
  cd aegis-alert

  # Install dependencies
  flutter pub get

  # Run the app
  flutter run
```

##  Resources  
If you're new to Flutter, here are some resources to help you get started:  

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)  
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)  
- [Flutter Documentation](https://docs.flutter.dev/) – Tutorials, samples, and API reference.  

##  License
This project is licensed under the MIT License.

## Future Enhancements
- Integration of additional AI models for more robust distress detection.
- Expanding emergency alert customization.
- Cross-platform enhancements.


