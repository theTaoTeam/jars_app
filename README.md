#Setting Up

Assuming Flutter is Installed
1. Names with hyphens are considered invalid module names in dart, so change the snuze-app folder's name to be snuze_app.
2. Delete the snuze_app/ios/Flutter folder. This may be unnecessary - a test is needed.
3. With the snuze_app folder as your pwd run `flutter packages get`, then run `flutter create -i swift .` to recreate missing files inside the current folder.
4. Create a .env.dart file in the lib folder with necessary environment variables.
    -FIREBASE_API_KEY
5. Run `flutter packages pub run build_runner build` to build json serializable models.
6. Run pod install from the ios directory.
7. Run using xcode/android studio. Since we're using native  using the xcworkspace file not xcproj because we're using cocoapods.

#Commitizen

We use commitizen to format our commit messages. To use commitizen with this repository please use the following steps:
1. Install commitizen globally using `npm i -g commitizen`.
2. Run `npm install` from the root folder.
3. Use `git add` like normal.
4. When committing, use `git cz`.
5. Use the prompts to write your commit message.
