# Maia - Stores App for iOS

Maia is a native iOS application designed for stores to efficiently manage their inventory and interact with customers. It leverages SwiftUI for a modern, intuitive interface and integrates advanced backend technologies to ensure seamless operation and scalability.

## Features

### Product Management
- Create, read, update, and delete (CRUD) operations for inventory management.
- Customize product details such as descriptions, prices, and availability.

### Real-Time Communication
- Integrated with Firebase Firestore for instant messaging with customers.
- Receive and respond to customer inquiries in real time.

### Store Profiles
- Manage personalized store profiles, including details like contact information and operating hours.
- Automatically synchronize updates across all linked products and interactions.

### Security
- API Key-based authentication for secure access.
- Encrypted data storage for robust protection of sensitive information.

### Scalability and Maintainability
- Implements Clean Architecture and MVVM patterns.
- Ensures smooth scalability and efficient code management.

## Technologies Used

- **Frontend:** SwiftUI for declarative UI design.
- **Backend:** Ktor server for handling operations and secure communications.
- **Database:** MongoDB for scalable and reliable data storage.
- **Messaging:** Firebase Firestore for real-time communication.

## Getting Started

### Prerequisites
- Xcode 13 or later.
- Swift 5.5 or later.
- Firebase account for integration.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/ldgomm/maia-ios.git
   ```
2. Navigate to the project directory:
   ```bash
   cd maia-ios
   ```
3. Install dependencies using Swift Package Manager:
   - Open the project in Xcode.
   - Go to `File > Add Packages`.
   - Add the required packages as specified in the documentation.

### Configuration
1. Set up Firebase:
   - Download your `GoogleService-Info.plist` file from the Firebase Console.
   - Add it to the project root in Xcode.
2. Configure API Keys in the `Environment` file.

### Running the App
1. Build and run the app on your simulator or device:
   ```bash
   Command + R
   ```

## Contributing

We welcome contributions! To contribute:
1. Fork the repository.
2. Create a new branch for your feature or bugfix.
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes.
   ```bash
   git commit -m "Description of your changes"
   ```
4. Push to your fork.
   ```bash
   git push origin feature-name
   ```
5. Submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For questions or support, please reach out to:
- **Email:** support@maiaapp.com
- **GitHub Issues:** [Issue Tracker](https://github.com/ldgomm/maia-ios/issues)
