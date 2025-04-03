import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedDifficulty = 'All';
  bool _isLoading = false;
  
  final List<String> _categories = [
    'All',
    'Lip Reading',
    'Pronunciation',
    'Speech Clarity',
    'Conversation',
  ];
  
  final List<String> _difficultyLevels = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];
  
  final List<Map<String, dynamic>> _exercises = [
    {
      'id': '1',
      'title': 'Lip Reading Practice',
      'description': 'Improve your ability to read lips with AI-assisted feedback using our enhanced model with improved hyperparameter tuning',
      'duration': '15 min',
      'difficulty': 'Beginner',
      'icon': Icons.face,
      'color': Colors.black,
      'category': 'Lip Reading',
      'modelFeatures': ['Hyperparameter Tuning', 'L2 Regularization']
    },
    {
      'id': '2',
      'title': 'Vowel Pronunciation',
      'description': 'Practice clear pronunciation of vowel sounds with class weight balancing for better accuracy',
      'duration': '10 min',
      'difficulty': 'Beginner',
      'icon': Icons.record_voice_over,
      'color': Colors.grey[800],
      'category': 'Pronunciation',
      'modelFeatures': ['Class Weight Balancing', 'PCA Visualization']
    },
    {
      'id': '3',
      'title': 'Consonant Sounds',
      'description': 'Master difficult consonant sounds with guided exercises using our enhanced model with L2 regularization',
      'duration': '12 min',
      'difficulty': 'Intermediate',
      'icon': Icons.mic,
      'color': Colors.black,
      'category': 'Pronunciation',
      'modelFeatures': ['L2 Regularization', 'Detailed Logging']
    },
    {
      'id': '4',
      'title': 'Sentence Formation',
      'description': 'Practice forming complete sentences with clarity using enhanced PCA application',
      'duration': '20 min',
      'difficulty': 'Advanced',
      'icon': Icons.chat_bubble_outline,
      'color': Colors.grey[800],
      'category': 'Speech Clarity',
      'modelFeatures': ['Enhanced PCA Application', 'Class Weight Balancing']
    },
    {
      'id': '5',
      'title': 'Speech Rhythm',
      'description': 'Improve the natural flow and rhythm of your speech using detailed analytics and reporting',
      'duration': '15 min',
      'difficulty': 'Intermediate',
      'icon': Icons.music_note,
      'color': Colors.black,
      'category': 'Speech Clarity',
      'modelFeatures': ['Detailed Logging', 'Model Comparison']
    },
    {
      'id': '6',
      'title': 'Voice Modulation',
      'description': 'Learn to control tone and volume with model comparison framework for optimal results',
      'duration': '15 min',
      'difficulty': 'Advanced',
      'icon': Icons.graphic_eq,
      'color': Colors.grey[800],
      'category': 'Speech Clarity',
      'modelFeatures': ['Model Comparison', 'Hyperparameter Tuning']
    },
    {
      'id': '7',
      'title': 'Basic Conversation',
      'description': 'Practice everyday conversational scenarios with PCA visualization for better understanding',
      'duration': '20 min',
      'difficulty': 'Beginner',
      'icon': Icons.people,
      'color': Colors.black,
      'category': 'Conversation',
      'modelFeatures': ['PCA Visualization', 'Detailed Logging']
    },
    {
      'id': '8',
      'title': 'Advanced Word Articulation',
      'description': 'Master difficult word pronunciations with our enhanced model components for optimal accuracy',
      'duration': '15 min',
      'difficulty': 'Advanced',
      'icon': Icons.text_fields,
      'color': Colors.grey[800],
      'category': 'Pronunciation',
      'modelFeatures': ['Optimal Component Selection', 'L2 Regularization']
    },
    {
      'id': '9',
      'title': 'Visual Speech Recognition',
      'description': 'Enhance visual recognition of speech patterns with our enhanced model using standardized PCA application',
      'duration': '15 min',
      'difficulty': 'Intermediate',
      'icon': Icons.visibility,
      'color': Colors.black,
      'category': 'Lip Reading',
      'modelFeatures': ['Enhanced PCA Application', 'Standardization']
    },
    {
      'id': '10',
      'title': 'Storytelling Practice',
      'description': 'Improve narrative skills and speech confidence with comprehensive analytics from our enhanced model',
      'duration': '25 min',
      'difficulty': 'Intermediate',
      'icon': Icons.book,
      'color': Colors.grey[800],
      'category': 'Conversation',
      'modelFeatures': ['Detailed Logging', 'PCA Visualization']
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _filterExercises() {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exercises',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          indicatorColor: Colors.white,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildFilterSection(),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.black))
              : TabBarView(
                  controller: _tabController,
                  children: _categories.map((category) {
                    // Filter exercises based on category and other filters
                    final filteredExercises = _exercises.where((ex) {
                      // If category is 'All', show all exercises
                      bool categoryMatch = category == 'All' || ex['category'] == category;
                      
                      // Filter by difficulty if selected
                      bool difficultyMatch = _selectedDifficulty == 'All' || 
                          ex['difficulty'] == _selectedDifficulty;
                      
                      // Filter by search query
                      bool searchMatch = _searchQuery.isEmpty || 
                          ex['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          ex['description'].toLowerCase().contains(_searchQuery.toLowerCase());
                      
                      return categoryMatch && difficultyMatch && searchMatch;
                    }).toList();
                    
                    return filteredExercises.isEmpty
                      ? Center(
                          child: Text(
                            'No exercises found',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: filteredExercises.length,
                          itemBuilder: (context, index) {
                            final exercise = filteredExercises[index];
                            return _buildExerciseCard(exercise);
                          },
                        );
                  }).toList(),
                ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search exercises...',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
          _filterExercises();
        });
      },
    );
  }
  
  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Difficulty Level',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _difficultyLevels.map((level) {
            final isSelected = _selectedDifficulty == level;
            return FilterChip(
              label: Text(level),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedDifficulty = level;
                  _filterExercises();
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.black,
              checkmarkColor: Colors.white,
              labelStyle: GoogleFonts.poppins(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/exercises/detail', arguments: exercise);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise header with color banner
            Container(
              color: exercise['color'],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    exercise['icon'],
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      exercise['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      exercise['duration'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Exercise content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise['description'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Model features section
                  if (exercise.containsKey('modelFeatures') && exercise['modelFeatures'] is List)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enhanced Model Features',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: (exercise['modelFeatures'] as List).map((feature) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[400]!),
                            ),
                            child: Text(
                              feature,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            ),
                          )).toList(),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(
                          exercise['difficulty'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        size: 20,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
