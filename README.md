# baby_f_words

Baby First Words 2

An original weaveio product

## Getting Started

Definitions:
1. Item -> It stores the actual item in the slideshow sound path, image path, name, index etc
2. Slideshow -> This is essentially a library that contains a list of Items, and a name so the slideshow can be uniquely identified 


##FOR BUILD RELEASE
flutter build apk --no-tree-shake-icons

##DEV NOTES
The project uses GetIt hooks, primarily DataManager has copies of all data from Firebase(FB)/
local storage(LS) from shared prefs. Also all modules draw values from DataManager (DM).

to re run the build runner models for JSON serializer, run "flutter pub run build_runner build"

The screens/views are split to individual folders, with a view_model and a view or screen page
They use provider.value examples to connect to the states and update the UI.

The app starts from the LobbyView with all the successive pages are set as widgets


Adding json serializable for processing to and FROM json was great.. video at: https://www.youtube.com/watch?v=8fFoLs9qVQA

To Setup project at another pc, run build runner to create the model dependencies.. the "model.g.dart" files.
"flutter pub run build_runner build"

The main repo is public, but protected. This is version 2, I have overhauled the whole concept behind the app. Instead 
of downloading all the fixed assets for the first time as the app loads, this version is different. It will, on load
1) check firebase and register itself, 
2) it will register the adnetwork
3) It will look up and compare the firebase library with its own
4) If there is a new one it will download it and store it
5) If it is an already existing library it will check its size and if that is also same then it wont go further
6) If the internal library has a new file then it will redownload all of it and store it locally.


This version is more stable then the first time I created it. It has taken me a whole one and half weeks to completely
re-write this app, and also have it get included for iOS. 

## IDEAS FOR VERSION 3
-> Add new assets (Bangla (shorborno, banjon borno, objects, numbers, colors, fruits), English (colors, fruits))
-> A skippable interstitial ad comes, then We can have a games section where you pick the lobby card and a game comes with it
    a) "Memory Match" Memory Match Game (matching gives affirmations "You did it!", "Well done!", "Uh Oh!", "Try Again!")
    b) "Pick The Correct One" An item is randomly selected and its sound is spoken, then 4 tiles come up that includes that item image and 3 others. The baby has to pick the right tile to win.
-> Should be able to launch from codemagic for both apple and android upod merging with prod
-> Add Analytics on pages and some interactions

    
## NOTE:
The package name in xcode is different than the rest of the project because Apple was not recognizing the app id before.


