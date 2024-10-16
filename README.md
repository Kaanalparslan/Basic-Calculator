Flutter Calculator App
A simple and user-friendly calculator built with Flutter, providing basic arithmetic operations along with percentage and parentheses support.


Add a screenshot of your app here to visually showcase it.

Features
Basic arithmetic operations: addition, subtraction, multiplication, and division.
Percentage calculations.
Parentheses for complex calculations.
Real-time result update as you type.
Clear (AC) button to reset the current calculation.
A delete (backspace) button to remove the last entered digit or operator.
Supports both positive and negative numbers with the "+/-" button.
Getting Started
These instructions will help you set up and run the project on your local machine.

Prerequisites
Flutter SDK: You need to have Flutter installed. You can download it from the official Flutter website.
Android Studio or VSCode: Either of these IDEs can be used to run and test the Flutter app.
To check if Flutter is installed correctly, run the following command in your terminal:

flutter doctor
Installation
Clone the repository:

git clone https://github.com/your-username/flutter-calculator-app.git
cd flutter-calculator-app
Install dependencies:

Navigate to the project folder and run the following command to install the necessary packages:

flutter pub get
Run the app:

Run the app on your connected device or emulator:

flutter run
Folder Structure
The project structure is organized as follows:

lib/
├── main.dart            # Main entry point of the app
├── widgets/             # Custom widget components (if any)
└── utils/               # Utility functions (if any)
Screenshots
Add one or two screenshots to show how the app looks in action.

Usage
Once the app is running, you can perform basic arithmetic operations such as:

Addition: 7 + 5
Subtraction: 9 - 3
Multiplication: 8 × 6
Division: 10 ÷ 2
Percentage: 50 % → will return 0.5
Parentheses: (7 + 3) × 2
The result is updated in real-time as you type, and pressing the = button will finalize the result, allowing you to start a new calculation with that result.

Customization
You can easily modify the UI components or extend the functionality by editing the main.dart file or adding additional components to the widgets folder.

Known Issues
Floating point precision: In some cases, floating-point numbers might show slightly imprecise results due to the limitations of floating-point arithmetic. This has been partially addressed by rounding the numbers.
Contributing
If you'd like to contribute to this project, feel free to fork the repository and submit a pull request. All contributions are welcome!

Fork the repository
Create your feature branch (git checkout -b feature/my-feature)
Commit your changes (git commit -m 'Add my feature')
Push to the branch (git push origin feature/my-feature)
Open a pull request
License
This project is licensed under the MIT License - see the LICENSE file for details.

Contact
For any questions, feel free to contact me at [cekaanalparslan@gmail.com].

