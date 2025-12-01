# Testing in Bolsa Empleo Frontend

This document explains how to run the unit tests for the Flutter frontend.

## Prerequisites

- Flutter SDK installed and configured.

## Running Tests

To run all tests, execute the following command in the `bolsaEmpleo_FE` directory:

```bash
flutter test
```

To run a specific test file:

```bash
flutter test test/data/models/skill_model_test.dart
```

## Test Structure

Tests are located in the `test` directory and mirror the structure of the `lib` directory.

- `test/data/models/`: Unit tests for data models.

[BACK](README_EN.md)