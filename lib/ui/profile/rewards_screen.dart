import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/gamification_service.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
      appBar: AppBar(
        title: const Text('রিওয়ার্ডস 🎮'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'প্রোফাইল'),
            Tab(text: 'চ্যালেঞ্জ'),
            Tab(text: 'লিডারবোর্ড'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProfileTab(),
          _buildChallengesTab(),
          _buildLeaderboardTab(),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    final levelInfo = GamificationService.getCurrentLevelInfo();
    final progress = GamificationService.getProgressToNextLevel();
    final achievements = GamificationService.getAchievements();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Level Card
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade700,
                  Colors.deepPurple.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                // Level Badge
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      levelInfo['badge'] as String,
                      style: TextStyle(fontSize: 48.sp),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Level ${GamificationService.getLevel()}',
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
                Text(
                  levelInfo['name'] as String,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),

                // Progress Bar
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${GamificationService.getCurrentXP()} XP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          '${GamificationService.getXPToNextLevel()} XP',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12.h,
                        backgroundColor: Colors.white30,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      '🔥 স্ট্রিক',
                      '${GamificationService.getStreak()} দিন',
                    ),
                    Container(width: 1, height: 40.h, color: Colors.white30),
                    _buildStatItem(
                      '💰 কয়েন',
                      '${GamificationService.getCoins()}',
                    ),
                    Container(width: 1, height: 40.h, color: Colors.white30),
                    _buildStatItem(
                      '🏆 অ্যাচিভমেন্ট',
                      '${GamificationService.getUnlockedAchievements().length}',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Achievements Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'অ্যাচিভমেন্টস',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text('সব দেখুন')),
              ],
            ),
          ),
          SizedBox(height: 8.h),

          ...achievements
              .take(4)
              .map(
                (achievement) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: achievement['unlocked'] == true
                        ? Colors.deepPurple.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: achievement['unlocked'] == true
                          ? Colors.deepPurple.shade200
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color: achievement['unlocked'] == true
                              ? Colors.amber.shade100
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            achievement['icon'] as String,
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: achievement['unlocked'] == true
                                  ? null
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  achievement['name'] as String,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: achievement['unlocked'] == true
                                        ? Colors.black87
                                        : Colors.grey,
                                  ),
                                ),
                                if (achievement['unlocked'] == true) ...[
                                  SizedBox(width: 8.w),
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 16.sp,
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              achievement['description'] as String,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                            if (achievement['unlocked'] == false &&
                                achievement['progress'] != null) ...[
                              SizedBox(height: 8.h),
                              LinearProgressIndicator(
                                value:
                                    (achievement['progress'] as int) /
                                    (achievement['target'] as int),
                                backgroundColor: Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.deepPurple.shade300,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${achievement['progress']}/${achievement['target']}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '+${achievement['xpReward']} XP',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          Text(
                            '+${achievement['coinReward']} 💰',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.amber.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildChallengesTab() {
    final challenges = GamificationService.getDailyChallenges();
    final completedCount = GamificationService.getCompletedChallengesCount();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily Progress
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade600, Colors.orange.shade400],
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Text(
                  'আজকের চ্যালেঞ্জ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$completedCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '/${challenges.length}',
                      style: TextStyle(color: Colors.white70, fontSize: 24.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'চ্যালেঞ্জ সম্পন্ন',
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          Text(
            'চ্যালেঞ্জ লিস্ট',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),

          ...challenges.map(
            (challenge) => Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: challenge['completed'] == true
                    ? Colors.green.shade50
                    : Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: challenge['completed'] == true
                      ? Colors.green.shade300
                      : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: challenge['completed'] == true
                          ? Colors.green
                          : Colors.orange.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: challenge['completed'] == true
                          ? Icon(Icons.check, color: Colors.white, size: 28.sp)
                          : Text(
                              '${challenge['progress'] ?? 0}/${challenge['target'] ?? 1}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge['name'] as String,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          challenge['description'] as String,
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                        if (challenge['completed'] == false &&
                            challenge['target'] != null) ...[
                          SizedBox(height: 8.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.r),
                            child: LinearProgressIndicator(
                              value:
                                  (challenge['progress'] as int) /
                                  (challenge['target'] as int),
                              minHeight: 6.h,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '+${challenge['xpReward']} XP',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Text(
                        '+${challenge['coinReward']} 💰',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.amber.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    final leaderboard = LeaderboardService.getWeeklyLeaderboard();
    final userRank = LeaderboardService.getCurrentUserRank();

    return Column(
      children: [
        // User Rank Card
        Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo.shade600, Colors.indigo.shade400],
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.leaderboard, color: Colors.white, size: 32.sp),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'আপনার র‍্যাংক',
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                  Text(
                    '#$userRank',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 24.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'XP',
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                  Text(
                    '${GamificationService.getCurrentXP()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Leaderboard List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              final item = leaderboard[index];
              final isCurrentUser = item['isCurrentUser'] == true;

              return Container(
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isCurrentUser
                      ? Colors.deepPurple.shade50
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isCurrentUser
                        ? Colors.deepPurple
                        : Colors.grey.shade200,
                    width: isCurrentUser ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Rank
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: _getRankColor(item['rank'] as int),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: item['badge'] != ''
                            ? Text(
                                item['badge'] as String,
                                style: TextStyle(fontSize: 18.sp),
                              )
                            : Text(
                                '#${item['rank']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: 16.w),

                    // Avatar
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        item['avatar'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Name
                    Expanded(
                      child: Text(
                        item['name'] as String,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: isCurrentUser
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),

                    // XP
                    Text(
                      '${item['xp']} XP',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade400;
      case 3:
        return Colors.brown.shade400;
      default:
        return Colors.indigo.shade400;
    }
  }
}
