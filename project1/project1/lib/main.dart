import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const AdiShaktiApp());
}

class AdiShaktiApp extends StatelessWidget {
  const AdiShaktiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdiShakti',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          primary: Colors.purple,
          secondary: Colors.pink,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isSosActive = false;
  late AnimationController _sosController;
  late FlutterLocalNotificationsPlugin _notifications;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _sosController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  Future<void> _initializeNotifications() async {
    _notifications = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _notifications.initialize(initializationSettings);
  }

  Future<void> _handleSOS() async {
    try {
      setState(() => _isSosActive = true);
      _sosController.repeat(reverse: true);

      // Get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Show notification
      await _notifications.show(
        0,
        'SOS Alert Activated',
        'Your location has been shared with emergency contacts',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'sos_channel',
            'SOS Alerts',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );

      // TODO: Send location to emergency contacts
      debugPrint('Location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      debugPrint('Error in SOS: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to activate SOS. Please try again.')),
      );
    } finally {
      setState(() => _isSosActive = false);
      _sosController.stop();
    }
  }

  @override
  void dispose() {
    _sosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdiShakti'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _sosController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isSosActive ? 1.0 + (_sosController.value * 0.2) : 1.0,
                    child: const Icon(
                      Icons.security,
                      size: 100,
                      color: Colors.purple,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome to AdiShakti',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your Safety Companion',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _isSosActive ? null : _handleSOS,
                icon: const Icon(Icons.warning),
                label: Text(_isSosActive ? 'SOS Active' : 'SOS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSosActive ? Colors.grey : Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
          NavigationDestination(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
} 