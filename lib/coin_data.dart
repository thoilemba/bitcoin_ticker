import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '39A0CC4F-5449-44AA-925A-63DDA7E3B6B9';

class CoinData {
  // creating the asynchronous method that returns a Future (the price data)
  Future getCoinData(String selectedCurrency) async {

    Map<String, String> cryptoPrices = {};
    // using a for loop here to loop through the cryptoList and request the data for each of them in turn
    for(String crypto in cryptoList){
      String requestURL = '$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey';
      final response = await http.get(Uri.parse(requestURL));

      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        // create a new key value pair, with the key being the crypto symbol
        // and the value being the price of that crypto currency
        cryptoPrices[crypto] = data['rate'].toStringAsFixed(2);
      }else {
        throw Exception('Failed to load data');
      }
    }
    // return a Map of the results instead of a single value
    return cryptoPrices;
  }
}
