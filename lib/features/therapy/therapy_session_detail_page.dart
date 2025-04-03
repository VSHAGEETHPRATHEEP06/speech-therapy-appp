import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class TherapySessionDetailPage extends StatefulWidget {
  const TherapySessionDetailPage({super.key});

  @override
  _TherapySessionDetailPageState createState() => _TherapySessionDetailPageState();
}

class _TherapySessionDetailPageState extends State<TherapySessionDetailPage> {
  bool _isSessionActive = false;
  String _feedback = '';
  int _accuracy = 0;
  int _currentStep = 0;
  final List<String> _exercises = [
    'Say "Hello" clearly',
    'Practice "Th" sound with "Thank you"',
    'Say "Red lorry, yellow lorry"',
    'Count from one to five',
    'Say "She sells seashells by the seashore"'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Therapy Session',
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: _currentStep / _exercises.length,
            backgroundColor: Colors.grey[300],
            color: Colors.black,
            minHeight: 6,
          ),
          
          Expanded(
            child: _isSessionActive
                ? _buildActiveSession()
                : _buildSessionPreparation(),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionPreparation() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 180,
            child: Lottie.network(
              'https://assets10.lottiefiles.com/packages/lf20_aakdvuuf.json',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Lip Reading Session',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'This session will help improve your lip reading skills using our enhanced model with L2 regularization and improved PCA application.',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Setup instructions
          _buildInstructionCard(
            'Find a quiet environment',
            'Minimize background noise for best results',
            Icons.volume_off,
          ),
          
          _buildInstructionCard(
            'Good lighting',
            'Ensure your face is well-lit for the camera',
            Icons.wb_sunny,
          ),
          
          _buildInstructionCard(
            'Position camera at eye level',
            'Camera should clearly see your face',
            Icons.videocam,
          ),
          
          const SizedBox(height: 32),
          
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isSessionActive = true;
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.black,
            ),
            child: Text(
              'START SESSION',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSession() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise info
          Text(
            'Exercise ${_currentStep + 1} of ${_exercises.length}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _exercises[_currentStep],
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Camera preview (mockup)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Camera Preview',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[400],
                    ),
                  ),
                  Text(
                    'Please position your face in the frame',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Feedback area
          if (_feedback.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _accuracy >= 75 ? Colors.green : Colors.orange,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Feedback',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getAccuracyColor(_accuracy),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Accuracy: $_accuracy%',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _feedback,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          
          // Control buttons
          Row(
            children: [
              // Record button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Simulate recording and analysis
                    _simulateRecording();
                  },
                  icon: const Icon(Icons.mic),
                  label: Text(
                    'RECORD',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Next button
              OutlinedButton(
                onPressed: _feedback.isEmpty
                    ? null
                    : () {
                        setState(() {
                          if (_currentStep < _exercises.length - 1) {
                            _currentStep++;
                            _feedback = '';
                          } else {
                            // End of session
                            Navigator.pushReplacementNamed(
                              context,
                              '/progress/report/detail',
                              arguments: {
                                'date': 'April 3, 2025',
                                'title': 'Lip Reading Practice',
                                'duration': '15 min',
                                'accuracy': 82,
                              },
                            );
                          }
                        });
                      },
                child: Text(
                  _currentStep < _exercises.length - 1 ? 'NEXT' : 'FINISH',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  side: BorderSide(color: _feedback.isEmpty ? Colors.grey[300]! : Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  void _simulateRecording() {
    // Show recording indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recording...'),
        duration: Duration(seconds: 1),
      ),
    );
    
    // Simulate processing delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          // Generate random accuracy between 65 and 95
          _accuracy = 65 + (DateTime.now().millisecondsSinceEpoch % 30);
          
          // Provide feedback based on accuracy
          if (_accuracy >= 85) {
            _feedback = 'Excellent! Your pronunciation was very clear and accurate.';
          } else if (_accuracy >= 75) {
            _feedback = 'Good job! Your pronunciation was mostly clear with minor issues.';
          } else {
            _feedback = 'Try again with clearer articulation, focusing on lip movement.';
          }
        });
      }
    });
  }
  
  Widget _buildInstructionCard(String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.black),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
  
  Color _getAccuracyColor(int accuracy) {
    if (accuracy >= 80) {
      return Colors.green[700]!;
    } else if (accuracy >= 65) {
      return Colors.orange[700]!;
    } else {
      return Colors.red[700]!;
    }
  }
}
