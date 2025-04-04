import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeInOut),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeInOut),
      ),
    );
    
    _animationController.forward();
    
    // Navigate to the appropriate screen after delay
    Timer(const Duration(seconds: 3), () => _checkLoginStatus());
  }
  
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    if (mounted) {
      Navigator.pushReplacementNamed(
        context, 
        isLoggedIn ? '/home' : '/',
      );
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animation
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: child,
                  ),
                );
              },
              child: _buildLogo(),
            ),
            
            const SizedBox(height: 40),
            
            // Custom loading animation
            _buildLoadingAnimation(),
            
            const SizedBox(height: 24),
            
            // App name
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: child,
                );
              },
              child: Text(
                'Speech Therapy',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Tagline
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: child,
                );
              },
              child: Text(
                'Enhanced Lip Reading with AI',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLogo() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Mouth shape
            Container(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            
            // Sound wave lines
            Positioned(
              top: 42,
              child: SizedBox(
                width: 80,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    5,
                    (index) => Container(
                      width: 8,
                      height: 10 + (index % 3) * 10.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoadingAnimation() {
    return SizedBox(
      width: 120,
      height: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _buildDot(index),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Create a delayed animation for each dot
        final double delayedValue = (_animationController.value - (index * 0.2)).clamp(0.0, 1.0);
        
        // Create a pulsing effect
        final double size = 10 + 5 * delayedValue * (1 - delayedValue) * 4;
        
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
