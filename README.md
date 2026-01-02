# Biblioo – Mobile Book Marketplace and Community Platform
## Group Members
1. Nor Azreen Binti Asari (2217638)
2. Nur Irdina binti Abd Rahman (2213414)
3. Nur Alifah Ilyana Binti Mohd Zaman (2217466)

## Introduction
Biblioo is a mobile application designed to provide readers with a unified platform to buy and sell physical books while engaging in a social reading community. The application combines a peer-to-peer book marketplace with a community feed where users can share book reviews, recommendations, and reading experiences.

By integrating marketplace functionality with social interaction, Biblioo aims to simplify the process of discovering books, connecting with fellow readers, and giving physical books a second life. The system leverages Firebase services for user authentication, real-time data storage, image handling, and in-app messaging, ensuring a scalable and responsive user experience.

## Objectives
The main objectives of Biblioo are as follows:

- To provide a simple and secure platform for users to buy and sell physical books by category.
- To enable users to list books with images, descriptions, and pricing information.
- To allow direct communication between buyers and sellers through in-app chat.
- To create a community feed where users can share book reviews, recommendations, and reading-related posts.
- To encourage interaction and discovery among readers through a combined marketplace and social environment.
- To utilize Firebase as a backend solution for efficient authentication, data management, and media storage.

## Target Users
Biblioo is designed for a wide range of book enthusiasts, including:

- Students who wish to buy affordable second-hand books or sell books they no longer need.
- Casual readers looking to discover new books through recommendations and community discussions.
- Avid readers who enjoy sharing reviews, opinions, and reading experiences.
- Individuals interested in sustainable reading practices by reusing and reselling physical books.
- Small-scale independent sellers who want a simple platform to reach book buyers.

The application is suitable for users who prefer a mobile-based solution that combines both e-commerce and social networking features in a single, easy-to-use system.

## Features & Functionalities
1. User Management & Authentication
- Firebase Auth: Support for Email/Password and Google Sign-in.
- User Profiles: Customizable profiles showing the user's "Bookshelf" (listings), "Read List" (reviews), and follower count.

2. Marketplace (P2P Commerce)
- Smart Listing: A form to upload book images (Firebase Storage), title, ISBN, condition, and price.
- Search & Filter: Category-based browsing (e.g., Fiction, Textbooks, Sci-Fi) and keyword search.
- Wishlist: Save books to a "Favorites" list for future purchase.

3. Community & Social Feed
- Dynamic Feed: A scrollable timeline of book reviews and "Bookstagram" style photos.
- Interactions: Users can like, comment, and share posts.
- Book Reviews: A dedicated post type with star ratings and "Currently Reading" status updates.

4. Communication System
- Real-time Chat: Integrated Firestore-based messaging between buyers and sellers.
- Push Notifications: Alerts for new messages, price drops on wishlisted books, or social interactions (Cloud Messaging).

## UI Mockup
## Architecture / Technical Design
Biblioo is developed as a hybrid mobile application using Flutter, following a client–backend architecture with Firebase as the backend-as-a-service (BaaS). The architecture is designed to separate concerns between the user interface, application logic, and data services to ensure maintainability and scalability.
Application Architecture
The application is structured into three main layers:
1. Presentation Layer (UI Layer)
This layer handles all user-facing components and interactions. It consists of Flutter widgets that represent screens such as authentication, marketplace listings, book details, community feed, and chat screens.
Key responsibilities:
Rendering UI components using Flutter widgets
Handling user input through forms and buttons
Navigating between screens using route-based navigation
Displaying real-time updates from Firestore streams

2. Application Logic Layer (Controller / State Management)
This layer manages the business logic and application state. It acts as a bridge between the UI and Firebase services.
Key responsibilities:
Managing authentication state (logged in / logged out)
Handling marketplace logic such as creating listings, saving wishlists, and filtering books
Managing social interactions such as likes, comments, and post creation
Controlling chat message flow and conversation state
State management is handled using Provider, which allows shared application state (e.g. current user, listings, feed data) to be accessed efficiently across widgets without excessive rebuilding.

3. Backend & Services Layer (Firebase)
Firebase provides all backend services required by the application, reducing the need for a custom server.
Firebase services used:
Firebase Authentication for secure user login (Email/Password and Google Sign-In)
Cloud Firestore as the primary NoSQL database for users, books, posts, chats, and interactions
Firebase Storage for storing book images and post media
Firebase Cloud Messaging (FCM) for push notifications related to messages, wishlist updates, and social interactions
This architecture ensures real-time synchronization, supports peer-to-peer interactions, and allows the application to scale as the number of users grows.
## Data Model

## Flowchart/ Sequence Diagram
## References
