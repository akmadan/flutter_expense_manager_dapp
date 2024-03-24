import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expense_manager_dapp/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:flutter_expense_manager_dapp/features/deposit/deposit.dart';
import 'package:flutter_expense_manager_dapp/features/withdraw/withdraw.dart';
import 'package:flutter_expense_manager_dapp/utils/colors.dart';
import 'package:flutter_svg/svg.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardBloc dashboardBloc = DashboardBloc();

  @override
  void initState() {
    dashboardBloc.add(DashboardInitialFechEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar:
          AppBar(title: Text("web3 Bank"), backgroundColor: AppColors.accent),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        bloc: dashboardBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case DashboardLoadingState:
              return Center(
                child: CircularProgressIndicator(),
              );
            case DashboardErrorState:
              return Center(
                child: Text("Error"),
              );

            case DashboardSuccessState:
              final successState = state as DashboardSuccessState;
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/eth-logo.svg",
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              successState.balance.toString() + ' ETH',
                              style: TextStyle(
                                  fontSize: 50, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WithdrawPage(
                                        dashboardBloc: dashboardBloc,
                                      ))),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.redAccent),
                            child: const Center(
                              child: Text(
                                "- DEBIT",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )),
                        const SizedBox(width: 8),
                        Expanded(
                            child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DepositPage(
                                        dashboardBloc: dashboardBloc,
                                      ))),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.greenAccent),
                            child: const Center(
                              child: Text(
                                "+ CREDIT",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Transactions",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                        child: ListView.builder(
                      itemCount: successState.transactions.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset("assets/eth-logo.svg",
                                      height: 24, width: 24),
                                  const SizedBox(width: 6),
                                  Text(
                                    successState.transactions[index].amount
                                            .toString() +
                                        ' ETH',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Text(
                                successState.transactions[index].address,
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                successState.transactions[index].reason,
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        );
                      },
                    ))
                  ],
                ),
              );

            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}
