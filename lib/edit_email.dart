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

  // Aapke Brand Colors
  final Color primaryDark = Color(0xFF080C10);
  final Color accentCyan = Color(0xFF18FFFF);

  Future<void> _updateEmail() async {
    String password = _passwordController.text.trim();
    String newEmail = _newEmailController.text.trim();

    if (password.isEmpty || newEmail.isEmpty) {
      _showSnackBar("Please fill both fields", Colors.redAccent);
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(newEmail)) {
      _showSnackBar("Please enter a valid email", Colors.redAccent);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: accentCyan)),
    );

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // 1. Re-authenticate
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);

        // 2. Verify Before Update
        await user.verifyBeforeUpdateEmail(newEmail);

        // 3. Local memory update
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', newEmail);

        if (!mounted) return;
        Navigator.pop(context);

        _showSnackBar(
          "Verification link sent! Check $newEmail to finish.",
          accentCyan,
        );

        _passwordController.clear();
        _newEmailController.clear();
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context);

      String errorMsg = e.code == 'wrong-password'
          ? "Incorrect password!"
          : e.code == 'email-already-in-use'
          ? "Email already registered."
          : e.message ?? "Update failed";

      _showSnackBar(errorMsg, Colors.redAccent);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      _showSnackBar("Something went wrong", Colors.redAccent);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: color == accentCyan ? Color(0xFF008CFF) : color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _newEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? primaryDark : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : primaryDark),
        title: Text(
          "Edit Email",
          style: TextStyle(
            color: isDark ? Colors.white : primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Update Email Address",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : primaryDark,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "We will send a verification link to your new email.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 32),

            _buildTextField(
              label: "Current Password",
              controller: _passwordController,
              isObscured: _isObscured,
              isDark: isDark,
              suffix: IconButton(
                icon: Icon(
                  _isObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () => setState(() => _isObscured = !_isObscured),
              ),
            ),

            SizedBox(height: 20),

            _buildTextField(
              label: "New Email Address",
              controller: _newEmailController,
              isObscured: false,
              isDark: isDark,
            ),

            SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _updateEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF008CFF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Verify & Update",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
    required bool isDark,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            // ignore: deprecated_member_use
            color: isDark ? Colors.white70 : primaryDark.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscured,
          style: TextStyle(color: isDark ? Colors.white : primaryDark),
          decoration: InputDecoration(
            hintText: "Enter $label",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: isDark
                // ignore: deprecated_member_use
                ? Colors.white.withOpacity(0.05)
                : Color(0xFFF4F7F9),
            suffixIcon: suffix,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                // ignore: deprecated_member_use
                color: accentCyan.withOpacity(0.5),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
