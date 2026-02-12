import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recent_roll_drawer/recent_roll_drawer.dart';

void main() {
  testWidgets('RollDrawer smoke test', (WidgetTester tester) async {
    final controller = RollDrawerController();
    
    await tester.pumpWidget(
      MaterialApp(
        home: RollDrawer(
          controller: controller,
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  child: Text('Test Drawer'),
                ),
              ],
            ),
          ),
          child: Scaffold(
            appBar: AppBar(title: Text('Test')),
            body: Center(child: Text('Test Content')),
          ),
        ),
      ),
    );

    expect(find.text('Test Content'), findsOneWidget);
    expect(find.text('Test Drawer'), findsNothing);
    
    controller.open();
    await tester.pumpAndSettle();
    
    expect(find.text('Test Drawer'), findsOneWidget);
  });
}
