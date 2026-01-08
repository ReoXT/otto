<!-- 
Android App Icon Configuration Note:

The app_icon.svg serves as the base for generating PNG icons.

To properly configure app icons for Android, you'll need to:

1. Generate PNG versions from app_icon.svg at these sizes:
   - mdpi (1x): 48x48 px
   - hdpi (1.5x): 72x72 px
   - xhdpi (2x): 96x96 px
   - xxhdpi (3x): 144x144 px
   - xxxhdpi (4x): 192x192 px

2. Place them in:
   - android/app/src/main/res/mipmap-mdpi/ic_launcher.png
   - android/app/src/main/res/mipmap-hdpi/ic_launcher.png
   - android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
   - android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
   - android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png

3. Alternatively, use flutter_launcher_icons package:
   - Add to pubspec.yaml dev_dependencies
   - Create flutter_launcher_icons.yaml config
   - Run: flutter pub run flutter_launcher_icons

For now, app_icon.svg can be converted using online tools or design software.
-->
