import 'dart:async';

import 'package:crypto_tracke/models/cryptocurrency.dart';
import 'package:crypto_tracke/providers/ad_provider.dart';
import 'package:crypto_tracke/providers/market_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  final String id;
  const DetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Widget titleAndDetail(
      String title, String detail, CrossAxisAlignment crossAxisAlignment) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        Text(
          detail,
          style: const TextStyle(
            fontSize: 17,
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Initilize HOmepage Banner

    Timer(const Duration(seconds: 2), () {
      AdProvider adProvider = Provider.of<AdProvider>(context, listen: false);
      adProvider.initializeDetailsPageBanner();
      adProvider.initializeFullPagePageBanner();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AdProvider adProvider = Provider.of<AdProvider>(context, listen: false);
        if (adProvider.isFullPageAdLoaded) {
          adProvider.fullPageAd.show();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Consumer<MarketProvider>(
              builder: (context, marketProvider, child) {
                CryptoCurrency currentCrypto =
                    marketProvider.fetchCryptoById(widget.id);

                return RefreshIndicator(
                  onRefresh: () async {
                    await marketProvider.fetchData();
                  },
                  child: ListView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(currentCrypto.image!),
                        ),
                        title: Text(
                          currentCrypto.name! +
                              "(${currentCrypto.symbol!.toUpperCase()})",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          "Rs " +
                              currentCrypto.currentPrice!.toStringAsFixed(4),
                          style: const TextStyle(
                              color: Color(0xFF0395eb), fontSize: 30),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Price Change (24h)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
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
                                    fontSize: 23,
                                  ),
                                );
                              } else {
                                return Text(
                                  "${priceChangePercentage.toStringAsFixed(2)}% (${priceChange.toStringAsFixed(4)})",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 23,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          titleAndDetail(
                            "Market Cap",
                            "Rs " + currentCrypto.marketCap!.toStringAsFixed(4),
                            CrossAxisAlignment.start,
                          ),
                          titleAndDetail(
                            "Market Cap Rank",
                            "Rs " + currentCrypto.marketCapRank.toString(),
                            CrossAxisAlignment.end,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          titleAndDetail(
                            "Low 24h",
                            "Rs " + currentCrypto.low24!.toStringAsFixed(4),
                            CrossAxisAlignment.start,
                          ),
                          titleAndDetail(
                            "High 24h",
                            "Rs " + currentCrypto.hight24!.toStringAsFixed(4),
                            CrossAxisAlignment.end,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          titleAndDetail(
                            "Circulating Supply",
                            "Rs " +
                                currentCrypto.circulatingSupply!
                                    .toInt()
                                    .toString(),
                            CrossAxisAlignment.start,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          titleAndDetail(
                            "All Time Low",
                            "Rs " + currentCrypto.atl!.toInt().toString(),
                            CrossAxisAlignment.start,
                          ),
                          titleAndDetail(
                            "All Time High",
                            "Rs " + currentCrypto.ath!.toInt().toString(),
                            CrossAxisAlignment.end,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: Consumer<AdProvider>(
          builder: (context, adProvider, child) {
            if (adProvider.isDetailsPageBannerLoaded) {
              return Container(
                height: adProvider.detailsPageBanner.size.height.toDouble(),
                child: AdWidget(
                  ad: adProvider.homePageBanner,
                ),
              );
            } else {
              return Container(
                height: 0,
              );
            }
          },
        ),
      ),
    );
  }
}
