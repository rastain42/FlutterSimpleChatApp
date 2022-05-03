import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/tabbutton_widget.dart';
import 'package:chat_app/components/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // bool showSpinner = false;
  late String password;
  late String email;

  // final _firestore = Firestore.
  final _auth = FirebaseAuth.instance;
  bool _obscureText = true;
  bool _validate = false;
  final _text1 = TextEditingController();
  final _text2 = TextEditingController();

  @override
  void dispose() {
    _text1.dispose();
    _text2.dispose();
    // _text3.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueGrey,
            Colors.grey,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("Connectez-vous"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 150.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 55, 30, 20),
                child: emailInput(),
              ),
              Padding(
                // padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                padding: EdgeInsets.fromLTRB(30, 10, 30, 20),

                child: passInput(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                child: Hero(
                  tag: "button2",
                  child: TabButton(
                    btnColor: PalletteColors.primaryRed,
                    btnTxtColor: Colors.white,
                    btnText: "Log In",
                    btnFunction: () async {
                      _text1.text.isEmpty
                          ? _validate = false
                          : _validate = true;
                      _text2.text.isEmpty
                          ? _validate = false
                          : _validate = true;
                      setState(() {
                        // showSpinner = true;
                      });

                      try {
                        final loggedInUser =
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                        if (loggedInUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                          setState(() {
                            // showSpinner = false;
                          });
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Vous n'avez pas de compte?",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      " S'inscrire",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: PalletteColors.primaryRed,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 200)
            ],
          ),
        ),
      ),
    );
  }

  Widget emailInput() {
    return Theme(
      child: TextField(
        onChanged: (value) {
          email = value;
        },
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "Email",
          errorText: _validate ? 'veuillez entrer un email valide' : null,
          prefixIcon: Icon(Icons.mail_outline),
          labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          errorStyle: TextStyle(fontSize: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: Colors.red,
              )),
        ),
        textInputAction: TextInputAction.next,
      ),
      data: Theme.of(context).copyWith(
        accentColor: PalletteColors.primaryRed,
      ),
    );
  }

  Widget passInput() {
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: PalletteColors.primaryRed,
      ),
      child: TextField(
        onChanged: (value) {
          password = value;
        },
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.vpn_key,
          ),
          labelText: "Mot de passe",
          errorText: _validate ? 'Entrez un mot de passe ' : null,
          labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: Colors.red,
              )),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          errorStyle: TextStyle(fontSize: 14),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: PalletteColors.primaryGrey,
            ),
            onPressed: _toggle,
          ),
        ),
        textInputAction: TextInputAction.done,
        obscureText: _obscureText,
      ),
    );
  }
}
