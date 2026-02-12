# Recent Roll Drawer

A Flutter package providing a unique roll drawer with screen previews and customizable animations.

## Features

- **Roll Drawer** - Unique paper roll animation effect
- **Screen Previews** - Display recent screens as mini previews in drawer
- **Simple Mode** - Option to use standard slide-in drawer
- **Customizable** - Control animation, colors, and behavior
- **Easy to Use** - Simple API with sensible defaults

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  recent_roll_drawer: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:recent_roll_drawer/recent_roll_drawer.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  final RollDrawerController _drawerController = RollDrawerController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RollDrawer(
        controller: _drawerController,
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text('Menu'),
              ),
              ListTile(
                title: Text('Home'),
                onTap: () => _drawerController.close(),
              ),
            ],
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => _drawerController.open(),
            ),
          ),
          body: Center(
            child: Text('Your Content'),
          ),
        ),
      ),
    );
  }
}
```

### With Screen Previews

```dart
import 'package:recent_roll_drawer/recent_roll_drawer.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final RollDrawerController _drawerController = RollDrawerController();
  final ScreenStackController _screenStackController = ScreenStackController();
  
  Widget _currentScreen = HomeScreen();

  void _navigateToScreen(Widget screen, String title) {
    setState(() {
      _currentScreen = screen;
    });
    
    _screenStackController.pushScreen(
      ScreenPreview(
        title: title,
        icon: Icon(Icons.home),
        color: Colors.blue,
        previewWidget: screen,
        onTap: () {
          _navigateToScreen(screen, title);
          _drawerController.close();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RollDrawer(
        controller: _drawerController,
        screenStackController: _screenStackController,
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(child: Text('Menu')),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  _navigateToScreen(HomeScreen(), 'Home');
                  _drawerController.close();
                },
              ),
            ],
          ),
        ),
        child: _currentScreen,
      ),
    );
  }
}
```

## Configuration Options

### RollDrawer Properties

```dart
RollDrawer(
  child: Widget,                    // Required: Main content
  drawer: Widget,                   // Required: Drawer content
  controller: RollDrawerController?, // Optional: Controller for programmatic control
  screenStackController: ScreenStackController?, // Optional: For screen previews
  drawerWidth: 300.0,              // Drawer width (default: 300.0)
  animationDuration: Duration(milliseconds: 600), // Animation duration
  animationCurve: Curves.easeInOutCubic, // Animation curve
  cylinderWidth: 45.0,             // Cylinder width for roll effect
  drawerPadding: EdgeInsets.zero,  // Padding inside drawer
  showScreenPreviews: true,         // Show screen previews
  maxScreenPreviews: 5,             // Max previews to show
  screenPreviewBackgroundColor: Colors.black, // Preview section background
  enableAnimation: true,            // Enable/disable animation
  enableRollEffect: true,           // Enable roll effect (false = simple slide)
  onDrawerChanged: () {},          // Callback when drawer state changes
)
```

### RollDrawerController

```dart
final controller = RollDrawerController();

controller.open();    // Open drawer
controller.close();   // Close drawer
controller.toggle(); // Toggle drawer state
bool isOpen = controller.isOpen; // Check if open
```

### ScreenStackController

```dart
final stackController = ScreenStackController(maxScreens: 10);

stackController.pushScreen(ScreenPreview(...)); // Add screen
stackController.removeScreen('Title');         // Remove screen
stackController.clearAll();                    // Clear all screens
stackController.screens;                       // Get all screens
```

### ScreenPreview

```dart
ScreenPreview(
  title: 'Screen Title',           // Required: Screen title
  icon: Icon(Icons.home),          // Optional: Icon widget
  color: Colors.blue,              // Optional: Fallback color
  previewWidget: Widget,            // Optional: Actual screen widget for preview
  onTap: () {},                    // Optional: Tap callback
  timestamp: DateTime.now(),       // Optional: Timestamp
)
```

## Examples

### Simple Slide Drawer (No Roll Effect)

```dart
RollDrawer(
  enableRollEffect: false,
  drawer: Drawer(...),
  child: Scaffold(...),
)
```

### Disable Animation

```dart
RollDrawer(
  enableAnimation: false,
  drawer: Drawer(...),
  child: Scaffold(...),
)
```

### Custom Colors

```dart
RollDrawer(
  screenPreviewBackgroundColor: Colors.black.withOpacity(0.3),
  drawer: Drawer(...),
  child: Scaffold(...),
)
```

## Example App

See the complete example in the `/example` folder:

```bash
cd example
flutter run
```

## License

MIT License
