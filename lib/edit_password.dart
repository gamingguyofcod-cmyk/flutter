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

  // --- PASSWORD UPDATE LOGIC ---
  Future<void> _updatePassword() async {
    String oldPassword = _oldPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("both fields should be filled")),
      );
      return;
    }

    // Loading indicator dikhayein
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? email = user?.email;

      if (user != null && email != null) {
        // 1. Re-authenticate (Check if old password is correct)
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: oldPassword,
        );

        await user.reauthenticateWithCredential(credential);

        // 2. Update to new password
        await user.updatePassword(newPassword);

        if (!mounted) return;
        Navigator.pop(context); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password successfully updated!"),
            backgroundColor: Colors.green,
          ),
        );

        // Fields clear kar dein
        _oldPasswordController.clear();
        _newPasswordController.clear();
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      String errorMsg = "Update failed";
      if (e.code == 'wrong-password') {
        errorMsg = "old passwrod is incorrect!";
      } else if (e.code == 'weak-password') {
        errorMsg = "New password should be 6 character long";
      } else {
        errorMsg = e.message ?? "Error occurred";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      print(e.toString());
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF080C10)),
        title: const Text(
          "Edit Profile",
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
              "Change Your Password",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "First enter old password than new password",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // --- Old Password Field ---
            _buildPasswordField(
              label: "Old Password",
              controller: _oldPasswordController,
              isObscured: _isOldObscured,
              onToggle: () => setState(() => _isOldObscured = !_isOldObscured),
            ),

            const SizedBox(height: 20),

            // --- New Password Field ---
            _buildPasswordField(
              label: "New Password",
              controller: _newPasswordController,
              isObscured: _isNewObscured,
              onToggle: () => setState(() => _isNewObscured = !_isNewObscured),
            ),

            const SizedBox(height: 40),

            // --- Update Button ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008CFF), // Your Brand Dark
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Update Password",
                  style: TextStyle(
                    color: Color.fromARGB(
                      255,
                      255,
                      255,
                      255,
                    ), // Your Brand Cyan
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

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isObscured,
    required VoidCallback onToggle,
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
        suffixIcon: IconButton(
          icon: Icon(
            isObscured ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 255, 255, 255),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
