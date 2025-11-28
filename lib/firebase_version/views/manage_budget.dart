import 'package:flutter/material.dart';
import 'package:flutter_application_finote/firebase_version/models/budget_model_firebase.dart';
import 'package:flutter_application_finote/firebase_version/service/firebase.dart';

class ManageBudgetPage extends StatelessWidget {
  const ManageBudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Budget Pengeluaran",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff2F59AB),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: StreamBuilder<List<BudgetModelFirebase>>(
        stream: BudgetService().getBudgets(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final budgets = snapshot.data!;

          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: ElevatedButton(
                child: Text("Tambahkan Budget Awal"),
                onPressed: () async {
                  await BudgetService().saveBudget("Makan & Minum", 1500000);
                  await BudgetService().saveBudget("Transportasi", 1200000);
                  await BudgetService().saveBudget("Hiburan", 1000000);
                  await BudgetService().saveBudget("Tagihan", 1200000);
                  await BudgetService().saveBudget("Belanja", 1000000);
                  await BudgetService().saveBudget("Lainnya", 1000000);
                },
              ),
            );
          }

          print("Budget snapshot: ${snapshot.data}");

          return ListView(
            padding: const EdgeInsets.all(16),
            children: budgets.map((b) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade50, Colors.blue.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _iconPengeluaran(b.kategori),
                      color: Colors.blue.shade700,
                      size: 26,
                    ),
                  ),

                  title: Text(
                    b.kategori,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xff1A3C57),
                    ),
                  ),

                  subtitle: Text(
                    "Target Budget: Rp ${b.targetValue.toInt()}",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                  ),

                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue.shade700),
                    onPressed: () => showEditDialog(context, b),
                  ),

                  onTap: () => showEditDialog(context, b),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void showEditDialog(BuildContext context, BudgetModelFirebase b) {
    final controller = TextEditingController(
      text: b.targetValue.toInt().toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 218, 235, 255),
        title: Text("Edit Budget ${b.kategori}"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: "Target Budget"),
        ),
        actions: [
          TextButton(
            child: Text("Batal", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Simpan", style: TextStyle(color: Colors.green)),
            onPressed: () async {
              final newValue =
                  double.tryParse(controller.text) ?? b.targetValue;

              await BudgetService().saveBudget(b.kategori, newValue);

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

IconData _iconPengeluaran(String kategori) {
  switch (kategori) {
    case "Makan & Minum":
      return Icons.fastfood;
    case "Transportasi":
      return Icons.motorcycle;
    case "Hiburan":
      return Icons.sports_esports;
    case "Tagihan":
      return Icons.receipt_long;
    case "Belanja":
      return Icons.shopping_bag;
    default:
      return Icons.menu;
  }
}
