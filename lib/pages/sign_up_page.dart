import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drbot/pages/phone_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'home_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool _isLoggedIn = false;
  Map _userObj = {};
  final CollectionReference _users = FirebaseFirestore.instance.collection('Users');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callFirebaseApp();
  }

  callFirebaseApp() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECF1FA),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                'assets/logo.png',
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Welcome',
                style: TextStyle(
                  fontFamily: 'Lato Black',
                  fontSize: 24,
                  color: Color(0xff2a2ac0),
                ),
              ),
              const Text(
                'Sign in to continue',
                style: TextStyle(
                  fontFamily: 'Lato Black',
                  fontSize: 14,
                  color: Color(0xff1c1c1c),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => PhonePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff2a2ac0),
                  minimumSize: const Size(230,50),
                ),
                child: const Text(
                  'Sign in with mobile number',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text(
                  'or',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    color: Color(0xff1c1c1c),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (_) => PhonePage()),
                  // );
                  final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
                  // or FacebookAuth.i.login()
                  if (result.status == LoginStatus.success) {
                  // Create a credential from the access token
                  final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);

                  // Once signed in, return the UserCredential
                  final UserCredential user = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
                  print(user.user!.uid);

                  // // you are logged
                  // final AccessToken accessToken = result.accessToken!;
                  // print(accessToken);
                  FacebookAuth.instance.getUserData().then((userData) {
                    setState(() {
                      _isLoggedIn = true;
                      _userObj = userData;
                      _users
                          .doc(user.user!.uid).set({
                        'name': _userObj['name'],
                        'email': _userObj['email'],
                        'image_url': _userObj['picture']['data']['url'],
                        'phone': '',
                      });
                    });
                    Navigator.pushAndRemoveUntil(
                        context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false
                    );
                  });
                  } else {
                    print(result.status);
                    print(result.message);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff3A559F),
                  minimumSize: const Size(230,50),
                ),
                child: const Text(
                  'Sign in with Facebook',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
            ],
          ),
          Text(
              _isLoggedIn ? '${_userObj['name']}' : '',
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'By signing in, you accept our ',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      color: Color(0xff1c1c1c),
                    ),
                  ),
                  Text(
                    'Terms and Conditions.',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 14,
                      color: Color(0xff2a2ac0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
