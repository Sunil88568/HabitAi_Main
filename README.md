# HabitAI - M1 Milestone

## Run Flutter App
flutter run -t lib/main.dart --flavor dev --dart-define=ENV=dev
flutter run -t lib/main.dart --flavor staging --dart-define=ENV=staging
flutter run -t lib/main.dart --flavor prod --dart-define=ENV=prod

## Run Server
cd server
npm install
npm run dev
