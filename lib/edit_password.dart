import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isOldObscured = true;
  bool _isNewObscured = true;

  // Aapka Brand Colors
  final Color primaryDark = Color(0xFF080C10);
  final Color accentCyan = Color(0xFF008CFF);

  // --- PASSWORD UPDATE LOGIC ---
  Future<void> _updatePassword() async {
    String oldPassword = _oldPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Both fields are required")));
      return;
    }

    // Loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: accentCyan)),
    );

    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? email = user?.email;

      if (user != null && email != null) {
        // 1. Re-authenticate
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: oldPassword,
        );

        await user.reauthenticateWithCredential(credential);

        // 2. Update to new password
        await user.updatePassword(newPassword);

        if (!mounted) return;
        Navigator.pop(context); // Close loading

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password successfully updated!"),
            backgroundColor: accentCyan,
          ),
        );

        _oldPasswordController.clear();
        _newPasswordController.clear();
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading

      String errorMsg = "Update failed";
      if (e.code == 'wrong-password') {
        errorMsg = "Old password is incorrect!";
      } else if (e.code == 'weak-password') {
        errorMsg = "New password must be at least 6 characters";
      } else if (e.code == 'requires-recent-login') {
        errorMsg = "Please log in again to change password";
      } else {
        errorMsg = e.message ?? "Error occurred";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
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
          "Edit Profile",
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
              "Change Password",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : primaryDark,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Secure your account by updating your password regularly.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 32),

            // Old Password
            _buildPasswordField(
              label: "Old Password",
              controller: _oldPasswordController,
              isObscured: _isOldObscured,
              isDark: isDark,
              onToggle: () => setState(() => _isOldObscured = !_isOldObscured),
            ),

            SizedBox(height: 20),

            // New Password
            _buildPasswordField(
              label: "New Password",
              controller: _newPasswordController,
              isObscured: _isNewObscured,
              isDark: isDark,
              onToggle: () => setState(() => _isNewObscured = !_isNewObscured),
            ),

            SizedBox(height: 40),

            // Update Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentCyan,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Update Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isObscured,
    required bool isDark,
    required VoidCallback onToggle,
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
            suffixIcon: IconButton(
              icon: Icon(
                isObscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: onToggle,
            ),
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
