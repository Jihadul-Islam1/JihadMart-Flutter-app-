import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/AppColors.dart';

class LiveChatScreen extends StatefulWidget {
  @override
  _LiveChatScreenState createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _messages = [
    {
      'text':
          'আসসালামু আলাইকুম! 👋 আমি আপনার সাহায্যকারী। কীভাবে সাহায্য করতে পারি?',
      'isBot': true,
      'time': DateTime.now().subtract(Duration(minutes: 1)),
    },
  ];

  final List<String> _quickReplies = [
    "অর্ডার ট্র্যাক করুন",
    "রিটার্ন পলিসি",
    "পেমেন্ট সমস্যা",
    "ডেলিভারি সময়",
    "প্রোডাক্ট তথ্য",
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isBot': false, 'time': DateTime.now()});
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate bot response
    Future.delayed(Duration(milliseconds: 800), () {
      _generateBotResponse(text);
    });
  }

  void _generateBotResponse(String userMessage) {
    String response;
    String lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('অর্ডার') || lowerMessage.contains('track')) {
      response = '''আপনার অর্ডার ট্র্যাক করতে:
1. Profile > My Orders যান
2. অর্ডার সিলেক্ট করুন
3. Track Order ক্লিক করুন

অথবা Order Tracking স্ক্রিন থেকে সরাসরি ট্র্যাক করুন! 📦''';
    } else if (lowerMessage.contains('রিটার্ন') ||
        lowerMessage.contains('return')) {
      response = '''আমাদের রিটার্ন পলিসি:
✅ ৭ দিনের মধ্যে রিটার্ন
✅ অক্ষত প্যাকেজিং প্রয়োজন
✅ ফ্রি পিকআপ সার্ভিস

Profile > Return/Refund থেকে রিকোয়েস্ট করুন! 🔄''';
    } else if (lowerMessage.contains('পেমেন্ট') ||
        lowerMessage.contains('payment')) {
      response = '''আমরা যেসব পেমেন্ট মেথড সাপোর্ট করি:
💳 bKash, Nagad, Rocket
💳 Credit/Debit Card
💵 Cash on Delivery

পেমেন্ট সমস্যা হলে support@jihad.com এ মেইল করুন! 💰''';
    } else if (lowerMessage.contains('ডেলিভারি') ||
        lowerMessage.contains('delivery')) {
      response = '''ডেলিভারি সময়সূচী:
🏙️ ঢাকা শহর: ২-৩ দিন
🌆 ঢাকার বাইরে: ৩-৫ দিন
🏡 প্রত্যন্ত এলাকা: ৫-৭ দিন

ডেলিভারি চার্জ: ৳60-120 (এলাকা অনুযায়ী) 🚚''';
    } else if (lowerMessage.contains('প্রোডাক্ট') ||
        lowerMessage.contains('product')) {
      response = '''প্রোডাক্ট সম্পর্কে জানতে:
📱 প্রোডাক্ট পেজে সব ডিটেইলস আছে
📏 Size Guide দেখুন সাইজ জানতে
⭐ রিভিউ পড়ুন অন্যদের মতামত জানতে

কোন প্রোডাক্ট সম্পর্কে জানতে চান? 🛍️''';
    } else if (lowerMessage.contains('হ্যালো') ||
        lowerMessage.contains('হাই') ||
        lowerMessage.contains('hello')) {
      response = 'হ্যালো! 😊 কীভাবে সাহায্য করতে পারি?';
    } else if (lowerMessage.contains('ধন্যবাদ') ||
        lowerMessage.contains('thanks')) {
      response = 'আপনাকেও ধন্যবাদ! 🙏 আর কোনো প্রশ্ন থাকলে জিজ্ঞেস করুন।';
    } else {
      response = '''আমি আপনার প্রশ্ন বুঝতে পারিনি। 🤔 

এই বিষয়গুলো নিয়ে জিজ্ঞেস করতে পারেন:
• অর্ডার ট্র্যাকিং
• রিটার্ন/রিফান্ড
• পেমেন্ট সমস্যা
• ডেলিভারি তথ্য
• প্রোডাক্ট তথ্য

অথবা support@jihad.com এ ইমেইল করুন! 📧''';
    }

    setState(() {
      _messages.add({'text': response, 'isBot': true, 'time': DateTime.now()});
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.deep_orange,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18.r,
              child: Icon(
                Icons.support_agent,
                color: AppColors.deep_orange,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Customer Support",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "Online",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Calling support...")));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(15.w),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Quick Replies
          Container(
            height: 50.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              itemCount: _quickReplies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _sendMessage(_quickReplies[index]),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 8.h,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.deep_orange),
                    ),
                    child: Center(
                      child: Text(
                        _quickReplies[index],
                        style: TextStyle(
                          color: AppColors.deep_orange,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Field
          Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.grey),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "মেসেজ লিখুন...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () => _sendMessage(_messageController.text),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.deep_orange,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send, color: Colors.white, size: 20.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isBot = message['isBot'];
    DateTime time = message['time'];
    String timeStr = "${time.hour}:${time.minute.toString().padLeft(2, '0')}";

    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 15.h,
          left: isBot ? 0 : 50.w,
          right: isBot ? 50.w : 0,
        ),
        child: Column(
          crossAxisAlignment: isBot
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: isBot ? Colors.white : AppColors.deep_orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: isBot ? Radius.zero : Radius.circular(20),
                  bottomRight: isBot ? Radius.circular(20) : Radius.zero,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message['text'],
                style: TextStyle(
                  color: isBot ? Colors.black87 : Colors.white,
                  fontSize: 14.sp,
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Text(
                timeStr,
                style: TextStyle(color: Colors.grey, fontSize: 11.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
