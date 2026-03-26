      import 'package:expiro_project/screens/settingScreen.dart';
     import 'package:flutter/material.dart';



     class SettingScreen  extends StatelessWidget {
     const SettingScreen({super.key});

     @override
     Widget build(BuildContext context) {
     return MaterialApp(
     title: 'Settings',
     debugShowCheckedModeBanner: false,
     theme: ThemeData(
     colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
     useMaterial3: true,
     fontFamily: 'Roboto',
     ),
     home: const SettingsScreen(),
     );
     }
     }

     class SettingsScreen extends StatefulWidget {
     const SettingsScreen({super.key});

     @override
     State<SettingsScreen> createState() => _SettingsScreenState();
     }

     class _SettingsScreenState extends State<SettingsScreen> {
     bool _darkMode = false;
     bool _notificationsEnabled = true;
     String _selectedDays = '3 days';

     final List<String> _dayOptions = [
     '1 day',
     '2 days',
     '3 days',
     '5 days',
     '7 days',
     ];

     void _showExportDialog() {
     showDialog(
     context: context,
     builder: (context) => AlertDialog(
     title: const Text('Export Data'),
     content: const Text('Your data has been exported successfully.'),
     actions: [
     TextButton(
     onPressed: () => Navigator.pop(context),
     child: const Text('OK'),
     ),
     ],
     ),
     );
     }

     void _showClearDialog() {
     showDialog(
     context: context,
     builder: (context) => AlertDialog(
     title: const Text('Clear All Items'),
     content: const Text(
     'Are you sure you want to clear all items? This action cannot be undone.'),
     actions: [
     TextButton(
     onPressed: () => Navigator.pop(context),
     child: const Text('Cancel'),
     ),
     TextButton(
     onPressed: () => Navigator.pop(context),
     style: TextButton.styleFrom(foregroundColor: Colors.red),
     child: const Text('Clear'),
     ),
     ],
     ),
     );
     }

     @override
     Widget build(BuildContext context) {
     return Scaffold(
     backgroundColor: Colors.white,
     body: SafeArea(
     child: Column(
     children: [
     // Content
     Expanded(
     child: SingleChildScrollView(
     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
     child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
     // Header
     const Text(
     'Settings',
     style: TextStyle(
     fontSize: 28,
     fontWeight: FontWeight.bold,
     color: Colors.black,
     ),
     ),
     const SizedBox(height: 4),
     const Text(
     'Customize your experience',
     style: TextStyle(
     fontSize: 14,
     color: Colors.black54,
     ),
     ),
     const SizedBox(height: 24),

     // ─── Appearance Section ───
     _SectionCard(
     header: Row(
     children: const [
     Icon(Icons.wb_sunny_outlined, size: 20),
     SizedBox(width: 10),
     Text(
     'Appearance',
     style: TextStyle(
     fontSize: 17,
     fontWeight: FontWeight.w600,
     ),
     ),
     ],
     ),
     children: [
     _SettingsTile(
      title: 'Dark Mode',
     subtitle: 'Switch between light and dark themes',
     trailing: Switch(
     value: _darkMode,
     onChanged: (val) => setState(() => _darkMode = val),
     activeColor: Colors.black,
     ),
     ),
     ],
     ),

     const SizedBox(height: 16),

     // ─── Notifications Section ───
     _SectionCard(
     header: Row(
     children: const [
     Icon(Icons.notifications_outlined, size: 20),
     SizedBox(width: 10),
     Text(
     'Notifications',
     style: TextStyle(
     fontSize: 17,
     fontWeight: FontWeight.w600,
     ),
     ),
     ],
     ),
     children: [
     _SettingsTile(
     title: 'Enable Notifications',
     subtitle: 'Get notified about expiring items',
     trailing: Switch(
     value: _notificationsEnabled,
     onChanged: (val) =>
     setState(() => _notificationsEnabled = val),
     activeColor: Colors.black,
     ),
     ),
     const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
     Padding(
     padding: const EdgeInsets.symmetric(
     horizontal: 16, vertical: 14),
     child: Row(
     children: [
     const Expanded(
     child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
     Text(
     'Notify me when items expire in',
     style: TextStyle(
     fontSize: 15,
     fontWeight: FontWeight.w500,
     ),
     ),
     SizedBox(height: 2),
     Text(
     'Days before expiration',
     style: TextStyle(
     fontSize: 13,
     color: Colors.black54,
     ),
     ),
     ],
     ),
     ),
     const SizedBox(width: 12),
     Container(
     padding: const EdgeInsets.symmetric(
     horizontal: 14, vertical: 8),
     decoration: BoxDecoration(
     color: const Color(0xFFF2F2F2),
     borderRadius: BorderRadius.circular(10),
     ),
     child: DropdownButtonHideUnderline(
     child: DropdownButton<String>(
     value: _selectedDays,
     icon: const Icon(Icons.keyboard_arrow_down,
      size: 20),
     isDense: true,
     style: const TextStyle(
     color: Colors.black,
     fontSize: 15,
     fontWeight: FontWeight.w500,
     ),
     onChanged: (val) =>
     setState(() => _selectedDays = val!),
     items: _dayOptions
         .map((d) => DropdownMenuItem(
     value: d,
     child: Text(d),
     ))
         .toList(),
     ),
     ),
     ),
     ],
     ),
     ),
     ],
     ),

     const SizedBox(height: 16),

     // ─── Data Management Section ───
     _SectionCard(
     header: Row(
     children: const [
     Icon(Icons.download_outlined, size: 20),
     SizedBox(width: 10),
     Text(
     'Data Management',
     style: TextStyle(
     fontSize: 17,
     fontWeight: FontWeight.w600,
     ),
     ),
     ],
     ),
     children: [
     Padding(
     padding: const EdgeInsets.symmetric(
     horizontal: 16, vertical: 12),
     child: Column(
     children: [
     _OutlinedActionButton(
     icon: Icons.download_outlined,
     label: 'Export Data',
     onTap: _showExportDialog,
     ),
     const SizedBox(height: 10),
     _OutlinedActionButton(
     icon: Icons.delete_outline,
     label: 'Clear All Items',
     onTap: _showClearDialog,
     ),
     ],
     ),
     ),
     ],
     ),

     const SizedBox(height: 16),

     // ─── About Section ───
     _SectionCard(
     header: Row(
     children: const [
     Icon(Icons.info_outline, size: 20),
     SizedBox(width: 10),
     Text(
     'About',
     style: TextStyle(
     fontSize: 17,
     fontWeight: FontWeight.w600,
     ),
     ),
     ],
     ),
     children: [
     _InfoRow(label: 'Version', value: '1.0.0'),
     const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
     _InfoRow(label: 'Storage', value: 'Local Device'),
     ],
     ),

     const SizedBox(height: 16),

     // ─── Info Banner ───
      Container(
     padding: const EdgeInsets.all(16),
     decoration: BoxDecoration(
     border: Border.all(color: const Color(0xFFE0E0E0)),
     borderRadius: BorderRadius.circular(12),
     ),
     child: Row(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: const [
     Icon(Icons.info_outline, size: 20, color: Colors.black54),
     SizedBox(width: 10),
     Expanded(
     child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
     Text(
     'Your data is stored locally',
     style: TextStyle(
     fontSize: 14,
     fontWeight: FontWeight.w600,
     ),
     ),
     SizedBox(height: 4),
     Text(
     'All your items are saved on your device. Export your data regularly to keep a backup.',
     style: TextStyle(
     fontSize: 13,
     color: Colors.black54,
     height: 1.4,
     ),
     ),
     ],
     ),
     ),
     ],
     ),
     ),

     const SizedBox(height: 24),
     ],
     ),
     ),
     ),

     // ─── Bottom Navigation Bar ───

     ],
     ),
     ),
     );
     }
     }

     // ─────────────────────────────────────────────
     // Helper Widgets
     // ─────────────────────────────────────────────

     class _SectionCard extends StatelessWidget {
     final Widget header;
     final List<Widget> children;

     const _SectionCard({required this.header, required this.children});

     @override
     Widget build(BuildContext context) {
     return Container(
      decoration: BoxDecoration(
     border: Border.all(color: const Color(0xFFD0D0D0)),
     borderRadius: BorderRadius.circular(12),
     ),
     child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
     // Section header
     Padding(
     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
     child: header,
     ),
     const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
     ...children,
     ],
     ),
     );
     }
     }

     class _SettingsTile extends StatelessWidget {
     final String title;
     final String subtitle;
     final Widget trailing;

     const _SettingsTile({
     required this.title,
     required this.subtitle,
     required this.trailing,
     });

     @override
     Widget build(BuildContext context) {
     return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
     child: Row(
     children: [
     Expanded(
     child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
     Text(
     title,
     style: const TextStyle(
     fontSize: 15,
     fontWeight: FontWeight.w500,
     ),
     ),
     const SizedBox(height: 2),
     Text(
     subtitle,
     style: const TextStyle(
     fontSize: 13,
     color: Colors.black54,
     ),
     ),
     ],
     ),
     ),
     trailing,
     ],
     ),
     );
     }
     }

     class _OutlinedActionButton extends StatelessWidget {
     final IconData icon;
     final String label;
     final VoidCallback onTap;

     const _OutlinedActionButton({
     required this.icon,
     required this.label,
     required this.onTap,
     });

     @override
     Widget build(BuildContext context) {
     return GestureDetector(
     onTap: onTap,
     child: Container(
     width: double.infinity,
     padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
     decoration: BoxDecoration(
     border: Border.all(color: const Color(0xFFD0D0D0)),
     borderRadius: BorderRadius.circular(10),
     ),
     child: Row(
     children: [
     Icon(icon, size: 20),
     const SizedBox(width: 10),
     Text(
     label,
     style: const TextStyle(
     fontSize: 15,
     fontWeight: FontWeight.w500,
     ),
     ),
     ],
     ),
     ),
     );
     }
     }

     class _InfoRow extends StatelessWidget {
     final String label;
     final String value;

     const _InfoRow({required this.label, required this.value});

     @override
     Widget build(BuildContext context) {
     return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
     child: Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [
     Text(
     label,
     style: const TextStyle(fontSize: 15, color: Colors.black54),
     ),
     Text(
     value,
     style: const TextStyle(
     fontSize: 15,
     fontWeight: FontWeight.w500,
     ),
     ),
     ],
     ),
     );
     }
     }