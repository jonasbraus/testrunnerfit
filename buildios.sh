flutter pub get
cd ios
pod repo update
cd ..
flutter build ios --release --no-codesign --no-tree-shake-icons
cd build/ios
rm -rf Payload
mkdir Payload
mv iphoneos/Runner.app Payload
zip -qq -r -9 FlutterIpaExport.ipa Payload
