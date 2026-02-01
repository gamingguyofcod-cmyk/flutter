import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foodroute/log_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Color primaryCyan = Color(
  0xFF008CFF,
); // Standard Blue/Cyan for light mode

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isObscured = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Brand Colors
  final Color primaryDark = Color(0xFF080C10);
  final Color accentCyan = Color(0xFF18FFFF);

  // --- FIREBASE SIGN UP FUNCTION ---
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            Center(child: CircularProgressIndicator(color: accentCyan)),
      );

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        String nameToSave = _nameController.text.trim();
        await userCredential.user?.updateDisplayName(nameToSave);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', nameToSave);
        await prefs.setString('email', _emailController.text.trim());

        if (!mounted) return;
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Account Created!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        Navigator.pop(context);
        String message = e.code == 'weak-password'
            ? "Weak Password"
            : e.message ?? "Error";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
        );
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check Current Theme
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: isDark ? primaryDark : Color(0xFFF8F9FA),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : primaryCyan,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Start your nutrition journey today",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(height: 40),

                    // Social Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildSocialButton(
                            isDark,
                            "Facebook",
                            Icons.facebook,
                            Colors.blueAccent,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: _buildSocialButton(
                            isDark,
                            "Google",
                            Icons.g_mobiledata,
                            Colors.redAccent,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: isDark ? Colors.white10 : Colors.black12,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Or",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: isDark ? Colors.white10 : Colors.black12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    _buildTextField(
                      isDark: isDark,
                      label: "Full Name",
                      controller: _nameController,
                      icon: Icons.person_outline,
                      validator: (value) =>
                          (value == null || value.isEmpty) ? "Required" : null,
                    ),
                    SizedBox(height: 15),

                    _buildTextField(
                      isDark: isDark,
                      label: "Email Address",
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      validator: (value) =>
                          (value == null || !value.contains("@"))
                          ? "Invalid Email"
                          : null,
                    ),
                    SizedBox(height: 15),

                    _buildTextField(
                      isDark: isDark,
                      label: "Password",
                      controller: _passwordController,
                      icon: Icons.lock_outline,
                      obscureText: _isObscured,
                      suffix: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility_off : Icons.visibility,
                          color: isDark ? Colors.white38 : Colors.grey,
                        ),
                        onPressed: () =>
                            setState(() => _isObscured = !_isObscured),
                      ),
                      validator: (value) => (value == null || value.length < 6)
                          ? "Min 6 chars"
                          : null,
                    ),

                    SizedBox(height: 30),

                    // SIGN UP BUTTON
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: isDark
                              ? [accentCyan, Color(0xFF008CFF)]
                              : [Color(0xFF008CFF), Color(0xFF008CFF)],
                        ),
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _signUp,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: isDark ? primaryDark : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                          children: [
                            TextSpan(
                              text: "Log In",
                              style: TextStyle(
                                color: isDark ? accentCyan : Color(0xFF008CFF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Adaptive TextField Helper
  Widget _buildTextField({
    required bool isDark,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    Widget? suffix,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: isDark ? accentCyan : Color(0xFF008CFF),
          size: 20,
        ),
        suffixIcon: suffix,
        hintText: label,
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : Colors.black38,
          fontSize: 14,
        ),
        filled: true,
        // ignore: deprecated_member_use
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? Colors.white10 : Colors.black12,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? accentCyan : Color(0xFF008CFF),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    bool isDark,
    String label,
    IconData icon,
    Color color,
  ) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
        backgroundColor: isDark ? Colors.transparent : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
