# jihad

A new Flutter project.

## AI Chatbot (Gemini) setup

This app includes an AI Chatbot tab backed by Google Gemini via the `google_generative_ai` package.

1) Get an API key from Google AI Studio.
2) Preferred: create a `.env` file (copy from `.env.example`) and set:

```
GEMINI_API_KEY=YOUR_KEY
```

3) Run the app normally:

```
flutter run
```

Alternatively, you can pass it at run time using Dart define:

```
flutter run --dart-define=GEMINI_API_KEY=YOUR_KEY
```

Alternatively, you may hardcode the key in `lib/utils/ai/gemini_service.dart` by replacing `REPLACE_WITH_YOUR_KEY` (not recommended for production).

You can change the model by editing `GeminiService.modelName`.


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
