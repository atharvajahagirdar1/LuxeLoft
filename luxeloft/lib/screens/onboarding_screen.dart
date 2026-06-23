import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      "title": "ONLINE PAYMENT",
      "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pharetra quam elementum massa.",
      "icon": Icons.payment,
    },
    {
      "title": "ONLINE SHOPPING",
      "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pharetra quam elementum massa.",
      "icon": Icons.shopping_cart,
    },
    {
      "title": "HOME DELIVER SERVICE",
      "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pharetra quam elementum massa.",
      "icon": Icons.delivery_dining,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1497AD),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (value) => setState(() => _currentPage = value),
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Icon(
                    onboardingData[index]["icon"],
                    size: 150,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      onboardingData[_currentPage]["title"],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF99D1C),
                      ),
                    ),
                    Text(
                      onboardingData[_currentPage]["text"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text(
                            "Skip>>",
                            style: TextStyle(
                              color: Color(0xFFF99D1C),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          backgroundColor: const Color(0xFFF99D1C),
                          elevation: 0,
                          shape: const CircleBorder(),
                          onPressed: () {
                            if (_currentPage == onboardingData.length - 1) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            }
                          },
                          child: const Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
