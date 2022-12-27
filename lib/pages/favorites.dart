import 'dart:ui';

import 'package:crypto_tracke/models/cryptocurrency.dart';
import 'package:crypto_tracke/providers/market_provider.dart';
import 'package:crypto_tracke/widgets/crypto_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: Text("Favorites will show up here"),
    // );
    return Consumer<MarketProvider>(
      builder: (context, marketProvider, child) {
        List<CryptoCurrency> favorites = marketProvider.markets
            .where((element) => element.isFavorite == true)
            .toList();

        if (favorites.length > 0) {
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              CryptoCurrency currentCrypto = favorites[index];
              return CryptoListTile(currentCrypto: currentCrypto);
            },
          );
        } else {
          return const Center(
            child: Text(
              "No Favorites yet",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
          );
        }
      },
    );
  }
}
