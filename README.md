HabitAI - Quick Setup Guide
Steps to Run the Project

Clone the repo

git clone <repo_url>
cd habitai


Install dependencies

flutter pub get


Log in to Firebase (client account)

firebase logout
firebase login


Add and select the Firebase project

firebase use --add    # add client project
firebase use <alias>  # switch to the project

Ensure environment files exist

assets/.env.dev
assets/.env.staging
assets/.env.prod


Deploy Firestore rules

firebase deploy --only firestore:rules


Run the app

Dev

flutter run -t lib/main.dart --flavor dev --dart-define=ENV=dev


Staging

flutter run -t lib/main.dart --flavor staging --dart-define=ENV=staging


Prod

flutter run -t lib/main.dart --flavor prod --dart-define=ENV=prod