.PHONY: nukebuild

nukebuild:
	@echo "🔥 Nuking the Flutter and iOS cache from orbit..."
	rm -rf pubspec.lock
	rm -rf ios/.symlinks
	flutter clean
	flutter pub get
	cd ios && pod cache clean --all
	cd ios && pod deintegrate
	cd ios && rm -rf Podfile.lock Pods/
	cd ios && pod install --repo-update
	@echo "✅ Deep clean complete! Your project is spotless and ready to run."