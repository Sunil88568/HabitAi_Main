import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitai/screens/paywall/PricingCardExact.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../services/revenue_cat_service.dart';
import 'limited_offer_screen.dart';
import '../../theme/app_theme.dart';

class PaywallScreen extends StatefulWidget {
  final VoidCallback? onClose;
  const PaywallScreen({Key? key, this.onClose}) : super(key: key);
  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _hasShownLimitedOffer = false;
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final service = Get.find<RevenueCatService>();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        _handleClose();
        return false;
      },
      child: Scaffold(
        body: FutureBuilder<Offerings?>(
          future: service.getOfferings(),
          builder: (context, snapshot) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [AppColors.darkPrimary, AppColors.darkSecondary]
                      : [AppColors.lightPrimary, AppColors.lightSecondary],
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    _buildMainUI(snapshot, width, height, service),

                    /// CLOSE BUTTON
                    Positioned(
                      top: 10,
                      left: 10,
                      child: GestureDetector(
                        onTap: _handleClose,
                        child: Container(
                          padding: EdgeInsets.all(width * 0.02),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close,
                              size: width * 0.06, color: Theme.of(context).colorScheme.background),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        /// CONTINUE / PURCHASE BUTTON
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: height * 0.02),
          child: SizedBox(
            width: width * 0.9,
            height: 60,
            child: FloatingActionButton(
              onPressed: () async {
                await _purchaseSelected();
              },
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  /// ---------------------------------------------------------
  /// MAIN PREMIUM UI (your design)
  /// ---------------------------------------------------------
  Widget _buildMainUI(
      AsyncSnapshot snapshot, double width, double height, service) {
    final offering = snapshot.data?.current;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height * 0.08),
          /// TITLE
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Unlock '),
                TextSpan(
                  text: 'PRO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkWarning : AppColors.lightWarning,
                  ),
                ),
                const TextSpan(
                  text: ' now,\nGet more change from every day.',
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              height: 1.5,
              letterSpacing: -0.20,
              color: Colors.white,
            ),
          ),

          /// MAIN IMAGE
          Image.asset(
            'assets/bgimages/PremiumMale.png',
            width: width * 0.9,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 10),

          /// OFFERING CARDS (RevenueCat packages OR mock)
          if (snapshot.hasData && offering != null)
            _buildPackageSelector(offering, width)
          else
            _buildMockPackageSelector(width),

          // SizedBox(height: height * 0.02),
          Divider(height: 30, thickness: 1.5, color: Colors.white, endIndent: width * 0.04, indent: width * 0.04),

          /// PREMIUM FEATURES IMAGE
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Features',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.05,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/bgimages/PremiumFeatures.png',
                    width: width,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: height * 0.1),
        ],
      ),
    );
  }
  /// ---------------------------------------------------------
  /// REAL PACKAGE SELECTOR (RevenueCat)
  /// ---------------------------------------------------------
  Widget _buildPackageSelector(Offering offering, double width) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        child: Row(
          children: List.generate(offering.availablePackages.length, (i) {
            final pkg = offering.availablePackages[i];
            return GestureDetector(
              onTap: () => setState(() => selectedIndex = i),
              child: SizedBox(
                width: width * 0.7,
                child: PricingCardExact(
                  title: pkg.storeProduct.title,
                  tagText: i == 0 ? "Best Deal" : "Popular",
                  tagColor: i == 0
                      ? const Color(0xFFD3A455)
                      : const Color(0xFFB4ADEA),
                  description: pkg.storeProduct.description,
                  price: pkg.storeProduct.priceString,
                  oldPrice: "",
                  background: const Color(0xFFF9F9FF),
                  border: selectedIndex == i
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(255, 168, 168, 168),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
  /// ---------------------------------------------------------
  /// MOCK PACKAGE SELECTOR (No RC)
  /// ---------------------------------------------------------
  Widget _buildMockPackageSelector(double width) {
    final mockData = [
      ["Lifetime", "\$14.99", "Best Deal"],
      ["Annual", "\$9.99", "Popular"],
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Row(
          children: List.generate(mockData.length, (i) {
            return GestureDetector(
              onTap: () => setState(() => selectedIndex = i),
              child: SizedBox(
                width: width * 0.7,
                child: PricingCardExact(
                  title: mockData[i][0],
                  tagText: mockData[i][2],
                  tagColor: Colors.yellow,
                  description: "Mock description",
                  price: mockData[i][1],
                  oldPrice: "\$39.99",
                  background: const Color(0xFFF9F9FF),
                  border: selectedIndex == i
                      ? Colors.pink.shade300
                      : const Color(0xFFEBEBFF),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
  /// ---------------------------------------------------------
  /// HANDLE PURCHASE
  /// ---------------------------------------------------------
  Future<void> _purchaseSelected() async {
    final service = Get.find<RevenueCatService>();
    final offering = await service.getOfferings();

    if (offering?.current == null || selectedIndex == -1) {
      Get.snackbar("Select a Plan", "Please choose a subscription first");
      return;
    }

    final pkg = offering!.current!.availablePackages[selectedIndex];

    final success = await service.purchasePackage(pkg);
    if (success) {
      Get.back();
      widget.onClose?.call();
    }
  }

  /// ---------------------------------------------------------
  /// CLOSE PAYWALL → LIMITED OFFER
  /// ---------------------------------------------------------
  void _handleClose() {
    if (!_hasShownLimitedOffer) {
      _hasShownLimitedOffer = true;
      _showLimitedOffer();
    } else {
      Get.back();
      widget.onClose?.call();
    }
  }

  void _showLimitedOffer() {
    Get.to(() => LimitedOfferScreen(
          onAccept: () {
            Get.back();
            Get.back();
            widget.onClose?.call();
          },
          onDecline: () {
            Get.back();
            setState(() => _hasShownLimitedOffer = true);
          },
        ));
  }
}
