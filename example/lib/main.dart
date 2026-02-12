import 'package:recent_roll_drawer/recent_roll_drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roll Drawer Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoHome(),
    );
  }
}

class DemoHome extends StatefulWidget {
  const DemoHome({super.key});

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  final RollDrawerController _drawerController = RollDrawerController();
  final ScreenStackController _screenStackController = ScreenStackController();
  Widget _currentScreen = const HomeScreen();

  @override
  void initState() {
    super.initState();
    // Set initial screen with menu button
    final homeScreen = HomeScreen(onMenuTap: () => _drawerController.open());
    _currentScreen = homeScreen;
    // Add initial screen to stack with preview widget
    // _addCurrentScreenToStack('Home', Icons.home, Colors.blue, homeScreen);
  }

  void _addCurrentScreenToStack(
    String title,
    IconData icon,
    Color color,
    Widget screenWidget,
  ) {
    _screenStackController.pushScreen(
      ScreenPreview(
        title: title,
        icon: Icon(icon),
        color: color,
        previewWidget: screenWidget, // Pass the actual screen widget as preview
        onTap: () {
          _drawerController.close();
          _navigateToScreen(title);
        },
      ),
    );
  }

  void _navigateToScreen(String screenName) {
    Widget newScreen;
    IconData icon;
    Color color;

    switch (screenName) {
      case 'Home':
        newScreen = HomeScreen(onMenuTap: () => _drawerController.open());
        icon = Icons.home;
        color = Colors.blue;
        break;
      case 'Profile':
        newScreen = ProfileScreen(onMenuTap: () => _drawerController.open());
        icon = Icons.person;
        color = Colors.purple;
        break;
      case 'Settings':
        newScreen = SettingsScreen(onMenuTap: () => _drawerController.open());
        icon = Icons.settings;
        color = Colors.orange;
        break;
      case 'Messages':
        newScreen = MessagesScreen(onMenuTap: () => _drawerController.open());
        icon = Icons.message;
        color = Colors.green;
        break;
      case 'Notifications':
        newScreen = NotificationsScreen(
          onMenuTap: () => _drawerController.open(),
        );
        icon = Icons.notifications;
        color = Colors.red;
        break;
      case 'Favorites':
        newScreen = FavoritesScreen(onMenuTap: () => _drawerController.open());
        icon = Icons.favorite;
        color = Colors.pink;
        break;
      default:
        return;
    }

    setState(() {
      _currentScreen = newScreen;
    });

    // Add to stack with the actual screen widget as preview
    _addCurrentScreenToStack(screenName, icon, color, newScreen);
  }

  @override
  void dispose() {
    _drawerController.dispose();
    _screenStackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return RollDrawer(
      controller: _drawerController,
      screenStackController: _screenStackController,
      drawer: _buildDrawer(),
      drawerWidth: screenWidth - 40,
      animationDuration: const Duration(milliseconds: 600),
      drawerPadding: const EdgeInsets.only(left: 20),
      showScreenPreviews: true,
      maxScreenPreviews: 5,
      enableRollEffect: true,
      child: _currentScreen,
    );
  }

  Widget _buildDrawer() {
    return Material(
      color: Colors.deepPurple,
      child: SafeArea(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 60, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'MENU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.home,
                    title: 'Home',
                    onTap: () => _navigateToScreen('Home'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () => _navigateToScreen('Profile'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () => _navigateToScreen('Settings'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.message,
                    title: 'Messages',
                    badge: '3',
                    onTap: () => _navigateToScreen('Messages'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    badge: '12',
                    onTap: () => _navigateToScreen('Notifications'),
                  ),
                  _buildDrawerItem(
                    icon: Icons.favorite,
                    title: 'Favorites',
                    onTap: () => _navigateToScreen('Favorites'),
                  ),
                  const Divider(color: Colors.white24),
                  _buildDrawerItem(
                    icon: Icons.arrow_back,
                    title: 'Close Roll',
                    onTap: () => _drawerController.close(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    String? badge,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: () {
        _drawerController.close();
        onTap();
      },
    );
  }
}

// Demo Screens
class HomeScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const HomeScreen({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: onMenuTap),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Info card
            Card(
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 48,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap the menu icon (☰) to open the drawer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: onMenuTap,
                      icon: const Icon(Icons.menu),
                      label: const Text('Open Drawer'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'Welcome Home',
              icon: Icons.home,
              color: Colors.blue,
              children: [
                const ListTile(
                  leading: Icon(Icons.dashboard),
                  title: Text('Dashboard'),
                  subtitle: Text('View your overview'),
                ),
                const ListTile(
                  leading: Icon(Icons.trending_up),
                  title: Text('Analytics'),
                  subtitle: Text('Check your stats'),
                ),
                const ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('Calendar'),
                  subtitle: Text('Upcoming events'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'Quick Actions',
              icon: Icons.flash_on,
              color: Colors.orange,
              children: [
                const ListTile(
                  leading: Icon(Icons.add_circle),
                  title: Text('Create New'),
                  subtitle: Text('Start something new'),
                ),
                const ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Share'),
                  subtitle: Text('Share with others'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const ProfileScreen({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: onMenuTap),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple.shade50, Colors.purple.shade100],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.purple.shade700],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'John Doe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'john.doe@example.com',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildProfileItem(Icons.person, 'Personal Info'),
                    _buildProfileItem(Icons.work, 'Work Experience'),
                    _buildProfileItem(Icons.school, 'Education'),
                    _buildProfileItem(Icons.location_on, 'Location'),
                    _buildProfileItem(Icons.phone, 'Contact'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const SettingsScreen({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: onMenuTap),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange.shade50, Colors.orange.shade100],
          ),
        ),
        child: ListView(
          children: [
            _buildSettingsSection('General', [
              _buildSettingsItem(Icons.notifications, 'Notifications', true),
              _buildSettingsItem(Icons.dark_mode, 'Dark Mode', false),
              _buildSettingsItem(Icons.language, 'Language', null),
            ]),
            _buildSettingsSection('Privacy', [
              _buildSettingsItem(Icons.lock, 'Privacy Settings', null),
              _buildSettingsItem(Icons.security, 'Security', null),
              _buildSettingsItem(Icons.backup, 'Backup & Sync', true),
            ]),
            _buildSettingsSection('About', [
              _buildSettingsItem(
                Icons.info,
                'App Version',
                null,
                trailing: '1.0.0',
              ),
              _buildSettingsItem(Icons.help, 'Help & Support', null),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    bool? switchValue, {
    String? trailing,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title),
        trailing: switchValue != null
            ? Switch(value: switchValue, onChanged: (_) {})
            : trailing != null
            ? Text(trailing, style: const TextStyle(color: Colors.grey))
            : const Icon(Icons.chevron_right),
      ),
    );
  }
}

class MessagesScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const MessagesScreen({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: onMenuTap),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade50, Colors.green.shade100],
          ),
        ),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text('${index + 1}'),
                ),
                title: Text('Message from User ${index + 1}'),
                subtitle: const Text('Last message preview...'),
                trailing: index < 3
                    ? Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const NotificationsScreen({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: onMenuTap),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Mark all read',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red.shade50, Colors.red.shade100],
          ),
        ),
        child: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    index % 3 == 0
                        ? Icons.favorite
                        : index % 3 == 1
                        ? Icons.comment
                        : Icons.share,
                    color: Colors.white,
                  ),
                ),
                title: Text('Notification ${index + 1}'),
                subtitle: const Text('You have a new update'),
                trailing: index < 5
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const FavoritesScreen({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: onMenuTap),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink.shade50, Colors.pink.shade100],
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, size: 48, color: Colors.pink),
                  const SizedBox(height: 8),
                  Text(
                    'Favorite ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
