# Publishing to pub.dev

## Prerequisites

1. **pub.dev Account**: Create an account at https://pub.dev if you haven't already
2. **Google Account**: You'll need a Google account to authenticate
3. **Verified Email**: Make sure your email is verified on pub.dev

## Pre-Publishing Checklist

- [x] Package name is available (recent_roll_drawer)
- [x] LICENSE file exists (MIT License)
- [x] CHANGELOG.md exists and is up to date
- [x] README.md is complete with examples
- [x] Code passes `flutter analyze`
- [x] All dependencies are published packages
- [x] Version number is set correctly (1.0.0)
- [ ] Update homepage and repository URLs in pubspec.yaml with your actual GitHub repo

## Steps to Publish

### 1. Update Repository URLs

Edit `pubspec.yaml` and update:
```yaml
homepage: https://github.com/YOUR_USERNAME/recent_roll_drawer
repository: https://github.com/YOUR_USERNAME/recent_roll_drawer
```

Replace `YOUR_USERNAME` with your actual GitHub username.

### 2. Verify Package

Run these commands to verify everything is ready:

```bash
# Check for analysis issues
flutter analyze

# Dry run to check for publishing issues
flutter pub publish --dry-run
```

### 3. Login to pub.dev

```bash
flutter pub login
```

This will open a browser window for authentication.

### 4. Publish

```bash
flutter pub publish
```

You'll be asked to confirm. Type `y` to proceed.

### 5. Verify Publication

After publishing, check your package at:
```
https://pub.dev/packages/recent_roll_drawer
```

## Important Notes

- **Version Numbers**: Follow semantic versioning (major.minor.patch)
- **Breaking Changes**: Increment major version (2.0.0)
- **New Features**: Increment minor version (1.1.0)
- **Bug Fixes**: Increment patch version (1.0.1)

## After Publishing

1. Add a GitHub repository (if you have one)
2. Add screenshots/GIFs to README.md for better visibility
3. Add topics/tags to your GitHub repo
4. Share on social media/Flutter communities

## Updating the Package

When you make changes:

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md` with new changes
3. Run `flutter pub publish` again

## Troubleshooting

- **Package name taken**: Choose a different name
- **Authentication issues**: Try `flutter pub logout` then `flutter pub login` again
- **Validation errors**: Check the error message and fix issues in pubspec.yaml or code
