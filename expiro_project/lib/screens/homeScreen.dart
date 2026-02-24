import 'package:expiro_project/screens/profileScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum ItemStatus { expired, soon, fresh }

enum ProductType { food, dairy, meat, vegetables, medicine, cosmetics, household, other }

extension ProductTypeExt on ProductType {
  String get label {
    switch (this) {
      case ProductType.food:        return 'Food';
      case ProductType.dairy:       return 'Dairy';
      case ProductType.meat:        return 'Meat';
      case ProductType.vegetables:  return 'Vegetables';
      case ProductType.medicine:    return 'Medicine';
      case ProductType.cosmetics:   return 'Cosmetics';
      case ProductType.household:   return 'Household';
      case ProductType.other:       return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ProductType.food:        return Icons.apple_outlined;
      case ProductType.dairy:       return Icons.water_drop_outlined;
      case ProductType.meat:        return Icons.set_meal_outlined;
      case ProductType.vegetables:  return Icons.eco_outlined;
      case ProductType.medicine:    return Icons.medication_outlined;
      case ProductType.cosmetics:   return Icons.auto_awesome_outlined;
      case ProductType.household:   return Icons.home_outlined;
      case ProductType.other:       return Icons.inventory_2_outlined;
    }
  }
}

class Item {
  final int id;
  final String name;
  final ProductType type;
  final DateTime expiryDate;

  Item({
    required this.id,
    required this.name,
    required this.type,
    required this.expiryDate,
  });

  int get daysLeft {
    final now = DateTime.now();
    return expiryDate.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  ItemStatus get status {
    if (daysLeft < 0) return ItemStatus.expired;
    if (daysLeft <= 3) return ItemStatus.soon;
    return ItemStatus.fresh;
  }

  Color get statusColor {
    switch (status) {
      case ItemStatus.expired: return const Color(0xFFE53935);
      case ItemStatus.soon:    return const Color(0xFFFF7043);
      case ItemStatus.fresh:   return const Color(0xFF43A047);
    }
  }

  String get statusLabel {
    switch (status) {
      case ItemStatus.expired: return 'Expired';
      case ItemStatus.soon:    return 'Soon';
      case ItemStatus.fresh:   return 'Fresh';
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Item> _items = [];
  int _idCounter = 0;
  String _filter = 'All';
  List<Item> get _filteredItems {
    return _items.where((item) {
      if (_filter == 'Expired') return item.status == ItemStatus.expired;
      if (_filter == 'Soon')    return item.status == ItemStatus.soon;
      if (_filter == 'Fresh')   return item.status == ItemStatus.fresh;
      return true;
    }).toList();
  }

  int get totalCount   => _items.length;
  int get expiredCount => _items.where((e) => e.status == ItemStatus.expired).length;
  int get soonCount    => _items.where((e) => e.status == ItemStatus.soon).length;

  void _addItem(String name, ProductType type, DateTime expiry) {
    setState(() {
      _items.add(Item(id: _idCounter++, name: name, type: type, expiryDate: expiry));
    });
  }

  void _deleteItem(int id) {
    setState(() => _items.removeWhere((e) => e.id == id));
  }

  void _openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddItemSheet(
        onAdd: (name, type, date) => _addItem(name, type, date),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHome(),
      _buildStats(),
      _buildSettings(),
    ];

    return Scaffold(
    backgroundColor: const Color(0xFFF2F2F2),
    body: pages[_currentIndex],
    bottomNavigationBar: BottomNavigationBar(
    currentIndex: _currentIndex,
    onTap: (i) => setState(() => _currentIndex = i),
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
    items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined,color:Color(
        0xFFA69393) ,),
        activeIcon: Icon(Icons.home,color:Color(0xFF000000)),      label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined,color:Color(
        0xFFA59292)),
        activeIcon: Icon(Icons.bar_chart,color:Color(0xFF000000)), label: 'Stats'),
    BottomNavigationBarItem(icon: Icon(Icons.settings_outlined,color:Color(
        0xFFA49191)),
        activeIcon: Icon(Icons.settings,color:Color(0xFF000000)),  label: 'Settings'),],),);}

  Widget _buildHome() {
    final items = _filteredItems;

    return SafeArea(
      child: Column(
        children: [
          // AppBar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Expiration Tracker',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                      Text('Never let things go to waste',
                          style: TextStyle(fontSize: 12, color: Colors.black45)),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
                IconButton(icon: const Icon(Icons.person_outline, color: Colors.black), onPressed:  () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const ProfilePage())),),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Stat Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _StatCard(value: '$totalCount',   label: 'Total Items',    color: Colors.green),
                const SizedBox(width: 10),
                _StatCard(value: '$expiredCount', label: 'Expiring Soon',        color: Colors.yellow),
                const SizedBox(width: 10),
                _StatCard(value: '$soonCount',    label: 'Expired',  color: Colors.red),
              ],
            ),
          ),

          const SizedBox(height: 14),


// Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: ['All', 'Expired', 'Soon', 'Fresh'].map((f) {
                  final active = _filter == f;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: active ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: active ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
                        ),
                        child: Center(
                          child: Text(f,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                                color: active ? Colors.black : Colors.grey,
                              )),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Items List
          Expanded(
            child: items.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.filter_alt_outlined, size: 60, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text('No items yet. Add your first item!',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                final daysText = item.daysLeft < 0
                    ? 'Expired ${-item.daysLeft} day(s) ago'
                    : item.daysLeft == 0
                    ? 'Expires today'
                    : 'Expires in ${item.daysLeft} day(s)';

                return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))
                ],
                ),
                child: Row(
                children: [
                Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                color: item.statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.type.icon, color: item.statusColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(item.name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(item.type.label,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 2),
                Text(daysText,
                style: TextStyle(
                color: item.statusColor, fontSize: 12, fontWeight: FontWeight.w500)),
                ],
                ),
                ),
                Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                color: item.statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                ),
                child: Text(item.statusLabel,
                style: TextStyle(
                color: item.statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                onTap: () => _deleteItem(item.id),
                child: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                ),
                ],
                ),
                );
                },
            ),
          ),

          // Add Item Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _openAddSheet,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add Item',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final fresh = totalCount - expiredCount - soonCount;

    return SafeArea(
    child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text('Stats', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    const SizedBox(height: 20),
    if (totalCount == 0)
    const Expanded(child: Center(child: Text('No data yet.', style: TextStyle(color: Colors.grey))))
    else ...[
    _StatsRow(label: 'Total Items',   value: totalCount,   color: const Color(0xFF43A047)),
    _StatsRow(label: 'Fresh',         value: fresh,        color: const Color(0xFF43A047)),
    _StatsRow(label: 'Expiring Soon', value: soonCount,    color: const Color(0xFFFF7043)),
    _StatsRow(label: 'Expired',       value: expiredCount, color: const Color(0xFFE53935)),
    const SizedBox(height: 20),
    const Text('By Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    const SizedBox(height: 10),
    ...ProductType.values.map((type) {
    final count = _items.where((i) => i.type == type).length;
    if (count == 0) return const SizedBox.shrink();
    return _StatsRow(label: type.label, value: count, color: const Color(0xFF546E7A));
    }),
    ],
    ],
    ),
    ),
    );
  }

  Widget _buildSettings() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _SettingTile(title: 'Notifications', subtitle: 'Get alerts before items expire', trailing: Switch(value: true, onChanged: (_) {}, activeColor: Colors.black)),
            _SettingTile(title: 'Version',       subtitle: '1.0.0',                          trailing: const SizedBox()),
            _SettingTile(title: 'Privacy Policy', subtitle: '',                              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCard({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatsRow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingTile({required this.title, required this.subtitle, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Add Item Bottom Sheet
// ─────────────────────────────────────────────

class AddItemSheet extends StatefulWidget {
  final void Function(String name, ProductType type, DateTime date) onAdd;

  const AddItemSheet({super.key, required this.onAdd});

  @override
  State<AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<AddItemSheet> {
  ProductType _selectedType = ProductType.food;
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.black),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an expiration date')),
      );
      return;
    }
    widget.onAdd(_nameController.text.trim(), _selectedType, _selectedDate!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 18),

// Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Add New Item',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Product Type label
              const Text('Product Type',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),

              // Product Type Grid
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.88,
                children: ProductType.values.map((type) {
                  final selected = _selectedType == type;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFFF5F5F5) : Colors.white,
                        border: Border.all(
                          color: selected ? Colors.black : Colors.grey.shade200,
                          width: selected ? 1.5 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          if (selected)
                            const Positioned(
                              top: 5,
                              right: 5,
                              child: Icon(Icons.check, size: 11, color: Colors.black54),
                            ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(type.icon,
                                    size: 24,
                                    color: selected ? Colors.black : Colors.grey.shade500),
                                const SizedBox(height: 5),
                                Text(type.label,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: selected ? Colors.black : Colors.grey.shade500,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

// Item Name
              const Text('Item Name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Milk, Medicine, Face Cream',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter item name' : null,
              ),
              const SizedBox(height: 14),

              // Expiration Date
              const Text('Expiration Date',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'mm/dd/yyyy'
                              : '${_selectedDate!.month.toString().padLeft(2, '0')}/'
                              '${_selectedDate!.day.toString().padLeft(2, '0')}/'
                              '${_selectedDate!.year}',
                          style: TextStyle(
                            fontSize: 14,
                            color: _selectedDate == null
                                ? Colors.grey.shade400
                                : Colors.black,
                          ),
                        ),
                      ),
                      Icon(Icons.calendar_today_outlined,
                          color: Colors.grey.shade500, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Submit
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Add Item',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}