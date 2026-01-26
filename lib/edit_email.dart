import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditEmail extends StatefulWidget {
  const EditEmail({super.key});

  @override
  State<EditEmail> createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  bool _isObscured = true;

  Future<void> _updateEmail() async {
    String password = _passwordController.text.trim();
    String newEmail = _newEmailController.text.trim();

    if (password.isEmpty || newEmail.isEmpty) {
      _showSnackBar("Please fill both fields", Colors.red);
      return;
    }

    if (!newEmail.contains("@")) {
      _showSnackBar("Please enter a valid email", Colors.red);
      return;
    }

    // Loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // 1. Re-authenticate (Pehle verify karna ke user sahi hai)
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);

        // 2. Update Email using the latest Firebase method
        // Ye naye email par confirmation link bhejega
        await user.verifyBeforeUpdateEmail(newEmail);

        // 3. Local memory mein bhi update save kar dein
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', newEmail);

        if (!mounted) return;
        Navigator.pop(context); // Close loading

        _showSnackBar(
          "Verification link sent! Please verify $newEmail to complete update.",
          Colors.orange,
        );

        // Fields clear kar dein
        _passwordController.clear();
        _newEmailController.clear();
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context);

      String errorMsg = "Update failed";
      if (e.code == 'wrong-password') {
        errorMsg = "Incorrect password!";
      } else if (e.code == 'email-already-in-use') {
        errorMsg = "This email is already in use.";
      } else if (e.code == 'invalid-email') {
        errorMsg = "The email address is badly formatted.";
      } else {
        errorMsg = e.message ?? "An error occurred";
      }

      _showSnackBar(errorMsg, Colors.red);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      _showSnackBar("Error: ${e.toString()}", Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _newEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF080C10)),
        title: const Text(
          "Edit Email",
          style: TextStyle(
            color: Color(0xFF080C10),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Update Your Email",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "First enter current password",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // --- Current Password Field ---
            _buildTextField(
              label: "Current Password",
              controller: _passwordController,
              isObscured: _isObscured,
              suffix: IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _isObscured = !_isObscured),
              ),
            ),

            const SizedBox(height: 20),

            // --- New Email Field ---
            _buildTextField(
              label: "New Email Address",
              controller: _newEmailController,
              isObscured: false,
            ),

            const SizedBox(height: 40),

            // --- Update Button ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _updateEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008CFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Verify & Update",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool isObscured,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscured,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF4F7F9),
        suffixIcon: suffix,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF18FFFF), width: 1.5),
        ),
      ),
    );
  }
}
