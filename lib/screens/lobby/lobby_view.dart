import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:baby_f_words/managers/assets.dart';
import 'package:baby_f_words/screens/lobby/lobby_view_model.dart';

import 'package:baby_f_words/constants.dart';

class LobbyView extends StatelessWidget {
  const LobbyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LobbyViewModel(),
      child: Consumer<LobbyViewModel>(
        builder: (context, vm, _) => Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  vm.isLoading ? Colors.white : const Color(0xFFfad3fb),
                  vm.isLoading ? Colors.white : const Color(0xFFCBC3E3),
                  //vm.isLoading ? Colors.white : const Color(0xFFb46adf),
                  //vm.isLoading ? Colors.white : const Color(0xFF863dd6),
                  //vm.isLoading ? Colors.white : const Color(0xFF6221d1),
                  // vm.isLoading ? Colors.white : const Color(0xFF863dd6),
                  vm.isLoading ? Colors.white : const Color(0xFFb46adf),
                ],
              ),
            ),
            child: SafeArea(
              child: vm.isLoading
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Baby First Words',
                          style: spicyRice,
                        ),
                        Text(
                          'Loading...',
                          style: spicyRice.copyWith(fontSize: 25),
                        ),
                        const SizedBox(height: 15),
                        Lottie.asset(Assets.rainbow),
                      ],
                    ))
                  : //
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        scrollDirection: Axis.vertical,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        children: [
                          Center(
                              child: Text(
                            'Baby First ',
                            style: spicyRice,
                            textAlign: TextAlign.end,
                          )),
                          Center(
                            child: Text('Words', style: spicyRice, textAlign: TextAlign.start),
                          ),
                          ...vm.listOfButtons,
                        ],
                      ),
                    ),
            ),
          ),
          bottomNavigationBar: vm.banner == null
              ? const SizedBox()
              : Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  height: 52.0,
                  width: MediaQuery.of(context).size.width,
                  child: AdWidget(
                    ad: vm.banner!,
                  ),
                ),
        ),
      ),
    );
  }
}
