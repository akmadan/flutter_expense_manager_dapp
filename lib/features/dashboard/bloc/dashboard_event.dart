part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

class DashboardInitialFechEvent extends DashboardEvent {}

class DashboardDepositEvent extends DashboardEvent {
  final TransactionModel transactionModel;
  DashboardDepositEvent({
    required this.transactionModel,
  });
}

class DashboardWithdrawEvent extends DashboardEvent {
  final TransactionModel transactionModel;
  DashboardWithdrawEvent({
    required this.transactionModel,
  });
}
