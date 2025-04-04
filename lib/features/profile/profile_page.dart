import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = 'Thusha';
  String email = 'thusha@example.com';
  bool notificationsEnabled = true;
  String selectedLanguage = 'English';
  bool isDarkMode = false;
  
  // Mock user statistics
  final int completedExercises = 27;
  final int totalSessions = 12;
  final double averageAccuracy = 78.5;
  final List<double> weeklyAccuracy = [65, 70, 68, 72, 75, 77, 78.5];
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Thusha';
      email = prefs.getString('email') ?? 'thusha@example.com';
      notificationsEnabled = prefs.getBool('notifications') ?? true;
      selectedLanguage = prefs.getString('language') ?? 'English';
      isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }
  
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setBool('notifications', notificationsEnabled);
    await prefs.setString('language', selectedLanguage);
    await prefs.setBool('darkMode', isDarkMode);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved'),
        backgroundColor: Colors.black,
      ),
    );
  }
  
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    username,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    email,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // User Statistics
            _buildSectionHeader('Your Progress'),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Exercises', '$completedExercises', Icons.fitness_center),
                _buildStatCard('Sessions', '$totalSessions', Icons.calendar_today),
                _buildStatCard('Accuracy', '${averageAccuracy.toStringAsFixed(1)}%', Icons.timeline),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Weekly Progress Chart
            _buildSectionHeader('Weekly Accuracy'),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              days[value.toInt() % days.length],
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              value.toInt().toString(),
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  minX: 0,
                  maxX: 6,
                  minY: 60,
                  maxY: 85,
                  lineBarsData: [
                    LineChartBarData(
                      spots: weeklyAccuracy.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value);
                      }).toList(),
                      isCurved: true,
                      color: Colors.black,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Settings
            _buildSectionHeader('App Settings'),
            const SizedBox(height: 16),
            
            Card(
              elevation: 2,
              child: Column(
                children: [
                  _buildSettingsSwitch(
                    'Notifications',
                    'Receive reminders and updates',
                    notificationsEnabled,
                    (value) {
                      setState(() {
                        notificationsEnabled = value;
                      });
                    },
                  ),
                  const Divider(),
                  _buildLanguageSelector(),
                  const Divider(),
                  _buildSettingsSwitch(
                    'Dark Mode',
                    'Use dark theme (coming soon)',
                    isDarkMode,
                    (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            

            
            Center(
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('SAVE SETTINGS'),
              ),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettingsSwitch(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.black,
      ),
    );
  }
  
  Widget _buildLanguageSelector() {
    return ListTile(
      title: Text(
        'Language',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Change app language',
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: DropdownButton<String>(
        value: selectedLanguage,
        elevation: 16,
        underline: Container(
          height: 0,
        ),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectedLanguage = newValue;
            });
          }
        },
        items: <String>['English', 'Tamil', 'Sinhala']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildFeatureCard(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          description,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
