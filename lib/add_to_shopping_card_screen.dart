import 'package:flutter/material.dart';

class ShoppingItem {
  String name;
  String quantity;
  bool isCompleted;
  String category;

  ShoppingItem({
    required this.name,
    required this.quantity,
    this.isCompleted = false,
    required this.category,
  });
}

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  // Brand Colors
  final Color primaryDark = Color(0xFF080C10);
  final Color accentCyan = Color(0xFF18FFFF);
  final Color brandBlue = Color(0xFF008CFF);

  final List<ShoppingItem> _items = [
    ShoppingItem(
      name: "Mixed green salad",
      quantity: "4 Cups",
      category: "Veggies",
    ),
    ShoppingItem(
      name: "Cherry tomatoes",
      quantity: "1 Cup",
      category: "Veggies",
    ),
    ShoppingItem(
      name: "Chicken breast",
      quantity: "4 pieces",
      category: "Protein",
    ),
    ShoppingItem(name: "Olive oil", quantity: "1 bottle", category: "Other"),
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  void _addNewItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? primaryDark
              : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add New Item",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : primaryDark,
              ),
            ),
            SizedBox(height: 20),
            _buildDialogField(_nameController, "Item Name (e.g. Milk)"),
            SizedBox(height: 12),
            _buildDialogField(_qtyController, "Quantity (e.g. 2 liters)"),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandBlue,
                minimumSize: Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  setState(() {
                    _items.add(
                      ShoppingItem(
                        name: _nameController.text,
                        quantity: _qtyController.text,
                        category: "Other",
                      ),
                    );
                  });
                  _nameController.clear();
                  _qtyController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Add to List",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogField(TextEditingController controller, String hint) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      style: TextStyle(color: isDark ? Colors.white : primaryDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: isDark ? Colors.white10 : Color(0xFFF4F7F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final activeItems = _items.where((i) => !i.isCompleted).toList();
    final completedItems = _items.where((i) => i.isCompleted).toList();

    return Scaffold(
      backgroundColor: isDark ? primaryDark : Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Shopping List",
          style: TextStyle(
            color: isDark ? Colors.white : primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
            onPressed: () => setState(() => _items.clear()),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          if (_items.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_basket_outlined,
                      size: 80,
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Your list is empty!",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

          ...activeItems.map((item) => _buildDismissibleItem(item, isDark)),

          if (completedItems.isNotEmpty) ...[
            SizedBox(height: 32),
            Row(
              children: [
                Text(
                  "COMPLETED",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 10),
                // ignore: deprecated_member_use
                Expanded(child: Divider(color: Colors.grey.withOpacity(0.2))),
              ],
            ),
            SizedBox(height: 16),
            ...completedItems.map(
              (item) => _buildDismissibleItem(item, isDark),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: brandBlue,
        elevation: 4,
        onPressed: _addNewItem,
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildDismissibleItem(ShoppingItem item, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ObjectKey(item),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.delete_forever, color: Colors.white),
        ),
        onDismissed: (_) => setState(() => _items.remove(item)),
        child: GestureDetector(
          onTap: () => setState(() => item.isCompleted = !item.isCompleted),
          child: Container(
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.isCompleted
                      // ignore: deprecated_member_use
                      ? Colors.green.withOpacity(0.2)
                      // ignore: deprecated_member_use
                      : accentCyan.withOpacity(0.1),
                ),
                padding: EdgeInsets.all(8),
                child: Icon(
                  item.isCompleted ? Icons.check : Icons.shopping_cart_outlined,
                  color: item.isCompleted ? Colors.green : brandBlue,
                  size: 20,
                ),
              ),
              title: Text(
                item.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  decoration: item.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                  color: item.isCompleted
                      ? Colors.grey
                      : (isDark ? Colors.white : primaryDark),
                ),
              ),
              trailing: Text(
                item.quantity,
                style: TextStyle(
                  color: brandBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
