import 'package:flutter_foodroute/edit_email.dart';
import 'package:flutter_foodroute/edit_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foodroute/log_in.dart'; // Ensure this path is correct

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Initial values jab tak memory se data load na ho jaye
  String username = "Loading...";
  String email = "User@email.com";

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Screen load hote hi data fetch karega
  }

  // SharedPreferences se username aur email nikalne ka function
  void _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Agar memory mein data nahi milta to default fallback values
      username = prefs.getString('username') ?? "Guest User";
      email = prefs.getString('email') ?? "saad.jawed@email.com";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF080C10),
          ), // Brand Dark
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings & Profile",
          style: TextStyle(
            color: Color(0xFF080C10),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Profile Card (Aapka existing method)
              _buildProfileCard(),
              const SizedBox(height: 25),

              // 2. Account Section
              _buildSectionHeader("Account"),
              _buildSettingsCard([
                _buildListTile(
                  Icons.email_outlined,
                  "Email Address",
                  email, // Aapka dynamic email variable
                  const Color(0xFF18FFFF), // Aapka Brand Cyan Color
                  onTap: () {
                    // EditEmail screen par navigate karne ke liye
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditEmail(),
                      ),
                    );
                  },
                ),
                // PASSWORD TILE: Navigation set kar di hai
                _buildListTile(
                  Icons.lock_outline,
                  "Password",
                  "Change password",
                  Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfile(),
                      ),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 25),

              // 3. Subscription Section
              _buildSectionHeader("Subscription"),
              _buildSettingsCard([
                _buildListTile(
                  Icons.workspace_premium_outlined,
                  "Plan Status",
                  "Active – 6-Month Plan",
                  Colors.orange,
                ),
              ]),

              const SizedBox(height: 25),

              // 4. Preferences Section
              _buildSectionHeader("Preferences"),
              _buildSettingsCard([
                _buildSwitchTile(
                  Icons.dark_mode_outlined,
                  "Dark Mode",
                  "Enable dark theme",
                  false,
                  const Color(0xFF3F51B5),
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  Icons.notifications_none_outlined,
                  "Notifications",
                  "Meal reminders & tips",
                  true,
                  const Color(0xFF3F51B5),
                ),
              ]),

              const SizedBox(height: 30),

              // 5. Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Log Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF008CFF),
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50), // Extra space at bottom
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D2A3A),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: const Color(0xFF3F51B5), // Your Cyan Color
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : "U",
                  style: const TextStyle(
                    color: Color.fromARGB(
                      255,
                      255,
                      255,
                      255,
                    ), // Your Dark Color
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username, // Variable name
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email, // Variable email
                      style: const TextStyle(color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Semicolon yahan zaroori hai
              }, // Bracket sahi band hona chahiye
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4F7F9),
                elevation: 0,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Edit Profile"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
      onTap: onTap, // Ab ye error nahi dega
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey, fontSize: 13),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    );
  }

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    String subtitle,
    bool val,
    Color iconColor,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Switch(
        value: val,
        activeThumbColor: const Color(0xFF3F51B5),
        onChanged: (value) {},
      ),
    );
  }
}
