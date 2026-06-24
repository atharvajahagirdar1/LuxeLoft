import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': _nameController.text.trim(),
          'email': user.email,
          'phone': _phoneController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account Created & Saved Successfully!'),
              backgroundColor: Color(0xFF1497AD),
            ),
          );
          
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const Text("Create Account", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Sign Up", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            _inputField(Icons.person_outline, "Name", controller: _nameController),
            const SizedBox(height: 20),
            _inputField(Icons.email_outlined, "Email", controller: _emailController),
            const SizedBox(height: 20),
            _inputField(Icons.lock_outline, "Password", isPassword: true, controller: _passwordController),
            const SizedBox(height: 20),
            _phoneField(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1497AD), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                onPressed: _isLoading ? null : _signUp, // Triggers Firebase Auth and Firestore Save
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("NEXT", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(IconData icon, String hint, {bool isPassword = false, TextEditingController? controller}) {
    return TextField(
      controller: controller, 
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey), suffixIcon: isPassword ? const Icon(Icons.visibility_off, color: Colors.grey) : null,
        hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  Widget _phoneField() {
    return TextField(
      controller: _phoneController, 
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        prefixIcon: const Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.flag, color: Colors.red), SizedBox(width: 5), Text("+244", style: TextStyle(color: Colors.grey)), Icon(Icons.keyboard_arrow_down, color: Colors.grey)])),
        hintText: "Mobile Number", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }
}
