# ⚡ VoltWise: AI-Powered Smart Grid Monitor

[![Flutter](https://img.shields.io/badge/Flutter-3.0-blue?logo=flutter)](https://flutter.dev)
[![Gemini AI](https://img.shields.io/badge/AI-Gemini%20Flash-orange?logo=google)](https://ai.google.dev/)
[![Live Demo](https://img.shields.io/badge/Demo-Live%20Link-green)](https://srivathsan1510.github.io/voltwise/)

**VoltWise** is a real-time IoT dashboard that bridges **Electrical Engineering** concepts with **Modern Software Development**. 

It simulates a smart home energy grid, visualizes power consumption waveforms in real-time, and uses **Google Gemini AI** to act as an "Electrical Load Manager"—analyzing usage patterns and suggesting efficiency optimizations on the fly.

🔗 **[Click Here to Try the Live Demo](https://srivathsan1510.github.io/voltwise/)**

---

## 🚀 Key Features

* **⚡ Real-Time Load Simulation:** Generates realistic power consumption data (kW) for appliances like ACs, Fridges, and EVs, including random usage spikes.
* **🧠 AI Energy Analyst:** Integrated **Google Gemini 1.5 Flash** to analyze current load and provide actionable safety and efficiency recommendations.
* **📈 Dynamic Waveform Visualization:** Uses `fl_chart` to render live, scrolling power usage graphs similar to professional SCADA systems.
* **💰 Live Bill Estimator:** Real-time calculation of electricity costs based on dynamic consumption.
* **📱 Responsive Dashboard:** A glassmorphism-inspired UI that works on Web and Mobile.

---

## 🛠️ Tech Stack

* **Framework:** Flutter (Web & Mobile)
* **AI Engine:** Google Gemini API (Generative AI SDK)
* **State Management:** Provider
* **Visualization:** FL Chart
* **Hosting:** GitHub Pages

---

## 👨‍💻 Setup & Installation

**Note:** For security reasons, the API Key file is not included in this repository.

1.  **Clone the repo:**
    ```bash
    git clone [https://github.com/srivathsan1510/voltwise.git](https://github.com/srivathsan1510/voltwise.git)
    cd voltwise
    ```

2.  **Create the Key File:**
    * Create a new file named `api_key.dart` inside the `lib/` folder.
    * Paste the following code into it:
      ```dart
      const String geminiApiKey = "YOUR_OWN_GEMINI_API_KEY";
      ```
    * *(You can get a free key from [Google AI Studio](https://aistudio.google.com/))*

3.  **Run the app:**
    ```bash
    flutter run
    ```
