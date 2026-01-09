import 'package:flutter/material.dart';
import 'package:jihad/ui/profile/flash_sale_screen.dart';
import 'package:jihad/ui/profile/group_buy_screen.dart';
import 'package:jihad/ui/profile/auction_screen.dart';
import 'package:jihad/ui/profile/lottery_screen.dart';
import 'package:jihad/ui/profile/coupon_screen.dart';
import 'package:jihad/ui/profile/subscription_screen.dart';
import 'package:jihad/ui/profile/compare_screen.dart';
import 'package:jihad/ui/profile/brands_screen.dart';
import 'package:jihad/ui/profile/rewards_screen.dart';
import 'package:jihad/ui/profile/wishlist_screen.dart';
import 'package:jihad/ui/profile/store_locator_screen.dart';
import 'package:jihad/ui/profile/social_screen.dart';
import 'package:jihad/ui/profile/live_shopping_screen.dart';
import 'package:jihad/ui/profile/affiliate_screen.dart';
import 'package:jihad/ui/profile/help_center_screen.dart';
import 'package:jihad/ui/profile/ar_tryon_screen.dart';
import 'package:jihad/ui/profile/size_finder_screen.dart';
import 'package:jihad/ui/profile/virtual_fitting_room_screen.dart';
import 'package:jihad/ui/profile/price_alert_screen.dart';

class AppFeatures {
  static List<Map<String, dynamic>> getFeatures() {
    return [
      {
        'title': 'Flash Sale ⚡',
        'subtitle': 'Up to 70% OFF',
        'icon': Icons.flash_on,
        'image': 'assets/products/product1.jpg',
        'gradient': [Colors.red.shade600, Colors.orange.shade400],
        'screen': const FlashSaleScreen(),
      },
      {
        'title': 'Group Buy 👥',
        'subtitle': 'Save More Together',
        'icon': Icons.group,
        'image': 'assets/products/product2.jpg',
        'gradient': [Colors.purple.shade600, Colors.purple.shade300],
        'screen': const GroupBuyScreen(),
      },
      {
        'title': 'Live Auction 🔨',
        'subtitle': 'Bid & Win',
        'icon': Icons.gavel,
        'image': 'assets/products/product3.jpg',
        'gradient': [Colors.red.shade800, Colors.red.shade500],
        'screen': const AuctionScreen(),
      },
      {
        'title': 'Lucky Draw 🎰',
        'subtitle': 'Win Big Prizes',
        'icon': Icons.casino,
        'gradient': [Colors.amber.shade700, Colors.amber.shade400],
        'screen': const LotteryScreen(),
      },
      {
        'title': 'Coupons 🎫',
        'subtitle': 'Get Discounts',
        'icon': Icons.confirmation_number,
        'gradient': [Colors.pink.shade600, Colors.pink.shade300],
        'screen': const CouponScreen(),
      },
      {
        'title': 'Subscription 📦',
        'subtitle': 'Monthly Box',
        'icon': Icons.card_giftcard,
        'gradient': [Colors.deepPurple.shade600, Colors.deepPurple.shade300],
        'screen': const SubscriptionScreen(),
      },
      {
        'title': 'Compare 📊',
        'subtitle': 'Side by Side',
        'icon': Icons.compare,
        'gradient': [Colors.teal.shade600, Colors.teal.shade300],
        'screen': const CompareScreen(),
      },
      {
        'title': 'Brands 🏪',
        'subtitle': 'Top Brands',
        'icon': Icons.storefront,
        'image': 'assets/products/product4.jpg',
        'gradient': [Colors.indigo.shade600, Colors.indigo.shade300],
        'screen': const BrandsScreen(),
      },
      {
        'title': 'Rewards 🎮',
        'subtitle': 'Earn XP & Coins',
        'icon': Icons.stars,
        'gradient': [Colors.orange.shade600, Colors.orange.shade300],
        'screen': const RewardsScreen(),
      },
      {
        'title': 'Wishlist 💖',
        'subtitle': 'Saved Items',
        'icon': Icons.favorite,
        'gradient': [Colors.red.shade400, Colors.red.shade200],
        'screen': const WishlistScreen(),
      },
      {
        'title': 'Store Finder 📍',
        'subtitle': 'Near You',
        'icon': Icons.location_on,
        'gradient': [Colors.green.shade600, Colors.green.shade300],
        'screen': const StoreLocatorScreen(),
      },
      {
        'title': 'Social Shop 📸',
        'subtitle': 'Shop with Friends',
        'icon': Icons.photo_camera,
        'gradient': [Colors.pink.shade600, Colors.pink.shade300],
        'screen': const SocialScreen(),
      },
      {
        'title': 'Live Shopping 📺',
        'subtitle': 'Watch & Buy',
        'icon': Icons.live_tv,
        'gradient': [Colors.red.shade700, Colors.red.shade400],
        'screen': const LiveShoppingScreen(),
      },
      {
        'title': 'Refer & Earn 💰',
        'subtitle': 'Get ৳500 Per Friend',
        'icon': Icons.share,
        'gradient': [Colors.cyan.shade600, Colors.cyan.shade300],
        'screen': const AffiliateScreen(),
      },
      {
        'title': 'Help Center 📚',
        'subtitle': 'FAQs & Support',
        'icon': Icons.help_outline,
        'gradient': [Colors.blue.shade600, Colors.blue.shade300],
        'screen': const HelpCenterScreen(),
      },
      {
        'title': 'AR Try-On 👓',
        'subtitle': 'Virtual Try-On',
        'icon': Icons.camera_front,
        'gradient': [Colors.purple.shade600, Colors.purple.shade300],
        'screen': const ARTryOnScreen(),
      },
      {
        'title': 'Size Finder 📏',
        'subtitle': 'Find Your Fit',
        'icon': Icons.straighten,
        'gradient': [Colors.teal.shade600, Colors.teal.shade300],
        'screen': const SizeFinderScreen(),
      },
      {
        'title': 'Fitting Room 👕',
        'subtitle': 'Virtual Room',
        'icon': Icons.accessibility_new,
        'gradient': [Colors.orange.shade600, Colors.orange.shade300],
        'screen': const VirtualFittingRoomScreen(),
      },
      {
        'title': 'Price Alert 🔔',
        'subtitle': 'Get Notified',
        'icon': Icons.notifications_active,
        'gradient': [Colors.red.shade600, Colors.red.shade300],
        'screen': const PriceAlertScreen(),
      },
    ];
  }
}
