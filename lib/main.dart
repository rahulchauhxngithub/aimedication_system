import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'mongo_dart/mongodb_service.dart'; // Import MongoDB service
import 'screens/login_screen.dart'; // Import the login screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Connect to MongoDB before running the app
  await MongoDBService.connect();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DAAC SAAB',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: LoginScreen(), // Load the Login Page first
    );
  }
}


// Main Dashboard Screen
class MedicationDashboard extends StatefulWidget {
  const MedicationDashboard({super.key});

  @override
  State<MedicationDashboard> createState() => _MedicationDashboardState();
}

class _MedicationDashboardState extends State<MedicationDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MedicationsScreen(),
    const AIRecommendationsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('DAAC SAAB'),

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Open notifications
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Medications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'AI Assist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Home Screen with Today's Schedule
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for today's medications
    final todayMeds = [
      {'name': 'Aspirin', 'dosage': '81mg', 'time': '8:00 AM', 'taken': true},
      {'name': 'Lisinopril', 'dosage': '10mg', 'time': '8:00 AM', 'taken': true},
      {'name': 'Metformin', 'dosage': '500mg', 'time': '12:00 PM', 'taken': false},
      {'name': 'Atorvastatin', 'dosage': '20mg', 'time': '8:00 PM', 'taken': false},
      {'name': 'Lopramide', 'dosage': '10mg', 'time': '9:00 PM', 'taken': true},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome and quick stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hi Jethalal..!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Today', '4 meds'),
                      _buildStatColumn('Adherence', '92%'),
                      _buildStatColumn('Refills', '2 needed'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Today's medications
          const Text(
            'Today\'s Medications',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // List of today's medications
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: todayMeds.length,
            itemBuilder: (context, index) {
              final med = todayMeds[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: med['taken'] == true
                        ? Colors.green
                        : Theme.of(context).colorScheme.primary,
                    child: Icon(
                      med['taken'] == true ? Icons.check : Icons.access_time,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(med['name'] as String),
                  subtitle: Text('${med['dosage']} at ${med['time']}'),
                  trailing: med['taken'] == true
                      ? const Text('Taken')
                      : ElevatedButton(
                    onPressed: () {
                      // Mark as taken functionality
                    },
                    child: const Text('Take'),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // AI Insights Card
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline),
                      const SizedBox(width: 8),
                      const Text(
                        'AI Insights',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Based on your recent blood pressure readings, your medication seems to be working effectively. Continue monitoring and taking as prescribed.',
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // View more details
                      },
                      child: const Text('Learn More'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Medications Screen - List and Management
class MedicationsScreen extends StatelessWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock medication data
    final medications = [
      {
        'name': 'Aspirin',
        'dosage': '81mg',
        'frequency': 'Once daily',
        'purpose': 'Heart health',
        'refills': 3,
      },
      {
        'name': 'Lisinopril',
        'dosage': '10mg',
        'frequency': 'Once daily',
        'purpose': 'Blood pressure',
        'refills': 1,
      },
      {
        'name': 'Metformin',
        'dosage': '500mg',
        'frequency': 'Twice daily',
        'purpose': 'Diabetes management',
        'refills': 2,
      },
      {
        'name': 'Atorvastatin',
        'dosage': '20mg',
        'frequency': 'Once daily at night',
        'purpose': 'Cholesterol',
        'refills': 0,
      },
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Medications',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Search functionality
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: medications.length,
                itemBuilder: (context, index) {
                  final med = medications[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      title: Text(med['name'] as String),
                      subtitle: Text('${med['dosage']} - ${med['frequency']}'),
                      leading: const CircleAvatar(
                        child: Icon(Icons.medication),
                      ),
                      trailing: med['refills'] == 0
                          ? Chip(
                        label: const Text('Refill needed'),
                        backgroundColor: Colors.red[100],
                      )
                          : null,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Purpose: ${med['purpose']}'),
                              const SizedBox(height: 8),
                              Text('Refills remaining: ${med['refills']}'),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      // Edit medication
                                    },
                                    child: const Text('Edit'),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: () {
                                      // Request refill
                                    },
                                    child: const Text('Request Refill'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new medication
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// AI Recommendations Screen
class AIRecommendationsScreen extends StatelessWidget {
  const AIRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Health Assistant',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // AI Input Field
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Ask about your medications, symptoms, or health concerns',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'E.g., Can I take aspirin with my current medications?',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          // Send query to AI
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Recent Insights',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: ListView(
              children: [
                _buildInsightCard(
                  context,
                  title: 'Potential Interaction Detected',
                  content: 'Your new supplement (Vitamin K) may interfere with Warfarin. Consider discussing with your healthcare provider.',
                  icon: Icons.warning_amber_rounded,
                  color: Colors.orange,
                ),
                _buildInsightCard(
                  context,
                  title: 'Medication Timing Optimization',
                  content: 'Taking your blood pressure medication before bedtime may improve its effectiveness, based on recent studies.',
                  icon: Icons.schedule,
                  color: Colors.blue,
                ),
                _buildInsightCard(
                  context,
                  title: 'Adherence Pattern',
                  content: 'You\'ve been consistently taking your evening medication 1-2 hours late. Setting a reminder might help maintain a more consistent schedule.',
                  icon: Icons.insights,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
      BuildContext context, {
        required String title,
        required String content,
        required IconData icon,
        required Color color,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(content),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // More details
                  },
                  child: const Text('Learn More'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Text(
                  'A',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Alex Johnson',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: 12345678',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Health information section
          const Text(
            'Health Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            'Basic Information',
            [
              {'label': 'Age', 'value': '52'},
              {'label': 'Height', 'value': '5\'10"'},
              {'label': 'Weight', 'value': '180 lbs'},
              {'label': 'Blood Type', 'value': 'O+'},
            ],
          ),

          const SizedBox(height: 16),
          _buildInfoCard(
            'Health Conditions',
            [
              {'label': 'Hypertension', 'value': 'Since 2018'},
              {'label': 'Type 2 Diabetes', 'value': 'Since 2020'},
              {'label': 'High Cholesterol', 'value': 'Since 2019'},
            ],
          ),

          const SizedBox(height: 16),
          _buildInfoCard(
            'Allergies',
            [
              {'label': 'Penicillin', 'value': 'Severe'},
              {'label': 'Shellfish', 'value': 'Moderate'},
            ],
          ),

          const SizedBox(height: 24),

          // Healthcare provider section
          const Text(
            'Healthcare Providers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Primary Care Physician',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Dr. Sarah Williams'),
                  const Text('Oakwood Medical Center'),
                  const Text('Phone: (555) 123-4567'),
                  const SizedBox(height: 16),

                  const Text(
                    'Cardiologist',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Dr. Robert Chen'),
                  const Text('Heart Health Specialists'),
                  const Text('Phone: (555) 987-6543'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Settings section
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('App Settings'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to settings
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notification Preferences'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to notification settings
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Privacy & Security'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to privacy settings
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to help
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Map<String, String>> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['label'] ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(item['value'] ?? ''),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// Notifications Screen
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Medication Reminder',
        'body': 'Time to take Metformin (500mg)',
        'time': '10 minutes ago',
        'icon': Icons.medication,
      },
      {
        'title': 'Refill Alert',
        'body': 'Your Atorvastatin prescription needs to be refilled',
        'time': '2 hours ago',
        'icon': Icons.warning,
      },
      {
        'title': 'AI Health Tip',
        'body': 'Taking your blood pressure medication at night may be more effective',
        'time': 'Yesterday',
        'icon': Icons.lightbulb_outline,
      },
      {
        'title': 'Health Check Reminder',
        'body': 'Your quarterly check-up is scheduled for next Monday',
        'time': '2 days ago',
        'icon': Icons.calendar_today,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: notifications.isEmpty
          ? const Center(
        child: Text('No notifications yet'),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(notification['icon'] as IconData),
              ),
              title: Text(notification['title'] as String),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification['body'] as String),
                  const SizedBox(height: 4),
                  Text(
                    notification['time'] as String,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}