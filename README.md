# SimonTaskManager

A clean architecture Flutter application built using Bloc, Dio, and shared_preferences.

## Overview

This project was initially an assessment, but I enjoyed it so much that I learned a lot in the
process. If I had more time, I would have worked more on the UI design.

## Architecture

This project is built using Clean Architecture together with Test Driven Development (TDD). I chose
this architecture because it makes code easier to write, maintain, and scale. Below is a detailed
explanation of the components and flow of the architecture:

### Key Features

- **Clean Architecture:** The app is structured following Clean Architecture principles.
- **Test Driven Development (TDD):** Tests are written before the concrete implementations of
  classes, ensuring a high level of code reliability.
- **Dependency Inversion:** The project follows dependency inversion principles, making the codebase
  flexible and easier to manage.
- **Dependency Injection:** The project uses dependency injection to manage dependencies
  efficiently.

## App Features

- **Login:** Users can log in.
- **Logout:** Users can log out.
- **Add new todo:** Users can add a new todo.
- **Edit an existing todo:** Users can edit an existing todo.
- **Delete an existing todo:** Users can delete an existing todo with a swipe-to-delete gesture.
- **Pagination:** Supports endless pagination.
- **Offline Cache:** Supports offline caching.

### Tools and Libraries

- **Bloc:** For state management.
- **Dio:** For handling HTTP requests.
- **shared_preferences:** For local storage solutions.
- **Mockito:** For creating mock versions of classes during testing.
- **get_it:** For dependency injection.

### Project Structure

The project is divided into several features, with each feature containing the following
directories:

- **Data:** Contains data sources, models, and repositories.
- **Domain:** Contains entities, repositories, and use cases.
- **Presentation:** Contains UI components like screens, widgets, and Bloc implementations.

### Data Flow

- **Upwards Flow:** Data flows upwards towards the UI.
- **Downwards Flow:** Events flow downwards from the UI to the data layer.

### Diagram

Below is a visual representation of the architecture (image credits: Reso Coder).

<p align="center">
  <img src="images/Clean-Architecture-Flutter-Diagram.webp" alt="Clean Architecture Diagram" width="600" height="400">
</p>

## Testing

- **Mockito:** Used for creating mock versions of classes.
- **Test Driven Development (TDD):** Tests are written before the implementation of classes,
  following the TDD approach.

### Snapshots

Below are snapshots of the application features.

## App Screenshots

| Screenshot                                                                           | Description                        |
|--------------------------------------------------------------------------------------|------------------------------------|
| <img src="./images/add.png" alt="Add Feature" width="300" height="600">              | Screenshot of the Add feature      |
| <img src="./images/delete.png" alt="Delete Feature" width="300" height="600">        | Screenshot of the Delete feature   |
| <img src="./images/edit.png" alt="Edit Feature" width="300" height="600">            | Screenshot of the Edit feature     |
| <img src="./images/home.png" alt="Home Page" width="300" height="600">               | Screenshot of the Home page        |
| <img src="./images/login.png" alt="Login Page" width="300" height="600">             | Screenshot of the Login page       |
| <img src="./images/login_error.png" alt="Login Error Page" width="300" height="600"> | Screenshot of the Login Error page |

## Conclusion

This project demonstrates the use of Clean Architecture in Flutter applications, ensuring a
scalable, maintainable, and testable codebase.

## Setup Instructions

To run this project, clone the repo, run `flutter pub get`, then run `flutter run`.

To log in, you can use the following credentials:

```
{
    "username": "emilys",
    "password": "emilyspass",
}
```