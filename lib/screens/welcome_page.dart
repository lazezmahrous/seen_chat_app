import 'package:flutter/material.dart';
import 'package:seen/screens/login/page/login.dart';
import 'package:seen/global%20widgets/buttons/orignal_button_widget.dart';

import '../generated/l10n.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static String id = 'Welcome';
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children: [
            Container(
              width: 200,
              // height: 100,
              constraints: BoxConstraints(
                maxWidth: screenWidth / 3,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  child: Image.asset(
                    'assets/icons/logo.jpg',
                    width: 100,
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth / 1.3,
                      ),
                      child: Text(
                        S.of(context).welcome,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth / 1.3,
                      ),
                      child: Text(
                        S.of(context).welcomePageDescription,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    SizedBox(
                      width: screenWidth / 1.3,
                      child: OrignalButtonWidget(
                        onPressed: () {
                          Navigator.pushNamed(context, Login.id);
                        },
                        text: S.of(context).welcomePageButton,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
