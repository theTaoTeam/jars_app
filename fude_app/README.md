# JARS
Create a jar, add ideas to that jar, and then pull randomly from it to discover a new world of stuff to do and things to try!

### Setting Up
#### Assuming Flutter is Installed
    1. Names with hyphens are considered invalid module names in dart, so change the fude-app folder's name to be fude_app.
    2. Delete the fude_app/ios/Flutter folder. This may be unnecessary - a test is needed.
    3. With the fude_app folder as your pwd run `flutter packages get`, then run `flutter create -i swift .` to recreate missing files inside the current folder.
#### Commitizen
    We use commitizen to format our commit messages. To use commitizen with this repository please use the following steps:
    1. Install commitizen globally using `npm i -g commitizen`.
    2. Run `npm install` from the root folder.
    3. Use `git add` like normal.
    4. When committing, use `git cz`.
    5. Use the prompts to write your commit message.
