/// This class is the main workhorse of the Paymint client. It handles several critical operations such as:
/// - Internal accounting (BIP84 - HD Wallet structure for Native Segwit addresses)
/// - Fetching wallet data from the Paymint API
/// - Managing private keys

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paymint/models/models.dart';
import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;

class BitcoinService extends ChangeNotifier {
  // Holds final balances, all utxos under control 
  Future<UtxoData> _utxoData;
  Future<UtxoData> get utxoData => _utxoData ??= fetchUtxoData();

  // Holds ordered and chunked transaction data
  Future<TransactionData> _transactionData;
  Future<TransactionData> get transactionData => _transactionData ??= fetchTransactionData();

  // Constructor function
  BitcoinService() {
    // Pull local data for internal and external chain addresses to feed into UTXO and transaction call functions
    _utxoData = fetchUtxoData();
    _transactionData = fetchTransactionData();
  }

  Future<UtxoData> fetchUtxoData() async {
    final requestBody = {
      "currency": "USD",
      "receivingAddresses": ["3KHPDaQPxUGWsmB6ik91UWRnuzFz5akCzz"],
      "internalAndChangeAddressArray": ["3KHPDaQPxUGWsmB6ik91UWRnuzFz5akCzz"]
    };

    final response = await http.post('https://www.api.paymintapp.com/mock/outputs', body: jsonEncode(requestBody), headers: {'Content-Type': 'application/json'} );

    if (response.statusCode == 200 || response.statusCode == 201) {
      notifyListeners();
      return UtxoData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Something happened: ' + response.statusCode.toString() + response.body );
    }
  }

  Future<TransactionData> fetchTransactionData() async {
    final requestBody = {
      "currency": "USD",
      "receivingAddresses": ["3KHPDaQPxUGWsmB6ik91UWRnuzFz5akCzz"],
      "internalAndChangeAddressArray": ["3KHPDaQPxUGWsmB6ik91UWRnuzFz5akCzz"]
    };

    final response = await http.post('https://www.api.paymintapp.com/mock/transactions', body: jsonEncode(requestBody), headers: {'Content-Type': 'application/json'} );

    if (response.statusCode == 200 || response.statusCode == 201) {
      notifyListeners();
      return TransactionData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Something happened: ' + response.statusCode.toString() + response.body );
    }
  }

}
