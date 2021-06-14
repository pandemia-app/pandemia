#!/bin/bash

echo "Running tests..."
flutter test --coverage test

echo "Generating coverage badge..."
flutter pub run flutter_coverage_badge
mv coverage_badge.svg coverage

if ! command -v genhtml &> /dev/null
then
    echo "Genhtml is not installed, skipping HTML pages generation."
else
    echo "Generating HTML pages..."
    genhtml coverage/lcov.info -o coverage/html
fi

echo "Done!"