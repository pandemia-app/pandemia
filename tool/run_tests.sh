#!/bin/bash

echo "Running tests..."
flutter test --coverage test

echo "Generating coverage badge..."
flutter pub run flutter_coverage_badge

echo "Done!"