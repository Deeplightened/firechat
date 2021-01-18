#!/bin/bash
cd ../../
if [ "$1" == "--clean" ]
then
   echo "Running clean..."
   flutter clean
else
   echo "Skipping clean..."
fi


echo "Generate internationalization..."
flutter gen-l10n --arb-dir lib/common/l10n

echo "Generate derived code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

if [ "$1" == "--apk" ]
then
   echo "Building APK..."
   flutter build apk --release
else
   echo "Building AAB..."
   if [ "$1" == "--staging" ] || [ "$2" == "--staging" ]
   then
      flutter build appbundle --flavor staging --release
   else
      flutter build appbundle --flavor prod --release
   fi
fi