import 'package:firebase_auth/firebase_auth.dart'; // Logout aur Current User ke liye
import 'package:flutter_foodroute/edit_email.dart';
import 'package:flutter_foodroute/edit_password.dart';
import 'package:flutter_foodroute/main.dart'; // themeNotifier ke liye
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodroute/log_in.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String username = "Loading...";
  String email = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // --- LOGIC: AB YE SAHI EMAIL UTHAYEGA ---
  void _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Firebase se current user lo taaki real email mil sakay
    final User? currentUser = FirebaseAuth.instance.currentUser;

    setState(() {
      username = prefs.getString('username') ?? "Guest User";

      // Pehle Firebase check karo, agar wahan nahi to SharedPreferences
      email =
          currentUser?.email ?? prefs.getString('email') ?? "No Email Found";
    });
  }

  // --- LOGOUT LOGIC ---
  Future<void> _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Color(0xFF080C10),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Settings & Profile",
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF080C10),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Profile Card
              _buildProfileCard(isDark),
              SizedBox(height: 25),

              // 2. Account Section
              _buildSectionHeader("Account", isDark),
              _buildSettingsCard([
                _buildListTile(
                  Icons.email_outlined,
                  "Email Address",
                  email, // <--- Corrected Email
                  Color(0xFF18FFFF),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditEmail()),
                  ),
                ),
                _buildListTile(
                  Icons.lock_outline,
                  "Password",
                  "Change password",
                  Colors.green,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfile()),
                  ),
                ),
              ], isDark),
              SizedBox(height: 25),

              // 3. Subscription Section
              _buildSectionHeader("Subscription", isDark),
              _buildSettingsCard([
                _buildListTile(
                  Icons.workspace_premium_outlined,
                  "Plan Status",
                  "Active – 6-Month Plan",
                  Colors.orange,
                ),
              ], isDark),

              SizedBox(height: 25),

              // 4. Preferences Section
              _buildSectionHeader("Preferences", isDark),
              _buildSettingsCard([
                _buildSwitchTile(
                  Icons.dark_mode_outlined,
                  "Dark Mode",
                  "Enable dark theme",
                  themeNotifier.value == ThemeMode.dark,
                  Color(0xFF3F51B5),
                  (bool val) {
                    setState(() {
                      themeNotifier.value = val
                          ? ThemeMode.dark
                          : ThemeMode.light;
                    });
                  },
                ),
                Divider(height: 1),
                _buildSwitchTile(
                  Icons.notifications_none_outlined,
                  "Notifications",
                  "Meal reminders & tips",
                  true,
                  Color(0xFF3F51B5),
                  (bool val) {
                    // Handle notifications
                  },
                ),
              ], isDark),

              SizedBox(height: 30),

              // 5. Logout Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _handleLogout,
                    icon: Icon(Icons.logout, color: Colors.white),
                    label: Text(
                      "Log Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF008CFF),
                      padding: EdgeInsets.symmetric(vertical: 17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets (Exact Same UI as you provided) ---

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(left: 5, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white70 : Color(0xFF1D2A3A),
        ),
      ),
    );
  }

  Widget _buildProfileCard(bool isDark) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1A1F24) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Color(0xFF18FFFF),
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : "U",
                  style: TextStyle(
                    color: Color(0xFF080C10),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      email, // <--- Corrected Email
                      style: TextStyle(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.white10 : Color(0xFFF4F7F9),
                elevation: 0,
                foregroundColor: isDark ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("Edit Profile Info"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1A1F24) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title,
    String subtitle,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        // ignore: deprecated_member_use
        backgroundColor: iconColor.withOpacity(0.1),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey, fontSize: 13),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    );
  }

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    String subtitle,
    bool val,
    Color iconColor,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: Switch(
        value: val,
        activeThumbColor: Color(0xFF18FFFF),
        onChanged: onChanged,
      ),
    );
  }
}
