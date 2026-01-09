import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/lottery_service.dart';

class LotteryScreen extends StatefulWidget {
  const LotteryScreen({super.key});

  @override
  State<LotteryScreen> createState() => _LotteryScreenState();
}

class _LotteryScreenState extends State<LotteryScreen>
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
        title: const Text('Lucky Draw 🎰'),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'পুরস্কার'),
            Tab(text: 'আমার টিকেট'),
            Tab(text: 'স্পিন হুইল'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPrizesTab(),
          _buildMyTicketsTab(),
          _buildSpinWheelTab(),
        ],
      ),
    );
  }

  Widget _buildPrizesTab() {
    final prizes = LotteryService.getPrizes();
    final drawDate = LotteryService.getDrawDate();
    final timeLeft = drawDate.difference(DateTime.now());

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Countdown Timer
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade700, Colors.orange.shade600],
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Text(
                  '🎉 ড্র পর্যন্ত বাকি',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimeBox('${timeLeft.inDays}', 'দিন'),
                    SizedBox(width: 10.w),
                    _buildTimeBox('${timeLeft.inHours % 24}', 'ঘন্টা'),
                    SizedBox(width: 10.w),
                    _buildTimeBox('${timeLeft.inMinutes % 60}', 'মিনিট'),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  'আপনার জেতার সম্ভাবনা: ${LotteryService.getWinningChance().toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Prizes
          ...prizes.map(
            (prize) => Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(50),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: _getPrizeColor(prize['position'] as String),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        prize['position'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prize['prize'] as String,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'মূল্য: ৳${(prize['value'] as double).toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Buy Ticket Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showBuyTicketDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.confirmation_number),
                  SizedBox(width: 8.w),
                  Text(
                    'টিকেট কিনুন (৳১০০/টিকেট)',
                    style: TextStyle(
                      fontSize: 16.sp,
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

  Widget _buildTimeBox(String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade700,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Color _getPrizeColor(String position) {
    switch (position) {
      case '1st':
        return Colors.amber;
      case '2nd':
        return Colors.grey.shade400;
      case '3rd':
        return Colors.brown.shade400;
      default:
        return Colors.blue.shade400;
    }
  }

  Widget _buildMyTicketsTab() {
    final tickets = LotteryService.getMyTickets();

    return Column(
      children: [
        // Stats
        Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade600, Colors.purple.shade400],
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'মোট টিকেট',
                '${LotteryService.getUserTickets()}',
                Icons.confirmation_number,
              ),
              Container(width: 1, height: 50.h, color: Colors.white30),
              _buildStatItem(
                'জেতার সম্ভাবনা',
                '${LotteryService.getWinningChance().toStringAsFixed(2)}%',
                Icons.pie_chart,
              ),
            ],
          ),
        ),

        // Tickets List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return Card(
                margin: EdgeInsets.only(bottom: 10.h),
                child: ListTile(
                  leading: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.confirmation_number,
                      color: Colors.amber.shade700,
                    ),
                  ),
                  title: Text(
                    ticket['ticketNumber'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  subtitle: Text(
                    'কেনা হয়েছে: ${_formatDate(ticket['purchaseDate'] as DateTime)}',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28.sp),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildSpinWheelTab() {
    final spinsRemaining = SpinWheelService.getSpinsRemaining();
    final wonRewards = SpinWheelService.getWonRewards();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Spin Wheel
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(30.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade600,
                  Colors.deepPurple.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Container(
                  width: 180.w,
                  height: 180.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.amber, width: 4),
                    gradient: const SweepGradient(
                      colors: [
                        Colors.red,
                        Colors.orange,
                        Colors.yellow,
                        Colors.green,
                        Colors.blue,
                        Colors.purple,
                        Colors.pink,
                        Colors.red,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'SPIN',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'আজ বাকি স্পিন: $spinsRemaining',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: spinsRemaining > 0
                      ? () {
                          final result = SpinWheelService.spin();
                          if (result['success'] == true) {
                            setState(() {});
                            _showSpinResultDialog(result['reward']);
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 14.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    'স্পিন করুন! 🎰',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Won Rewards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'জেতা পুরস্কার',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text('সব দেখুন')),
            ],
          ),
          SizedBox(height: 12.h),

          ...wonRewards.map(
            (reward) => Card(
              margin: EdgeInsets.only(bottom: 10.h),
              child: ListTile(
                leading: Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.card_giftcard,
                    color: Colors.green.shade700,
                  ),
                ),
                title: Text(reward['reward'] as String),
                subtitle: Text(_formatDate(reward['wonAt'] as DateTime)),
                trailing: reward['used'] == true
                    ? Chip(
                        label: Text(
                          'ব্যবহৃত',
                          style: TextStyle(fontSize: 10.sp),
                        ),
                        backgroundColor: Colors.grey.shade200,
                      )
                    : ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                        ),
                        child: const Text('ব্যবহার করুন'),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBuyTicketDialog() {
    int ticketCount = 1;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('টিকেট কিনুন 🎫'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: ticketCount > 1
                        ? () {
                            setDialogState(() => ticketCount--);
                          }
                        : null,
                    icon: const Icon(Icons.remove_circle),
                    iconSize: 36.sp,
                    color: Colors.amber.shade700,
                  ),
                  SizedBox(width: 20.w),
                  Text(
                    '$ticketCount',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  IconButton(
                    onPressed: () {
                      setDialogState(() => ticketCount++);
                    },
                    icon: const Icon(Icons.add_circle),
                    iconSize: 36.sp,
                    color: Colors.amber.shade700,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                'মোট: ৳${ticketCount * 100}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade700,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('বাতিল'),
            ),
            ElevatedButton(
              onPressed: () {
                LotteryService.buyTicket(count: ticketCount);
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$ticketCount টি টিকেট কেনা হয়েছে! 🎉'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('কিনুন'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSpinResultDialog(Map<String, dynamic> reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          reward['type'] == 'none' ? '😢' : '🎉 অভিনন্দন!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28.sp),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              reward['label'] as String,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: reward['type'] == 'none'
                    ? Colors.grey
                    : Colors.amber.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            if (reward['type'] != 'none') ...[
              SizedBox(height: 12.h),
              Text(
                'আপনার পুরস্কার যোগ করা হয়েছে!',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('ঠিক আছে'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
