import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

import 'crypto_card.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'USD'; // default value of the price list

  //TODO: list of DropdownButtons showing the prices at the bottom
  DropdownButton<String> androidDropdown(){
    List<DropdownMenuItem<String>> dropdownitems = [];
    for(String currency in currenciesList){
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdownitems.add(newItem);
    }
    return DropdownButton(
      value: selectedCurrency,
      items: dropdownitems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getData(); // Call getData() when the picker/dropdown changes.
        });
      },
    );
  }

  //TODO: list of CupertinoPickeritems showing the prices at the bottom
  CupertinoPicker iosDropdown(){
    List<Text> pickeritems = [];
    for(String currency in currenciesList){
      pickeritems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 30,
      onSelectedItemChanged: (selectedIndex){
        setState(() {
          // Save the selected currency to the property selectedCurrency
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickeritems,
    );
  }

  //value had to be updated into a Map to store the values of all three cryptocurrencies.
  Map<String, String> coinValues = {};
  // a way of displaying a '?' on screen while we're waiting for the price data to come back
  bool isWaiting = false;

  //TODO: an async method here await the coin data from coin_data.dart
  void getData() async {
    // we set it to true when we initiate the request for prices.
    isWaiting = true;
    try{
      var data = await CoinData().getCoinData(selectedCurrency);
      // as soon the above line of code completes, we now have the data and no longer need to wait.
      // So we can set isWaiting to false
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e){
      print(e);
    }
  }

  //TODO: a method that loops through the cryptoList and generates a CryptoCard for each
  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          // we use a ternary operator to check if we are waiting and if so, we'll display a '?'
          // otherwise we'll show the actual price data
          value: isWaiting ? '?' : coinValues[crypto]!,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  void initState() {
    super.initState();
    // calling getData() when the screen loads up. We can't call CoinData().getCoinData()
    // directly here because we can't make initState() async.
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // call makeCards() in the build() method with 3 CryptoCards
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            // child: Platform.isAndroid ? androidDropdown() : iosDropdown(),
            child: iosDropdown(),
          ),
        ],
      ),
    );
  }
}

