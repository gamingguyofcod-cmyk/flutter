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
  // --- Data List ---
  final List<ShoppingItem> _items = [
    ShoppingItem(
      name: "Mixed green salad",
      quantity: "4 Cups",
      category: "Fruits & Veggies",
    ),
    ShoppingItem(
      name: "Cherry tomatoes",
      quantity: "1 Cup",
      category: "Fruits & Veggies",
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

  // --- 1. Add Functionality ---
  void _addNewItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add New Item",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: "Item Name"),
            ),
            TextField(
              controller: _qtyController,
              decoration: const InputDecoration(
                hintText: "Quantity (e.g. 2 kg)",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008CFF),
                minimumSize: const Size(double.infinity, 50),
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
              child: const Text(
                "Add to List",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Separate active and completed items
    final activeItems = _items.where((i) => !i.isCompleted).toList();
    final completedItems = _items.where((i) => i.isCompleted).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Shopping List",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => setState(() => _items.clear()), // Clear All
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (activeItems.isEmpty && completedItems.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  "Your list is empty!",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),

          ...activeItems.map((item) => _buildDismissibleItem(item)),

          if (completedItems.isNotEmpty) ...[
            const SizedBox(height: 30),
            const Text(
              "COMPLETED",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const Divider(),
            ...completedItems.map((item) => _buildDismissibleItem(item)),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF008CFF),
        onPressed: _addNewItem,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- 2. Swipe to Delete Wrapper ---
  Widget _buildDismissibleItem(ShoppingItem item) {
    return Dismissible(
      key: Key(item.name + DateTime.now().toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() => _items.remove(item));
      },
      child: _buildItemCard(item),
    );
  }

  // --- 3. Interactive Item Card ---
  Widget _buildItemCard(ShoppingItem item) {
    return GestureDetector(
      onTap: () => setState(() => item.isCompleted = !item.isCompleted),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5),
          ],
        ),
        child: ListTile(
          leading: Icon(
            item.isCompleted
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: item.isCompleted ? Colors.green : Colors.blue,
          ),
          title: Text(
            item.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration: item.isCompleted ? TextDecoration.lineThrough : null,
              color: item.isCompleted ? Colors.grey : Colors.black87,
            ),
          ),
          trailing: Text(
            item.quantity,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
