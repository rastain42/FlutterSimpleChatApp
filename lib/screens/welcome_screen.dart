import 'package:flutter/material.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:chat_app/components/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:chat_app/widgets/tabbutton_widget.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animationcurve;

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = AnimationController(
        duration: Duration(seconds: 5),
        vsync: this,
      );
      animationcurve =
          CurvedAnimation(parent: controller, curve: Curves.decelerate);
      controller.forward();

      controller.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey.withOpacity(0.7),
              Colors.grey,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 200.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 10),
                child: Text("Chat instantané !",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontWeight: FontWeight.w900),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0.8, 30, 22),
                child: Text(
                    "Ceci est une petite application \"démo\" d'un chat mis en place rapidement avec firebase",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          color: Colors.white, fontSize: 18.0, height: 1.5),
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: Hero(
                  tag: "button",
                  child: TabButton(
                    btnColor: PalletteColors.primaryRed,
                    btnTxtColor: Colors.white,
                    btnText: "Créer un compte",
                    btnFunction: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: RegistrationScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
                child: Hero(
                  tag: "button2",
                  child: TabButton(
                    btnColor: PalletteColors.lightBlue,
                    btnTxtColor: Colors.black,
                    btnText: "Se connecter",
                    btnFunction: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: LoginScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
