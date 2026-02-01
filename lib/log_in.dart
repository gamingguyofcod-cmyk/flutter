import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foodroute/sign_up.dart';
import 'package:flutter_foodroute/meals.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Brand Colors
  final Color primaryDark = Color(0xFF080C10);
  final Color accentCyan = Color(0xFF18FFFF);
  final Color primaryCyan = Color(
    0xFF008CFF,
  ); // Standard Blue/Cyan for light mode

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            Center(child: CircularProgressIndicator(color: accentCyan)),
      );

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (!mounted) return;
        Navigator.pop(context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Meals()),
        );
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        Navigator.pop(context);

        String message = e.code == 'user-not-found'
            ? "No account found."
            : "Login failed. Check credentials.";

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
  Widget build(BuildContext context) {
    // Check if system is in Dark Mode
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        // Dynamic Background
        backgroundColor: isDark ? primaryDark : Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Icon(
                      Icons.restaurant_menu_rounded,
                      color: isDark ? accentCyan : primaryCyan,
                      size: 60,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Sign in to stay healthy",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 50),

                    _buildTextField(
                      isDark: isDark,
                      label: "Email Address",
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      validator: (value) =>
                          (value == null || value.isEmpty) ? "Required" : null,
                    ),
                    SizedBox(height: 20),

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
                      validator: (value) =>
                          (value == null || value.isEmpty) ? "Required" : null,
                    ),

                    SizedBox(height: 40),

                    // LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? accentCyan : primaryCyan,
                          foregroundColor: isDark ? primaryDark : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _handleLogin,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
                          padding: EdgeInsets.symmetric(horizontal: 15),
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

                    Row(
                      children: [
                        Expanded(
                          child: _buildSocialButton(
                            isDark,
                            "Google",
                            Icons.g_mobiledata,
                            Colors.redAccent,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: _buildSocialButton(
                            isDark,
                            "Facebook",
                            Icons.facebook,
                            Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 50),

                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: isDark ? accentCyan : primaryCyan,
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
          color: isDark ? accentCyan : primaryCyan,
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
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? Colors.white10 : Colors.black12,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? accentCyan : primaryCyan,
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
        padding: EdgeInsets.symmetric(vertical: 15),
        side: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
