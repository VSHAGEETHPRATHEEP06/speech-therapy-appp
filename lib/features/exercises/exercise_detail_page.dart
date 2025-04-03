import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class ExerciseDetailPage extends StatefulWidget {
  const ExerciseDetailPage({super.key});

  @override
  _ExerciseDetailPageState createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  bool _isProcessing = false;
  bool _exerciseCompleted = false;
  
  int _currentRepetition = 0;
  final int _totalRepetitions = 5;
  
  double _accuracy = 0.0;
  late Timer _timer;
  int _seconds = 0;
  
  late TabController _tabController;
  final List<String> _tabs = ['Instructions', 'Exercise', 'Results'];
  
  // Mock model performance data for visualization
  final Map<String, double> _modelPerformanceMetrics = {
    'Accuracy': 85.7,
    'Precision': 82.3,
    'Recall': 78.9,
    'F1 Score': 80.6,
  };
  
  final List<Map<String, dynamic>> _modelImprovements = [
    {
      'feature': 'Hyperparameter Tuning',
      'description': 'Configurable architecture for optimal performance',
      'improvement': '+15.2%',
      'icon': Icons.tune,
    },
    {
      'feature': 'L2 Regularization',
      'description': 'Prevents overfitting for better generalization',
      'improvement': '+8.7%',
      'icon': Icons.security,
    },
    {
      'feature': 'Enhanced PCA',
      'description': 'Standardization and optimal component selection',
      'improvement': '+12.4%',
      'icon': Icons.auto_awesome,
    },
    {
      'feature': 'Class Weight Balancing',
      'description': 'Improved performance on imbalanced datasets',
      'improvement': '+9.3%',
      'icon': Icons.balance,
    },
    {
      'feature': 'Model Comparison',
      'description': 'Compare multiple configurations for best results',
      'improvement': '+7.6%',
      'icon': Icons.analytics,
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    if (_isRecording) {
      _stopRecording();
    }
    super.dispose();
  }
  
  void _startExercise() {
    setState(() {
      _isRecording = true;
      _seconds = 0;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
    
    // Simulate recording for 5 seconds, then stop
    Future.delayed(const Duration(seconds: 5), () {
      if (_isRecording && mounted) {
        _stopRecording();
      }
    });
  }
  
  void _stopRecording() {
    setState(() {
      _isRecording = false;
      _isProcessing = true;
    });
    
    _timer.cancel();
    
    // Simulate processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
        _currentRepetition++;
        _accuracy = 65 + _currentRepetition * 5.0; // Simulate improving accuracy
        
        if (_currentRepetition >= _totalRepetitions) {
          _exerciseCompleted = true;
          _showResults();
        }
      });
    });
  }
  
  void _showResults() {
    if (_exerciseCompleted) {
      _tabController.animateTo(2); // Switch to Results tab
    }
  }
  
  void _resetExercise() {
    setState(() {
      _currentRepetition = 0;
      _exerciseCompleted = false;
      _accuracy = 0.0;
    });
    _tabController.animateTo(0); // Switch back to Instructions tab
  }
  
  @override
  Widget build(BuildContext context) {
    // Get the exercise data passed as argument
    final exercise = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          exercise['title'],
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: _isRecording ? const NeverScrollableScrollPhysics() : null,
        children: [
          _buildInstructionsTab(exercise),
          _buildExerciseTab(exercise),
          _buildResultsTab(exercise),
        ],
      ),
    );
  }
  
  Widget _buildInstructionsTab(Map<String, dynamic> exercise) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: exercise['color'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  exercise['icon'],
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(width: 16),
              // Exercise info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${exercise['duration']} • ${exercise['difficulty']}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        exercise['category'],
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Description
          Text(
            'Description',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            exercise['description'],
            style: GoogleFonts.poppins(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          
          // Instructions
          Text(
            'Instructions',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          _buildInstructionStep(
            1, 
            'Review the exercise details and understand what is required.',
            Icons.info_outline,
          ),
          _buildInstructionStep(
            2, 
            'Press "Start Exercise" when ready to begin the recording.',
            Icons.mic,
          ),
          _buildInstructionStep(
            3, 
            'Complete 5 repetitions to get the best results from our enhanced model.',
            Icons.repeat,
          ),
          _buildInstructionStep(
            4, 
            'Review your results and detailed feedback from our AI analysis.',
            Icons.analytics,
          ),
          
          const SizedBox(height: 24),
          
          // Model improvements section
          Text(
            'Enhanced Model Features',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Column(
            children: _modelImprovements.map((improvement) => _buildModelFeatureItem(improvement)).toList(),
          ),
          
          const SizedBox(height: 40),
          // Start exercise button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _tabController.animateTo(1); // Switch to Exercise tab
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Start Exercise',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInstructionStep(int step, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildModelFeatureItem(Map<String, dynamic> improvement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                improvement['icon'],
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    improvement['feature'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    improvement['description'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                improvement['improvement'],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildExerciseTab(Map<String, dynamic> exercise) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          Center(
            child: SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: _currentRepetition / _totalRepetitions,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_currentRepetition/$_totalRepetitions',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Repetitions',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          
          // Recording status and instructions
          Center(
            child: Text(
              _isRecording
                  ? 'Recording in progress...'
                  : _isProcessing
                      ? 'Processing...'
                      : _exerciseCompleted
                          ? 'Exercise completed!'
                          : 'Press the microphone button to start',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Center(
            child: Text(
              _isRecording
                  ? 'Speak clearly into your microphone'
                  : _isProcessing
                      ? 'Our enhanced model is analyzing your speech'
                      : _exerciseCompleted
                          ? 'View your detailed results'
                          : 'Complete $_totalRepetitions repetitions',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 40),
          
          // Recording button
          Center(
            child: GestureDetector(
              onTap: _isRecording || _isProcessing || _exerciseCompleted
                  ? null
                  : _startExercise,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isRecording ? 80 : 100,
                height: _isRecording ? 80 : 100,
                decoration: BoxDecoration(
                  color: _isRecording
                      ? Colors.red
                      : _isProcessing
                          ? Colors.grey
                          : _exerciseCompleted
                              ? Colors.green
                              : Colors.black,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _isRecording
                        ? Icons.stop
                        : _isProcessing
                            ? Icons.hourglass_top
                            : _exerciseCompleted
                                ? Icons.check
                                : Icons.mic,
                    color: Colors.white,
                    size: _isRecording ? 36 : 40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          
          // Timer display (only when recording)
          if (_isRecording)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Recording: ${_seconds}s',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            
          // Results navigation button (only when completed)
          if (_exerciseCompleted)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showResults,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'View Results',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            
          // Restart button (only when recording is active or completed)
          if (_currentRepetition > 0 && !_isRecording && !_isProcessing)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _resetExercise,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Restart Exercise',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildResultsTab(Map<String, dynamic> exercise) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall score
          Center(
            child: Column(
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircularProgressIndicator(
                          value: _accuracy / 100,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _accuracy >= 80 ? Colors.green[700]! :
                            _accuracy >= 60 ? Colors.orange : Colors.red,
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_accuracy.toStringAsFixed(1)}%',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Accuracy',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _accuracy >= 80 ? 'Excellent!' :
                  _accuracy >= 60 ? 'Good progress' : 'Needs practice',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _accuracy >= 80 ? Colors.green[700] :
                          _accuracy >= 60 ? Colors.orange : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          // Model performance metrics
          Text(
            'Enhanced Model Performance',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Metrics visualization
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: _modelPerformanceMetrics.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${entry.value}%',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: entry.value / 100,
                          minHeight: 8,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          
          // Detailed feedback
          Text(
            'Detailed Feedback',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeedbackItem(
                  'Pronunciation',
                  'Your pronunciation is clear and articulate.',
                  8.5,
                ),
                const Divider(),
                _buildFeedbackItem(
                  'Rhythm',
                  'Maintain consistent pacing for better flow.',
                  6.8,
                ),
                const Divider(),
                _buildFeedbackItem(
                  'Clarity',
                  'Speech is clear and intelligible. Keep up the good work!',
                  9.0,
                ),
                const Divider(),
                _buildFeedbackItem(
                  'Volume',
                  'Good volume level that is easily audible.',
                  7.5,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _resetExercise();
                    _tabController.animateTo(1); // Back to Exercise tab
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Try Again',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Back to Exercises',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeedbackItem(String title, String description, double score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: score >= 8 ? Colors.green[100] :
                    score >= 6 ? Colors.orange[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                score.toStringAsFixed(1),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: score >= 8 ? Colors.green[800] :
                        score >= 6 ? Colors.orange[800] : Colors.red[800],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
