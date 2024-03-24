import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_expense_manager_dapp/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:flutter_expense_manager_dapp/models/transaction_model.dart';
import 'package:flutter_expense_manager_dapp/utils/colors.dart';

class DepositPage extends StatefulWidget {
  final DashboardBloc dashboardBloc;
  const DepositPage({super.key, required this.dashboardBloc});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController reasonsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenAccent,
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Text(
              "Deposit Details",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // TextField(
            //   controller: addressController,
            //   decoration: InputDecoration(hintText: "Enter the Address"),
            // ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(hintText: "Enter the Amount"),
            ),
            TextField(
              controller: reasonsController,
              decoration: InputDecoration(hintText: "Enter the Reason"),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                widget.dashboardBloc.add(DashboardDepositEvent(
                    transactionModel: TransactionModel(
                        addressController.text,
                        int.parse(amountController.text),
                        reasonsController.text,
                        DateTime.now())));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green),
                child: const Center(
                  child: Text(
                    "+ DEPOSIT",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
