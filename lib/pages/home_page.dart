import 'dart:async';
import 'dart:ui';
import 'package:crypto_tracke/models/cryptocurrency.dart';
import 'package:crypto_tracke/pages/details_page.dart';
import 'package:crypto_tracke/pages/favorites.dart';
import 'package:crypto_tracke/pages/markets.dart';
import 'package:crypto_tracke/providers/ad_provider.dart';
import 'package:crypto_tracke/providers/market_provider.dart';
import 'package:crypto_tracke/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  late TabController viewController;

  @override
  void initState() {
    super.initState();
    viewController = TabController(length: 2, vsync: this);

    //Initilize HOmepage Banner

    Timer(const Duration(seconds: 2), () {
      AdProvider adProvider = Provider.of<AdProvider>(context, listen: false);
      adProvider.initializeHomePageBanner();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Crypto Today",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        themeProvider.toggleTheme();
                      },
                      icon: Consumer<ThemeProvider>(
                        builder: (context, themeProvider1, child) {
                          return (themeProvider.themeMode == ThemeMode.light)
                              ? Icon(Icons.dark_mode)
                              : Icon(Icons.light_mode);
                        },
                      )),
                ],
              ),
              TabBar(
                controller: viewController,
                tabs: [
                  Tab(
                    child: Text(
                      "Markets",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Favorites",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: viewController,
                  children: const [
                    Markets(),
                    Favorites(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer<AdProvider>(
        builder: (context, adProvider, child) {
          if (adProvider.isHomePageBannerLoaded) {
            return Container(
              height: adProvider.homePageBanner.size.height.toDouble(),
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
    );
  }
}
