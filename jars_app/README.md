# JARS
A way to share ideas, randomize your weekend, and avoid making decisions!

Inspired by a recipe jar we randomly pull from at home, JARS allows for random selections of things you love at the tip of your finger.


By putting ideas into a jar you create a space to pull ideas from. Just start a jar (e.g. date night) and add ideas to it (dinner, movie, camping in the backyard, etc.) then when it’s time to act, pull one of your ideas out and go! We’ve added an option for categories in each jar, in case you prefer stellar organization. Planning something extra special? Make a “fine dining” category in your vacations jar, next to your “Movies” category. Or get wild and pull from all categories, the world is yours!
 
Customize your JARS experience with the following features:

• Share your JARS with friends so you can enjoy the same jars and experiences together
• Switch to dark theme by tapping the YinYang symbol
• Add images
• Add links to your ideas for quick look up
• Write notes down in your ideas for future reference
• Favorite your ideas


If you have any problems or suggestions, please let us know.
Feedback is always welcome; we’d love to hear from you! 

Support email: dev@tao.team

# Demos
<p float="left">
 <img src="https://user-images.githubusercontent.com/17322126/58373722-fbe6c800-7eef-11e9-8db6-78803370442a.gif" width="350" height="400">
 <img src="https://user-images.githubusercontent.com/17322126/58373731-1a4cc380-7ef0-11e9-8866-105346de5d49.gif" width="350" height="400">
 <img src="https://user-images.githubusercontent.com/17322126/58373748-7adc0080-7ef0-11e9-894d-0983c160bbeb.gif" width="350" height="400">
 <img src="https://user-images.githubusercontent.com/17322126/58373752-8af3e000-7ef0-11e9-97f2-6a576f157cf3.gif" width="350" height="400">
 </p>

### Setting Up
#### Assuming Flutter is Installed
    1. Names with hyphens are considered invalid module names in dart, so change the jars folder's name to be jars.
    2. Delete the jars/ios/Flutter folder. This may be unnecessary - a test is needed.
    3. With the jars folder as your pwd run `flutter packages get`, then run `flutter create -i swift .` to recreate missing files inside the current folder.
#### Commitizen
    We use commitizen to format our commit messages. To use commitizen with this repository please use the following steps:
    1. Install commitizen globally using `npm i -g commitizen`.
    2. Run `npm install` from the root folder.
    3. Use `git add` like normal.
    4. When committing, use `git cz`.
    5. Use the prompts to write your commit message.
