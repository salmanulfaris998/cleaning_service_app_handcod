# Gemini Project Analysis: Caracess

This document provides a comprehensive analysis of the Caracess Flutter project to serve as a context guide for AI-driven development.

## 1. Project Overview

- **Project Name**: `caracess`
- **Description**: A Flutter e-commerce application for car accessories.
- **Platform Support**: The project is structured for multi-platform deployment (Android, iOS, Web, Windows, macOS, Linux).
- **Architecture**: The project follows a feature-driven architecture, with UI, logic, and data models organized into distinct feature folders within `lib/features`.

## 2. Core Technologies & Dependencies

- **State Management**: `flutter_riverpod` is used for state management, as indicated by the `ProviderScope` in `main.dart` and the `ConsumerWidget` implementation.
- **Routing**: `go_router` is used for declarative routing. The configuration in `lib/routing/app_router.dart` defines all application routes, including a `ShellRoute` for persistent navigation (e.g., a bottom navigation bar).
- **HTTP Client**: `dio` is used for making network requests to APIs.
- **Authentication**: `firebase_auth`, `google_sign_in`, and `sign_in_with_apple` are integrated, indicating robust authentication options.
- **Payments**: `razorpay_flutter` is included for handling payments.
- **Local Storage**: `shared_preferences` is used for simple key-value data persistence.
- **UI & UX**:
    - **Component Library**: `google_nav_bar` for the bottom navigation, `carousel_slider` for image carousels.
    - **Icons**: `cupertino_icons` and `phosphor_flutter`.
    - **Fonts**: Custom fonts `Gabarito` and `CircularStd` are used.
    - **Images**: `flutter_svg` for vector graphics.
- **Utilities**:
    - `geolocator` & `geocoding`: For location-based services.
    - `image_picker`: For selecting images from the gallery or camera.
    - `fluttertoast`: For showing simple toast notifications.

## 3. Project Structure

The project is well-organized, with a clear separation of concerns.

- `lib/`: Contains all the Dart source code.
    - `main.dart`: The application entry point. It initializes Firebase, sets up the Riverpod `ProviderScope`, and configures the `MaterialApp.router`.
    - `core/`: Core utilities, like `SizeConfig`.
    - `data/`: Shared data models (e.g., `product_model.dart`).
    - `features/`: The core of the application, organized by feature. Each sub-directory likely contains its own layers (e.g., `presentation/screens`, `application/controllers`, `data/models`).
        - `auth`: User authentication (login, signup, OTP).
        - `home`: Main home screen and product categories.
        - `products`: Product listing and details.
        - `cart`: Shopping cart functionality.
        - `checkout`: Order checkout process.
        - `orders`: User's order history.
        - `profile`: User profile, addresses, and settings.
        - `search`: Product search functionality.
        - `wishlist`: User's wishlist.
        - `common`: Shared widgets and screens (e.g., `SplashScreen`, `MainNavigationScreen`).
    - `routing/`: Contains the `go_router` configuration (`app_router.dart`).
    - `shared/`: Contains shared components like themes (`AppTheme`) and widgets.
- `assets/`: Static assets.
    - `fonts/`: Custom font files.
    - `icons/`: SVG and PNG icons.
    - `images/`: JPG and PNG images for products, sliders, and logos.
- `pubspec.yaml`: The project manifest, defining dependencies and assets.
- `analysis_options.yaml`: Configures Dart code analysis, using the recommended `flutter_lints` package.

## 4. Navigation (`go_router`)

- **Initial Route**: `/splash`
- **Main Navigation**: A `ShellRoute` manages the main screens (`/home`, `/cart`, `/search`, `/orders`) within a persistent `MainNavigationScreen` widget, which likely contains the `google_nav_bar`.
- **Route Parameters**: Routes like `/category-products/:categoryId` use path parameters to pass data.
- **Passing Data**: The `/product-details` route expects a `Product` object to be passed via the `extra` parameter in `GoRouter`.
- **Authentication Flow**: Routes like `/login`, `/signup`, and `/otp` are defined, suggesting a standard authentication flow managed by navigation.

## 5. Key Development Notes & Tasks

The `WISHLIST_API_INTEGRATION.md` file outlines a clear plan and current status for a key feature.

- **Objective**: Implement and integrate wishlist functionality with a backend API.
- **API Endpoints**:
    - `GET /api/wishlist/`: Fetch user's wishlist.
    - `POST /api/wishlist/`: Add a product to the wishlist.
    - `DELETE /api/wishlist/{product_id}/`: Remove a product.
- **Implementation Details**:
    - The logic is handled in `lib/features/wishlist/controller/wishlist_controller.dart` using Riverpod for state management.
    - The UI is in `lib/features/wishlist/presentation/wishlist_screen.dart`.
    - The implementation includes loading, error, and empty states.
- **Status**: The document suggests the feature is well-defined and likely in a good state of completion, with testing performed via Postman and UI integration.

## 6. Build and Run

- **Get Dependencies**: `flutter pub get`
- **Run App**: `flutter run`

## 7. API & Authentication Architecture

This section outlines the centralized authentication and session management strategy.

- **Central Logic**: All API authentication and token refresh logic is centralized in a `QueuedInterceptorsWrapper` within `lib/shared/services/api_service.dart`.

- **Interceptor Responsibilities**:
    1.  **Attach Token**: Automatically adds the `Authorization` header to all outgoing requests.
    2.  **Handle 401 Errors**: Catches `401 Unauthorized` responses, indicating an expired access token.
    3.  **Refresh Token**: Attempts to get a new access token by calling the `/api/token/refresh/` endpoint with the stored refresh token.
    4.  **Retry Request**: If the refresh is successful, it automatically retries the original failed request with the new token.
    5.  **Logout**: If the refresh token is invalid and the refresh fails, it automatically calls the `logout()` method in the `authProvider` to clear all user data and log the user out.

- **Critical Convention: Header Format**
    - The backend server expects the `Authorization` header to be formatted as: `Authorization: JWT <token>`.
    - The `onRequest` interceptor is configured to use this **JWT** scheme, not the `Bearer` scheme.

- **State Synchronization**
    - When a token is successfully refreshed, the interceptor calls `ref.read(authProvider.notifier).updateToken(newAccessToken)` to ensure the live application state is updated with the new token.

- **Service/Controller Pattern**
    - Data services (e.g., `CartService`, `WishlistService`) **must not** contain any manual token-handling logic.
    - All services that require authentication must be initialized with the main `Dio` instance provided by `apiServiceProvider` to ensure they use the interceptor.
    - Controllers (e.g., `CartController`) **must not** check for tokens before calling a service. They should call the service directly and handle loading/error states based on the provider's response. Authentication is handled entirely by the service layer and its interceptors.