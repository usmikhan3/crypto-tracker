// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:crypto_tracke/models/cryptocurrency.dart';
import 'package:crypto_tracke/pages/details_page.dart';
import 'package:crypto_tracke/providers/market_provider.dart';

class CryptoListTile extends StatelessWidget {
  final CryptoCurrency currentCrypto;
  const CryptoListTile({
    Key? key,
    required this.currentCrypto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MarketProvider marketProvider =
        Provider.of<MarketProvider>(context, listen: false);
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsPage(
              id: currentCrypto.id!,
            ),
          ),
        );
      },
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(currentCrypto.image!),
      ),
      title: Row(
        children: [
          Flexible(
              child: Text(
            currentCrypto.name!,
            overflow: TextOverflow.ellipsis,
          )),
          const SizedBox(
            width: 2,
          ),
          (currentCrypto.isFavorite == false)
              ? GestureDetector(
                  onTap: () {
                    marketProvider.addFavorite(currentCrypto);
                  },
                  child: const Icon(
                    CupertinoIcons.heart,
                    size: 18,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    marketProvider.removeFavorite(currentCrypto);
                  },
                  child: const Icon(
                    CupertinoIcons.heart_fill,
                    size: 18,
                    color: Colors.red,
                  ),
                ),
        ],
      ),
      subtitle: Text(currentCrypto.symbol!.toUpperCase()),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Rs " + currentCrypto.currentPrice!.toStringAsFixed(4),
            style: const TextStyle(
                color: Color(0xFF0395eb),
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          Builder(
            builder: (context) {
              double priceChange = currentCrypto.priceChange24!;
              double priceChangePercentage =
                  currentCrypto.priceChangePercentage24!;

              if (priceChange < 0) {
                //negative
                return Text(
                  "${priceChangePercentage.toStringAsFixed(2)}% (${priceChange.toStringAsFixed(4)})",
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                );
              } else {
                return Text(
                  "${priceChangePercentage.toStringAsFixed(2)}% (${priceChange.toStringAsFixed(4)})",
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
    ;
  }
}
