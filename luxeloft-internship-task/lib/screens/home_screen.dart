import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_logo.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.redAccent), 
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if(context.mounted) {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            }
          }
        ),
        title: const Center(child: CustomLogo(size: 24)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.qr_code_scanner, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
                builder: (context, snapshot) {
                  String displayName = "Guest";
                  
                  if (user?.displayName != null && user!.displayName!.isNotEmpty) {
                    displayName = user.displayName!.split(" ")[0];
                  }
                  
                  // 2. Override with Firestore Database data if available (Works for Email/Password Sign Up)
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>?;
                    if (data != null && data['name'] != null && data['name'].toString().isNotEmpty) {
                      displayName = data['name'].toString().split(" ")[0];
                      // Capitalize the first letter so "naman" becomes "Naman"
                      displayName = displayName[0].toUpperCase() + displayName.substring(1);
                    }
                  }
                  
                  return Text("Hi, $displayName", style: const TextStyle(fontSize: 16, color: Colors.black87));
                },
              ),
              const SizedBox(height: 5),
              const Text("What are you looking for\ntoday?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2)),
              const SizedBox(height: 20),
              
              // Banner
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(color: const Color(0xFFF99D1C).withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("FOR ONLINE\nORDER", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text("30%\nOFF", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: Center(child: Icon(Icons.shopping_bag, size: 80, color: const Color(0xFFF99D1C).withOpacity(0.5))))
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Categories Header
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _categoryText("Recommend", isActive: true),
                    _categoryText("Cell Phone"),
                    _categoryText("Car Products"),
                    _categoryText("Department Store"),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Align(alignment: Alignment.centerRight, child: Text("See More", style: TextStyle(color: Color(0xFFF99D1C), fontWeight: FontWeight.bold))),
              const SizedBox(height: 15),

              // Category Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 15,
                crossAxisSpacing: 10,
                children: [
                  _categoryIcon(Icons.face_retouching_natural, "Beauty"),
                  _categoryIcon(Icons.local_offer, "Offers"),
                  _categoryIcon(Icons.checkroom, "Fashion"),
                  _categoryIcon(Icons.weekend, "Home"),
                  _categoryIcon(Icons.dry_cleaning, "Shirt"),
                  _categoryIcon(Icons.shopping_bag, "Woman Bag"),
                  _categoryIcon(Icons.girl, "Dress"),
                  _categoryIcon(Icons.phone_iphone, "Mobiles"),
                ],
              ),
              
              const SizedBox(height: 30),
              
              const Text("Products from Backend", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              // Live Products from Firestore
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('products').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const Text('Error connecting to backend.');
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  
                  final products = snapshot.data?.docs ?? [];
                  
                  if (products.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)),
                      child: const Text("Go to Firebase Console -> Firestore Database -> Create a collection named 'products' and add documents with a 'name' string field to see them here!", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final item = products[index].data() as Map<String, dynamic>;
                      return _productCard(item['name'] ?? 'Unnamed Item');
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryText(String text, {bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Text(text, style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? Colors.black : Colors.grey)),
          if (isActive) Container(margin: const EdgeInsets.only(top: 5), height: 3, width: 40, color: const Color(0xFFF99D1C))
        ],
      ),
    );
  }

  Widget _categoryIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: const Color(0xFF1497AD))),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _productCard(String name) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.favorite_border, size: 18, color: Colors.grey),
          Expanded(child: Center(child: Icon(Icons.image, size: 50, color: Colors.grey.shade400))),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}