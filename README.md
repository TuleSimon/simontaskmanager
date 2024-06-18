# simontaskmanager

A clean architecture Flutter application built using Bloc, Dio, and shared_preferences.

## Architecture

This project is built using Clean Architecture together with Test Driven Development (TDD). I chose this architecture because it makes code easier to write, maintain, and scale. Below is a detailed explanation of the components and flow of the architecture:

### Key Features

- **Clean Architecture:** The app is structured following Clean Architecture principles.
- **Test Driven Development (TDD):** Tests are written before the concrete implementations of classes, ensuring a high level of code reliability.
- **Dependency Inversion:** The project follows dependency inversion principles, making the codebase flexible and easier to manage.

### Tools and Libraries

- **Bloc:** For state management.
- **Dio:** For handling HTTP requests.
- **shared_preferences:** For local storage solutions.
- **Mockito:** For creating mock versions of classes during testing.
- **get_it:** For dependency injection.

### Project Structure

The project is divided into several features, with each feature containing the following directories:

- **Data:** Contains data sources, models, and repositories.
- **Domain:** Contains entities, repositories, and use cases.
- **Presentation:** Contains UI components like screens, widgets, and Bloc implementations.

### Data Flow

- **Upwards Flow:** Data flows upwards towards the UI.
- **Downwards Flow:** Events flow downwards from the UI to the data layer.

### Diagram

Below is a visual representation of the architecture (image credits: Reso Coder).

<p align="center">
  <img src="images/Clean-Architecture-Flutter-Diagram.webp" alt="Clean Architecture Diagram" width="700" height="700">
</p>

## Testing

- **Mockito:** Used for creating mock versions of classes.
- **Test Driven Development (TDD):** Tests are written before the implementation of classes, following the TDD approach.

## Conclusion

This project demonstrates the use of Clean Architecture in Flutter applications, ensuring a scalable, maintainable, and testable codebase.
