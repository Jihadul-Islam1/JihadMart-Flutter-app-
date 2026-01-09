import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/social_service.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('সোশ্যাল শপিং 🛍️'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'ফিড'),
            Tab(text: 'ফলোয়িং'),
            Tab(text: 'আমার পোস্ট'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFeed(), _buildFollowing(), _buildMyPosts()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePostSheet(),
        backgroundColor: Colors.pink,
        icon: const Icon(Icons.add_photo_alternate, color: Colors.white),
        label: const Text('পোস্ট', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildFeed() {
    final feed = SocialService.getFeed();

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: feed.length,
      itemBuilder: (context, index) {
        return _buildFeedCard(feed[index]);
      },
    );
  }

  Widget _buildFeedCard(Map<String, dynamic> post) {
    final likes = post['likes'] as int;
    final comments = post['comments'] as int;
    final isLiked = post['isLiked'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.pink.shade100,
                  child: Text(
                    (post['userName'] as String).substring(0, 1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post['userName'] as String,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (post['isVerified'] == true) ...[
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.verified,
                              size: 14.sp,
                              color: Colors.blue,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        _formatTime(post['time'] as DateTime),
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),

          // Post Image
          Container(
            height: 250.h,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey.shade200),
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.image, size: 60.sp, color: Colors.grey),
                ),
                if (post['product'] != null)
                  Positioned(
                    bottom: 12.h,
                    left: 12.w,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: const Icon(Icons.shopping_bag, size: 20),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (post['product'] as Map)['name'] as String,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '৳${((post['product'] as Map)['price'] as double).toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.pink,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              foregroundColor: Colors.white,
                              minimumSize: Size(60.w, 30.h),
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                            ),
                            child: Text(
                              'কিনুন',
                              style: TextStyle(fontSize: 11.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Caption
          if (post['caption'] != null)
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Text(
                post['caption'] as String,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),

          // Actions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                _buildActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  label: '$likes',
                  color: isLiked ? Colors.red : Colors.grey.shade600,
                  onTap: () {
                    setState(() {
                      post['isLiked'] = !isLiked;
                      post['likes'] = isLiked ? likes - 1 : likes + 1;
                    });
                  },
                ),
                SizedBox(width: 16.w),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '$comments',
                  color: Colors.grey.shade600,
                  onTap: () => _showComments(post),
                ),
                SizedBox(width: 16.w),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'শেয়ার',
                  color: Colors.grey.shade600,
                  onTap: () {},
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.bookmark_border,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 22.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(fontSize: 13.sp, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowing() {
    final following = SocialService.getFollowing();

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: following.length,
      itemBuilder: (context, index) {
        final user = following[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundColor: Colors.pink.shade100,
                child: Text(
                  (user['name'] as String).substring(0, 1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user['name'] as String,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (user['isVerified'] == true) ...[
                          SizedBox(width: 4.w),
                          Icon(Icons.verified, size: 14.sp, color: Colors.blue),
                        ],
                      ],
                    ),
                    Text(
                      '${user['posts']} পোস্ট • ${user['followers']} ফলোয়ার',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.pink,
                  side: const BorderSide(color: Colors.pink),
                ),
                child: const Text('ফলো করা হচ্ছে'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMyPosts() {
    final myPosts = SocialService.getMyPosts();

    if (myPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 60.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              'আপনার কোনো পোস্ট নেই',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
            SizedBox(height: 8.h),
            ElevatedButton.icon(
              onPressed: () => _showCreatePostSheet(),
              icon: const Icon(Icons.add),
              label: const Text('পোস্ট করুন'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.h,
      ),
      itemCount: myPosts.length,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.image),
        );
      },
    );
  }

  void _showCreatePostSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'নতুন পোস্ট',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  _buildPostOption(
                    icon: Icons.camera_alt,
                    label: 'ক্যামেরা',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 16.w),
                  _buildPostOption(
                    icon: Icons.photo_library,
                    label: 'গ্যালারি',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 16.w),
                  _buildPostOption(
                    icon: Icons.shopping_bag,
                    label: 'প্রোডাক্ট',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 30.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, color: Colors.pink, size: 28.sp),
          ),
          SizedBox(height: 8.h),
          Text(label, style: TextStyle(fontSize: 12.sp)),
        ],
      ),
    );
  }

  void _showComments(Map<String, dynamic> post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'কমেন্ট',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildComment('সুন্দর!', 'ফাতেমা'),
                        _buildComment('এটা কোথায় পাওয়া যায়?', 'রাহেলা'),
                        _buildComment('দাম কত?', 'কামাল'),
                      ],
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'কমেন্ট লিখুন...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.send, color: Colors.pink),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildComment(String text, String userName) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: Colors.pink.shade100,
            child: Text(
              userName.substring(0, 1),
              style: const TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(text, style: TextStyle(fontSize: 14.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'এইমাত্র';
    if (diff.inMinutes < 60) return '${diff.inMinutes} মিনিট আগে';
    if (diff.inHours < 24) return '${diff.inHours} ঘন্টা আগে';
    return '${diff.inDays} দিন আগে';
  }
}
