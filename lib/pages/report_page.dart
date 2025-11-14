import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';
import '../widgets/transaction_card.dart';
import '../widgets/summary_card.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<TransactionModel> transactions = [];
  String _filter = 'all';
  int totalIncome = 0;
  int totalExpense = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final list = await TransactionService.load();
    setState(() {
      transactions = list.reversed.toList();
      totalIncome = list
          .where((t) => t.type == 'income')
          .fold(0, (sum, t) => sum + t.amount);
      totalExpense = list
          .where((t) => t.type == 'expense')
          .fold(0, (sum, t) => sum + t.amount);
    });
  }

  List<TransactionModel> get filteredTransactions {
    if (_filter == 'income') {
      return transactions.where((t) => t.type == 'income').toList();
    } else if (_filter == 'expense') {
      return transactions.where((t) => t.type == 'expense').toList();
    }
    return transactions;
  }

  @override
  Widget build(BuildContext context) {
    final balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadTransactions,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SummaryCard(
              balance: balance,
              income: totalIncome,
              expense: totalExpense,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Transaksi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _filter,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Semua')),
                    DropdownMenuItem(value: 'income', child: Text('Pemasukan')),
                    DropdownMenuItem(value: 'expense', child: Text('Pengeluaran')),
                  ],
                  onChanged: (v) => setState(() => _filter = v!),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (filteredTransactions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Tidak ada transaksi.'),
                ),
              )
            else
              ...filteredTransactions.map((t) => TransactionCard(t: t)),
          ],
        ),
      ),
    );
  }
}
