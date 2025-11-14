import 'package:flutter/material.dart';
import '../models/saving_category.dart';
import '../widgets/saving_card.dart';
import 'saving_detail_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<SavingCategory> categories = [];

  final List<Color> defaultColors = [
    Colors.teal,
    Colors.orange,
    Colors.blue,
    Colors.purple,
    Colors.green,
    Colors.redAccent,
    Colors.indigo,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    categories = [
      SavingCategory(
        id: "1",
        name: "Dana Darurat",
        balance: 1_250_000,
        target: 5_000_000,
        color: defaultColors[0],
      ),
      SavingCategory(
        id: "2",
        name: "Tabungan Rumah",
        balance: 5_000_000,
        target: 50_000_000,
        color: defaultColors[1],
      ),
      SavingCategory(
        id: "3",
        name: "Liburan",
        balance: 800_000,
        target: 10_000_000,
        color: defaultColors[2],
      ),
    ];

    setState(() {});
  }

  void _addCategory() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();

        return AlertDialog(
          title: const Text("Tambah Kategori Tabungan"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Nama kategori",
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Simpan"),
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) return;

                final colorIndex =
                    categories.length % defaultColors.length;

                setState(() {
                  categories.add(
                    SavingCategory(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      balance: 0,
                      target: 0,
                      color: defaultColors[colorIndex],
                    ),
                  );
                });

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String formatRupiah(int value) {
    return "Rp ${value.toString()}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Tabungan"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Kategori Tabungan",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          if (categories.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text("Belum ada kategori tabungan"),
              ),
            )

          else
            ...categories.map(
              (cat) {
                return SavingCard(
                  category: cat,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SavingDetailPage(category: cat),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                );
              },
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: _addCategory,
        child: const Icon(Icons.add),
      ),
    );
  }
}
