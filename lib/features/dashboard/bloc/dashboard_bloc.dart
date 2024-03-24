import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expense_manager_dapp/models/transaction_model.dart';
import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardInitialFechEvent>(dashboardInitialFechEvent);
    on<DashboardDepositEvent>(dashboardDepositEvent);
    on<DashboardWithdrawEvent>(dashboardWithdrawEvent);
  }

  List<TransactionModel> transactions = [];
  Web3Client? _web3Client;
  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _creds;
  int balance = 0;

  // Functions
  late DeployedContract _deployedContract;
  late ContractFunction _deposit;
  late ContractFunction _withdraw;
  late ContractFunction _getBalance;
  late ContractFunction _getAllTransactions;

  FutureOr<void> dashboardInitialFechEvent(
      DashboardInitialFechEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoadingState());
    try {
      final String rpcUrl = "http://127.0.0.1:7545";
      final String socketUrl = "ws://127.0.0.1:7545";
      final String privateKey =
          "0xad03ec42844f0807d6ec0cca71e6be75ee53b84e6e19919b2eb921da0e6907d6";

      _web3Client = Web3Client(
        rpcUrl,
        http.Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(socketUrl).cast<String>();
        },
      );

      // getABI
      String abiFile = await rootBundle
          .loadString('build/contracts/ExpenseManagerContract.json');
      var jsonDecoded = jsonDecode(abiFile);

      _abiCode = ContractAbi.fromJson(
          jsonEncode(jsonDecoded["abi"]), 'ExpenseManagerContract');

      _contractAddress =
          EthereumAddress.fromHex("0x1C6C5E0Adcd2d0f40E66d6F6Ec4Ff466b7338dA9");

      _creds = EthPrivateKey.fromHex(privateKey);

      // get deployed contract
      _deployedContract = DeployedContract(_abiCode, _contractAddress);
      _deposit = _deployedContract.function("deposit");
      _withdraw = _deployedContract.function("withdraw");
      _getBalance = _deployedContract.function("getBalance");

      _getAllTransactions = _deployedContract.function("getAllTransactions");

      final transactionsData = await _web3Client!.call(
          contract: _deployedContract,
          function: _getAllTransactions,
          params: []);
      final balanceData = await _web3Client!
          .call(contract: _deployedContract, function: _getBalance, params: [
        EthereumAddress.fromHex("0xec58056550Dc3A60C96EeB220D0862Bb6b2988cb")
      ]);
      log(balanceData.toString());
      log(transactionsData.toString());

      List<TransactionModel> trans = [];
      for (int i = 0; i < transactionsData[0].length; i++) {
        TransactionModel transactionModel = TransactionModel(
            transactionsData[0][i],
            transactionsData[1][i].toInt(),
            transactionsData[2][i],
            DateTime.fromMicrosecondsSinceEpoch(
                transactionsData[3][i].toInt()));
        trans.add(transactionModel);
      }
      transactions = trans;

      int bal = balanceData[0].toInt();
      balance = bal;

      emit(DashboardSuccessState(transactions: transactions, balance: balance));
    } catch (e) {
      log(e.toString());
      emit(DashboardErrorState());
    }
  }

  FutureOr<void> dashboardDepositEvent(
      DashboardDepositEvent event, Emitter<DashboardState> emit) async {
    try {
      final transaction = Transaction.callContract(
        contract: _deployedContract,
        function: _deposit,
        parameters: [
          BigInt.from(event.transactionModel.amount),
          event.transactionModel.reason
        ],
        // This value is necessary if the method is payable
        value: EtherAmount.inWei(BigInt.from(event.transactionModel.amount)),
      );

      final result = await _web3Client!.sendTransaction(
        _creds, // Your EthPrivateKey
        transaction,
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );

      log("Deposit transaction hash: $result");
    } catch (e) {
      log(e.toString());
      emit(DashboardErrorState());
    }
  }

  FutureOr<void> dashboardWithdrawEvent(
      DashboardWithdrawEvent event, Emitter<DashboardState> emit) async {
    final data = await _web3Client!.call(
        sender: EthereumAddress.fromHex(
            "0xec58056550Dc3A60C96EeB220D0862Bb6b2988cb"),
        contract: _deployedContract,
        function: _withdraw,
        params: [
          BigInt.from(event.transactionModel.amount),
          event.transactionModel.reason
        ]);
    log(data.toString());
  }
}
