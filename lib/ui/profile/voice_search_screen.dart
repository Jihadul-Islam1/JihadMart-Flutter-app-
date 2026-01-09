import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceSearchScreen extends StatefulWidget {
  const VoiceSearchScreen({super.key});

  @override
  State<VoiceSearchScreen> createState() => _VoiceSearchScreenState();
}

class _VoiceSearchScreenState extends State<VoiceSearchScreen>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  String _searchQuery = '';
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> _recentSearches = [
    'Nike Air Max',
    'iPhone 15 Pro',
    'Samsung TV',
    'Laptop bag',
  ];

  final List<String> _suggestedQueriesEnglish = [
    'Show cheap smartphones',
    'Find Nike shoes',
    'Samsung TV offers',
    'Watches under 5000',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      _isListening = true;
      _searchQuery = '';
    });
    _animationController.repeat(reverse: true);

    // Simulate voice recognition
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _searchQuery = 'Show Nike shoes';
          _isListening = false;
        });
        _animationController.stop();
        _animationController.reset();

        // Navigate to results
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pop(context, _searchQuery);
          }
        });
      }
    });
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _animationController.stop();
    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Voice Search 🎤'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Microphone Button
                  GestureDetector(
                    onTap: _isListening ? _stopListening : _startListening,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Container(
                          width:
                              (_isListening ? 140 * _animation.value : 140).w,
                          height:
                              (_isListening ? 140 * _animation.value : 140).h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isListening
                                ? Colors.red
                                : Colors.deepOrange,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (_isListening
                                            ? Colors.red
                                            : Colors.deepOrange)
                                        .withAlpha(100),
                                blurRadius: _isListening ? 30 : 15,
                                spreadRadius: _isListening ? 10 : 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            size: 60.sp,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // Status Text
                  Text(
                    _isListening
                        ? 'Listening...'
                        : _searchQuery.isNotEmpty
                        ? _searchQuery
                        : 'Tap the microphone',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: _isListening ? Colors.red : Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    _isListening ? 'Say your product...' : 'Speak in English',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),

                  // Waveform Animation
                  if (_isListening)
                    Container(
                      margin: EdgeInsets.only(top: 30.h),
                      height: 50.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(15, (index) {
                          return _buildWaveBar(index);
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Recent Searches
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(50),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _recentSearches.map((search) {
                    return GestureDetector(
                      onTap: () => Navigator.pop(context, search),
                      child: Chip(
                        label: Text(search),
                        avatar: Icon(Icons.history, size: 16.sp),
                        backgroundColor: Colors.grey.shade100,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Try Saying',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                ..._suggestedQueriesEnglish.map((query) {
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.record_voice_over,
                      color: Colors.deepOrange,
                    ),
                    title: Text(query),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14.sp),
                    onTap: () => Navigator.pop(context, query),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveBar(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 10, end: 40),
      duration: Duration(milliseconds: 300 + (index * 50)),
      builder: (context, value, child) {
        return Container(
          width: 4.w,
          height: value.h,
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            color: Colors.deepOrange.withAlpha((255 * (value / 40)).toInt()),
            borderRadius: BorderRadius.circular(2.r),
          ),
        );
      },
    );
  }
}
