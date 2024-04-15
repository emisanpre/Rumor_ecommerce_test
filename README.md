# Rumor Ecommerce Test

Welcome to Rumor Ecommerce Test! This README will guide you through the steps to run the application on your local machine.

[App Working Video](https://youtu.be/-EFK2A9oMWw)

## Why MVVM Architecture with MobX?
The MVVM (Model-View-ViewModel) architecture is a common choice for frontend applications due to its ability to clearly separate the presentation logic from the underlying data. MVVM promotes a clear separation between business logic (Model), user interface presentation (View), and the logic connecting both (ViewModel).

MobX is a state management library that integrates well with the MVVM architecture. It provides a simple and reactive way to manage the application state, meaning that any changes in the state will automatically reflect in the user interface. This makes it easier to maintain consistency between data and its visual representation.

The combination of MVVM and MobX offers the following benefits:

1. Separation of Concerns: MVVM divides the application into well-defined layers, making it easier to maintain and scale. MobX efficiently manages state, eliminating the need to directly manipulate state changes in the user interface.

2. Reactivity: MobX offers reactivity out of the box, meaning that updates to the state are automatically propagated through the user interface without manual intervention.

3. Ease of Use: MobX simplifies state management by minimizing the amount of code needed to update and synchronize data between the model and the view. This makes development faster and less error-prone.

4. Good Performance: MobX uses an efficient observation system that optimizes component updates only when necessary, resulting in optimal performance even in applications with large amounts of data.

## Prerequisites

Before you begin, ensure you have met the following requirements:
- Flutter SDK installed on your machine. If not, you can find the installation instructions [here](https://flutter.dev/docs/get-started/install).
- VSCode, Android Studio or Xcode for Android and iOS development, respectively.
- Emulator or physical device to run the application.

## Getting Started

To get a local copy up and running follow these simple steps:

1. Clone the repository to your local machine:
    ```bash
    git clone https://github.com/EmilioSantillana/Rumor_ecommerce_test.git
    ```
2. Navigate to the project directory:
    ```bash
    cd rumor_ecommerce_test
    ```
3. Install dependencies:
    ```bash
    flutter pub get
    ```
   
## Running the Application

Now that you have cloned the repository and installed the dependencies, you can run the application.
  ```bash
  flutter run
  ```
For better debugging, run the app with the VSCode plugins. Learn how [here](https://docs.flutter.dev/tools/vs-code#running-and-debugging).

## Testing

To run tests, use the following command:
  ```bash
  flutter test
  ```
Note: If tests fails for some reason please run the tests with the VSCode plugins. Learn how [here](https://docs.flutter.dev/cookbook/testing/unit/introduction#6-run-the-tests).
