import 'package:flutter/material.dart';
import '../models/saving_category.dart';
import '../utils/format.dart';

class SavingDetailPage extends StatefulWidget {
  final SavingCategory category;

  const SavingDetailPage({super.key, required this.category});

  @override
  State<SavingDetailPage> createState() => _SavingDetailPageState();
}

class _SavingDetailPageState extends State<SavingDetailPage> {
  List<Map<String, dynamic>> history = [];

  void _addAmount(bool isDeposit) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(isDeposit ? "Tambah Tabungan" : "Tarik Tabungan"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Jumlah (Rp)",
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
                if (controller.text.trim().isEmpty) return;

                final amount = int.tryParse(controller.text) ?? 0;
                if (amount <= 0) return;

                setState(() {
                  if (isDeposit) {
                    widget.category.balance += amount;
                  } else {
                    widget.category.balance -= amount;
                  }

                  history.insert(0, {
                    "amount": amount,
                    "type": isDeposit ? "deposit" : "withdraw",
                    "date": DateTime.now(),
                  });
                });

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _editTarget() {
    final controller = TextEditingController(
      text: widget.category.target.toString(),
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Ubah Target Tabungan"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Target (Rp)",
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
                final t = int.tryParse(controller.text) ?? widget.category.target;

                setState(() {
                  widget.category.target = t;
                });

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // use shared formatRupiah from utils/format.dart

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final progress = cat.target == 0
        ? 0.0
        : (cat.balance / cat.target).clamp(0, 1).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text(cat.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag),
            onPressed: _editTarget,
            tooltip: "Ubah Target",
          ),
        ],
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 150,
            child: FloatingActionButton.extended(
              heroTag: 'add',
              backgroundColor: Colors.green,
              icon: const Icon(Icons.add),
              label: const Text('Tambah'),
              onPressed: () => _addAmount(true),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 150,
            child: FloatingActionButton.extended(
              heroTag: 'withdraw',
              backgroundColor: Colors.red,
              icon: const Icon(Icons.remove),
              label: const Text('Tarik'),
              onPressed: () => _addAmount(false),
            ),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ------------------ TOTAL SALDO -------------------
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cat.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cat.color, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Saldo",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 6),
                Text(
                  formatRupiah(cat.balance),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),
          const Text(
            "Progress Target",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Target: ${formatRupiah(cat.target)}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                LinearProgressIndicator(
                  value: progress.toDouble(),
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade200,
                  color: cat.color,
                ),
                const SizedBox(height: 8),

                Text(
                  cat.target == 0
                      ? "Belum ada target"
                      : "${(progress * 100).toStringAsFixed(1)}% tercapai",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            "Riwayat Transaksi",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          if (history.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text("Belum ada transaksi"),
              ),
            )
          else
            ...history.map((h) {
              final isDeposit = h["type"] == "deposit";
              return Card(
                child: ListTile(
                  leading: Icon(
                    isDeposit ? Icons.add : Icons.remove,
                    color: isDeposit ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    (isDeposit ? "+ " : "- ") + formatRupiah(h["amount"]),
                  ),
                  subtitle: Text(
                    h["date"].toString().substring(0, 16),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
