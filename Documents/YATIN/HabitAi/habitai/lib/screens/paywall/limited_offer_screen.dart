import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../services/revenue_cat_service.dart';

class LimitedOfferScreen extends StatefulWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  
  const LimitedOfferScreen({Key? key, required this.onAccept, required this.onDecline}) : super(key: key);

  @override
  State<LimitedOfferScreen> createState() => _LimitedOfferScreenState();
}

class _LimitedOfferScreenState extends State<LimitedOfferScreen> {
  Timer? _timer;
  int _secondsLeft = 120; // 2 minutes
  
  @override
  void initState() {
    super.initState();
    _startTimer();
  }
  
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        timer.cancel();
        widget.onDecline();
      }
    });
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = Get.find<RevenueCatService>();
    final minutes = _secondsLeft ~/ 60;
    final seconds = _secondsLeft % 60;
    
    return WillPopScope(
      onWillPop: () async {
        widget.onDecline();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.red.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('LIMITED TIME', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: widget.onDecline,
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🔥', style: TextStyle(fontSize: 80)),
                      SizedBox(height: 20),
                      Text('WAIT!', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Special 50% OFF', style: TextStyle(color: Colors.yellow, fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                          style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 30),
                      FutureBuilder<Offerings?>(
                        future: service.getOfferings(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return CircularProgressIndicator();
                          
                          final offering = snapshot.data?.current;
                          final monthlyPackage = offering?.availablePackages.firstWhere(
                            (p) => p.storeProduct.identifier.contains('monthly'),
                            orElse: () => offering.availablePackages.first,
                          );
                          
                          if (monthlyPackage == null) return SizedBox();
                          
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final success = await service.purchasePackage(monthlyPackage);
                                    if (success) {
                                      Get.back(); // Close limited offer
                                      Get.back(); // Close paywall
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Text(
                                    'GET 50% OFF - ${monthlyPackage.storeProduct.priceString}/month',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextButton(
                                onPressed: widget.onDecline,
                                child: Text('No thanks, continue with free version', 
                                  style: TextStyle(color: Colors.white70)),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}