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


M8 — Paywall & Subscriptions (RevenueCat) (10%)
 Scope
 • 
• 
• 
• 
• 
• 
• 
Demo
 • 
• 
RevenueCat integration (recommended) for cross‑platform IAP (Weekly/Monthly/Annual, free
 plan activated after limited offer is declined).
 Entitlements gate: AI Coach unlimited, advanced stats, themes, backup priority, etc.
 Limited offer screen: User tries to close paywall --> limited offer screen comes up (with 2-min
 timer) presenting discounted subscription
 If user closes limited offer screen --> returns to paywall one final time --> user closes paywall -->
 free version of the app
 Free version: Limited to 1 habit, 5 AI Coach prompts (not allowed to create more habits)
 Limited AI Coach: Once 5 prompts is reached --> "Get Premium now to unlock your personal AI
 Coach!"
 Restore purchases; manage link to stores.
 Sandbox purchase success/fail; entitlement toggles features immediately.
 Show all outcomes from paywall (user pays, user doesn't pay, accepts limited trial, doesn't accept
 limited trial)
 Acceptance
 • 
Store review‑safe flows; receipts verified by RC; paywall A/B ready via RC or Remote Config.
 M9 — Badges (10%)
 Scope
 • 
• 
Demo
 • 
XP for daily check‑ins and streak thresholds (1 week/1 month/3 months/6 months/9 months/1
 year).
 Badge system; streak threshold reached --> new badge earned --> subtle animations.
 User unlocks a badge --> badge animation screen showing "You've conquered the day! Great
 work!" with current day streak unlocking animation; persistence verified after reinstall.
 Acceptance
 • 
No double‑granting on sync; streak threshold math covered by tests.
 M10 — Settings, Data Export, & Legal (5%)
 Scope
 • 
• 
Profile edit, timezone, theme, notifications, data export (JSON email), delete account.
 Links: Terms, Privacy, Support email.
 4
Demo
 • 
Delete account wipes remote + local; export delivers JSON.
 Acceptance
 • 
Compliant data deletion; graceful error handling.
 M11 — Beta, QA & Performance Pass (5%)
 Scope
 • 
• 
Demo
 • 
Closed beta (TestFlight/Internal) with crash‑free sessions > 99%. Cold start < 2.5s.
 Test plan executed across 6–8 representative devices; bug triage complete.
 QA report + crash/ANR dashboards shared; release candidate build posted.
 Acceptance
 • 
All P1/P2 bugs resolved or signed off.
 M12 — Store Listing & Launch Support (3%)
 Scope
 • 
• 
Demo
 • 
App Store & Play listing assets uploaded; review checklist; live ops config (Remote Config
 messages).
 Attend to first review responses and hotfix if needed.
 Listings in “Ready for Review”; builds submitted; track status.
 Acceptance
 • 
App approved OR resubmission plan actioned with fixes.
 M13 — Handover & Documentation (2%)
 Scope
 • 
• 
Dev handover call. Final docs: architecture, data model, runbooks, operations.
 Knowledge base and backlog transfer.
 5
Acceptance
 • 
All artifacts delivered (see checklists below). Owner can build, release, and run without the
 contractor