import 'package:expiro_project/screens/settingScreen.dart';
import 'package:flutter/material.dart';

import 'homeScreen.dart';
import 'login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - استبدلها ببيانات حقيقية من الـ backend
    const String userName = 'Yousef Metwally';
    const String userEmail = 'yousef@example.com';
    const int totalReminders = 12;
    const int expiringSoon = 3; // خلال 7 أيام

    final List<Map<String, dynamic>> expiringSoonList = [
      {'title': 'Meat', 'daysLeft': 2, 'icon': Icons.set_meal},
      {'title': 'Panadol', 'daysLeft': 5, 'icon': Icons.medical_services_outlined},
      {'title': 'Eye liner', 'daysLeft': 7, 'icon': Icons.brush},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF001B30),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildUserInfo(userName, userEmail),
            _buildStatsRow(totalReminders, expiringSoon),
            _buildExpiringSoonSection(expiringSoonList),
            _buildSettingsSection(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 20,), onPressed:  () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const HomeScreen())),),
              ),
            ),
            const Text('Profile',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(width: 36),
          ],
        ),
      ),
    );
  }

  // ─── User Info ────────────────────────────────────────────
  Widget _buildUserInfo(String name, String email) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
              ),
              border: Border.all(color: const Color(0xFF1A1A2E), width: 3),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 14),
          Text(name,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(email,
              style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 13)),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF6C63FF)),
            label: const Text('Edit Profile',
                style: TextStyle(color: Color(0xFF6C63FF), fontSize: 13)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF6C63FF), width: 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
  // ─── Stats Row ────────────────────────────────────────────
  Widget _buildStatsRow(int total, int expiring) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _statCard(
            total.toString(), 'All Reminders',
            Icons.notifications_outlined,
            const Color(0xFF6C63FF),
          )),
          const SizedBox(width: 5),
          Expanded(child: _statCard(
            expiring.toString(), 'Expiring Soon',
            Icons.warning_amber_rounded,
            const Color(0xFFFF6B6B),
          )),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
              Text(label,
                  style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Expiring Soon ────────────────────────────────────────
  Widget _buildExpiringSoonSection(List<Map<String, dynamic>> items) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_filled, color: Color(0xFFFF6B6B), size: 18),
              const SizedBox(width: 5),
              const Text('Expiring Soon',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Text('See all',
                    style: TextStyle(color: Color(0xFF6C63FF), fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => _expiringItem(item)),
        ],
      ),
    );
  }

  Widget _expiringItem(Map<String, dynamic> item) {
    final int days = item['daysLeft'];
    final Color urgencyColor = days <= 2
        ? const Color(0xFFFF6B6B)
        : days <= 5
        ? const Color(0xFFFFB347)
        : const Color(0xFF3ECFCF);

    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: urgencyColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
          Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: urgencyColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(item['icon'] as IconData, color: urgencyColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
        child: Text(item['title'],
        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: urgencyColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                days == 1 ? '1 day left' : '$days days left',
                style: TextStyle(color: urgencyColor, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
    );
  }

  // ─── Settings ─────────────────────────────────────────────
  Widget _buildSettingsSection(BuildContext context) {
    final settings = [
      {'icon': Icons.notifications_outlined, 'label': 'Notification Settings', 'color': const Color(0xFF6C63FF)},
      {'icon': Icons.palette_outlined,       'label': 'Appearance',             'color': const Color(0xFF3ECFCF)},
      {'icon': Icons.backup_outlined,        'label': 'Backup & Restore',       'color': const Color(0xFFFFB347)},
      {'icon': Icons.logout,                 'label': 'Log Out',                'color': const Color(0xFFFF6B6B)},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings',
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              children: List.generate(settings.length, (i) {
                final s = settings[i];
                final isLast = i == settings.length - 1;
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        if (s['label'] == 'Log Out') {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                                (route) => false,
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SettingsScreen()),
                          );
                        }
                      },
                      leading: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: (s['color'] as Color).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 18),
                      ),
                      title: Text(s['label'] as String,
                          style: TextStyle(
                            color: s['label'] == 'Log Out' ? const Color(0xFFFF6B6B) : Colors.white,
                            fontSize: 14,
                          )),
                      trailing: s['label'] != 'Log Out'
                          ? Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.25), size: 20)
                          : null,
                    ),
                    if (!isLast)
                      Divider(height: 1, color: Colors.white.withOpacity(0.06), indent: 60),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
