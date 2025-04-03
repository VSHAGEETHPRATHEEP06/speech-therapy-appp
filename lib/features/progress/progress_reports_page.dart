import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressReportsPage extends StatefulWidget {
  const ProgressReportsPage({super.key});

  @override
  _ProgressReportsPageState createState() => _ProgressReportsPageState();
}

class _ProgressReportsPageState extends State<ProgressReportsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Week';
  final List<String> _periods = ['Week', 'Month', '3 Months', 'Year'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Progress Reports',
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(),
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Sessions'),
            Tab(text: 'Metrics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildSessionsTab(),
          _buildMetricsTab(),
        ],
      ),
    );
  }
  
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period selector
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _periods.map((period) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: ChoiceChip(
                      label: Text(period),
                      selected: _selectedPeriod == period,
                      onSelected: (selected) {
                        setState(() {
                          _selectedPeriod = period;
                        });
                      },
                      labelStyle: GoogleFonts.poppins(
                        color: _selectedPeriod == period ? Colors.white : Colors.black,
                        fontSize: 13,
                      ),
                      selectedColor: Colors.black,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Summary cards
          Row(
            children: [
              _buildStatCard('Sessions', '24', Icons.event_note, Colors.black),
              const SizedBox(width: 16),
              _buildStatCard('Hours', '12.5', Icons.access_time, Colors.grey[800]!),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              _buildStatCard('Exercises', '86', Icons.fitness_center, Colors.grey[800]!),
              const SizedBox(width: 16),
              _buildStatCard('Accuracy', '78%', Icons.thumbs_up_down, Colors.black),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Progress chart
          Text(
            'Speech Accuracy Progress',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Container(
            height: 220,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildLineChart(),
          ),
          
          const SizedBox(height: 32),
          
          // Recent achievements
          Text(
            'Recent Achievements',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          _buildAchievementCard(
            'Consistency Champion',
            'Completed exercises for 7 consecutive days',
            Icons.emoji_events,
            Colors.amber,
          ),
          
          _buildAchievementCard(
            'Accuracy Milestone',
            'Reached 75% accuracy in vowel pronunciation',
            Icons.verified,
            Colors.blue,
          ),
          
          _buildAchievementCard(
            'Speech Master',
            'Completed all beginner level exercises',
            Icons.star,
            Colors.green,
          ),
          
          const SizedBox(height: 24),
          
          // Create report button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/progress/create');
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'CREATE DETAILED REPORT',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSessionsTab() {
    final List<Map<String, dynamic>> sessions = [
      {
        'date': 'April 3, 2025',
        'title': 'Lip Reading Practice',
        'duration': '15 min',
        'accuracy': 82,
      },
      {
        'date': 'April 1, 2025',
        'title': 'Vowel Pronunciation',
        'duration': '10 min',
        'accuracy': 75,
      },
      {
        'date': 'March 29, 2025',
        'title': 'Consonant Sounds',
        'duration': '12 min',
        'accuracy': 68,
      },
      {
        'date': 'March 27, 2025',
        'title': 'Sentence Formation',
        'duration': '20 min',
        'accuracy': 72,
      },
      {
        'date': 'March 25, 2025',
        'title': 'Speech Rhythm',
        'duration': '15 min',
        'accuracy': 70,
      },
    ];
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/progress/report/detail', arguments: session);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Session date
                  Text(
                    session['date'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Session title
                  Text(
                    session['title'],
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Session details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Duration
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            session['duration'],
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      
                      // Accuracy
                      Row(
                        children: [
                          const Text(
                            'Accuracy: ',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${session['accuracy']}%',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _getAccuracyColor(session['accuracy']),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildMetricsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Metrics',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Overall Accuracy
          _buildMetricCard(
            'Overall Accuracy',
            '78%',
            'Improved by 12% in the last month',
            Icons.speed,
            Colors.green,
            _buildSimpleProgressBar(0.78),
          ),
          
          // Practice Consistency
          _buildMetricCard(
            'Practice Consistency',
            '85%',
            '5 out of 7 days this week',
            Icons.calendar_today,
            Colors.blue,
            _buildSimpleProgressBar(0.85),
          ),
          
          // Speech Clarity
          _buildMetricCard(
            'Speech Clarity',
            '72%',
            'Improved by 8% since baseline',
            Icons.record_voice_over,
            Colors.orange,
            _buildSimpleProgressBar(0.72),
          ),
          
          // Vowel Pronunciation
          _buildMetricCard(
            'Vowel Pronunciation',
            '81%',
            'Strongest area of performance',
            Icons.mic,
            Colors.green,
            _buildSimpleProgressBar(0.81),
          ),
          
          // Consonant Pronunciation
          _buildMetricCard(
            'Consonant Pronunciation',
            '65%',
            'Area for improvement',
            Icons.mic_none,
            Colors.red,
            _buildSimpleProgressBar(0.65),
          ),
          
          const SizedBox(height: 24),
          
          // Share button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Report sharing will be available in a future update'),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.share, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'SHARE PROGRESS REPORT',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
  
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAchievementCard(String title, String description, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMetricCard(String title, String value, String subtitle, IconData icon, Color color, Widget progressIndicator) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            progressIndicator,
          ],
        ),
      ),
    );
  }
  
  Widget _buildSimpleProgressBar(double progress) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getProgressColor(progress),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[300],
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                const labels = ['Week 1', 'Week 2', 'Week 3', 'Now'];
                if (value.toInt() >= 0 && value.toInt() < labels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      labels[value.toInt()],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 3,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 55),
              FlSpot(1, 62),
              FlSpot(2, 70),
              FlSpot(3, 78),
            ],
            isCurved: true,
            color: Colors.black,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.black,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getAccuracyColor(int accuracy) {
    if (accuracy >= 80) {
      return Colors.green;
    } else if (accuracy >= 70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
  
  Color _getProgressColor(double progress) {
    if (progress >= 0.8) {
      return Colors.green;
    } else if (progress >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
