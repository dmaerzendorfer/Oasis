# Info
This was part of an assignment for my studies at the FH Salzburg. The result is a prototype for a mobile game about redirecting a river to an oasis.

# MobileGames Assignment

by David Märzendorfer

Das Spiel heißt "Oasis" ist als kleines puzzle game gedacht. Man muss versuchen einen Fluss zur Oase umzuleiten. Dafür im Spiel einfach irgendwo hindrücken und über Drag oder Tilt des Phones die Fluss richtung ändern.

Overall: clunky prototype.

Derzeit nur Main-Menu und ein Demo level. 

Gyro is disabled per default in the main menus options.

Using Godot 4 and godot-script.
min android sdk: 26

## Building APK
For AudioFocus the AudioFocusPlugin is implemented in androidStudio. this builds an aar file that is used by the godot project.

provided an apk in the Builds folder, can also be built in godot with the included gradle build.
