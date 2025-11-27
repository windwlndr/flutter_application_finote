import 'package:flutter/material.dart';
import 'package:flutter_application_finote/firebase_version/models/budget_model_firebase.dart';
import 'package:flutter_application_finote/firebase_version/service/firebase.dart';

class ManageBudgetPage extends StatelessWidget {
  const ManageBudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Budget")),
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
            children: budgets.map((b) {
              return Card(
                child: ListTile(
                  title: Text(b.kategori),
                  subtitle: Text("Target Budget: Rp ${b.targetValue.toInt()}"),
                  trailing: Icon(Icons.edit),
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
        title: Text("Edit Budget ${b.kategori}"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: "Target Budget"),
        ),
        actions: [
          TextButton(
            child: Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Simpan"),
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
