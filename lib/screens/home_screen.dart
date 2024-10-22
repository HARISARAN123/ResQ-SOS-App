import 'package:flutter/material.dart';
import 'package:resq_ai/services/fall_detection.service.dart';
import 'package:resq_ai/widgets/quick_action_card.dart';
import 'package:resq_ai/widgets/sos_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FallDetectionService _fallDetectionService = FallDetectionService();
  String _name = '';

  @override
  void initState() {
    super.initState();
    _fallDetectionService.startFallDetection();
    _fallDetectionService.setFallDetectionCallback(_handleFallDetection);
    _loadName();
  }

  @override
  void dispose() {
    _fallDetectionService.stopFallDetection();
    super.dispose();
  }

  Future<void> _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
    });
  }

  void _handleFallDetection(bool isFallDetected) {
    if (isFallDetected) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Fall Detected'),
          content: const Text('Are you okay? Do you need assistance?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('I\'m okay'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Call for help'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ResQ SOS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome, $_name!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              const SOSButton(),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    QuickActionCard(
                      icon: Icons.contact_phone,
                      title: 'Contacts',
                      color: Colors.blue,
                      onTap: () => Navigator.pushNamed(context, '/contacts'),
                    ),
                    QuickActionCard(
                      icon: Icons.medical_services,
                      title: 'Medical Info',
                      color: Colors.green,
                      onTap: () => Navigator.pushNamed(context, '/medical_info'),
                    ),
                    QuickActionCard(
                      icon: Icons.location_on,
                      title: 'Safe Locations',
                      color: Colors.orange,
                      onTap: () => Navigator.pushNamed(context, '/safe_locations'),
                    ),
                    QuickActionCard(
                      icon: Icons.block,
                      title: 'Blog Post',
                      color: Colors.red,
                      onTap: () => Navigator.pushNamed(context, '/blog_post'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}