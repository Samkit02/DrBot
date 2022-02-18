import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drbot/pages/location_page.dart';
import 'package:drbot/pages/phone_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'home_page.dart';

class VerificationPage extends StatefulWidget {
  final String phone;

  const VerificationPage({Key? key, required this.phone}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final CollectionReference _users = FirebaseFirestore.instance.collection('Users');

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
    verifyPhoneNumber();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) {
            if(value.user != null){
              _users
                  .doc(value.user!.uid).set({
                'name': '',
                'email': '',
                'image_url': '',
                'phone': widget.phone,
              });
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false
              );
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          snackBar(e.message.toString());
        },
        codeSent: (String vId, int? resendToken) {
          setState(() {
            verificationCode = vId;
          });
        },
        codeAutoRetrievalTimeout: (String vId) {
          setState(() {
            verificationCode = vId;
          });
        },
        timeout: const Duration(seconds: 60),
    );
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String? verificationCode;
  String? sms;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECF1FA),
      body: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Verification',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 24,
                    color: Color(0xff181461),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: widget.phone,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            )
                        ),
                      ],
                      style: const TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: const TextStyle(
                          color: Color(0xff2A2AC0),
                          fontWeight: FontWeight.bold,
                        ),
                        onSubmitted: (value) async {
                          try {
                            await FirebaseAuth.instance
                                .signInWithCredential(PhoneAuthProvider
                                .credential(
                                  verificationId: verificationCode!,
                                  smsCode: value)
                            ).then((value) {
                              if(value.user != null){
                                _users
                                    .doc(value.user!.uid).set({
                                  'name': '',
                                  'email': '',
                                  'image_url': '',
                                  'phone': widget.phone,
                                });
                                Navigator.pushAndRemoveUntil(
                                    context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false
                                );
                              }
                            });
                          }
                          catch (e) {
                            snackBar('Invalid OTP!!!');
                          }
                        },
                        length: 6,
                        obscureText: true,
                        obscuringCharacter: '*',
                        // obscuringWidget: const FlutterLogo(
                        //   size: 24,
                        // ),
                        blinkWhenObscuring: true,
                        animationType: AnimationType.fade,
                        // validator: (v) {
                        //   if (v!.length < 3) {
                        //     return "I'm from validator";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        autoDismissKeyboard: true,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.underline,
                          inactiveColor: const Color(0xff2A2AC0),
                          selectedColor: const Color(0xff2A2AC0),
                          activeColor: const Color(0xff2A2AC0),
                          activeFillColor: const Color(0xff2A2AC0),
                          inactiveFillColor: const Color(0xff2A2AC0),
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          // activeFillColor: Colors.white,
                        ),
                        cursorColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: false,
                        errorAnimationController: errorController,
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        // boxShadows: const [
                        //   BoxShadow(
                        //     offset: Offset(0, 1),
                        //     color: Colors.black12,
                        //     blurRadius: 10,
                        //   )
                        // ],
                        onCompleted: (v) {
                          print("Completed");
                        },
                        // onTap: () {
                        //   print("Pressed");
                        // },
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            currentText = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text(
              //       "Didn't receive the code? ",
              //       style: TextStyle(color: Colors.black54, fontSize: 15),
              //     ),
              //     TextButton(
              //         onPressed: () => snackBar("OTP resend!!"),
              //         child: const Text(
              //           "RESEND",
              //           style: TextStyle(
              //               color: Color(0xff2A2AC0),
              //               fontWeight: FontWeight.bold,
              //               fontSize: 16
              //           ),
              //         )
              //     )
              //   ],
              // ),
              const SizedBox(
                height: 14,
              ),
              Container(
                margin:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: const Color(0xff181461),
                    ),
                    onPressed: () async {
                      formKey.currentState!.validate();
                      // conditions for validating
                      if (currentText.length != 6) {
                        errorController!.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() => hasError = true);
                      } else {
                        try {
                          await FirebaseAuth.instance
                              .signInWithCredential(PhoneAuthProvider
                              .credential(
                              verificationId: verificationCode!,
                              smsCode: textEditingController.text)
                          ).then((value) {
                            if(value.user != null){
                              _users
                                  .doc(value.user!.uid).set({
                                'name': '',
                                'email': '',
                                'image_url': '',
                                'phone': widget.phone,
                              });
                              Navigator.pushAndRemoveUntil(
                                  context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false
                              );
                            }
                          });
                        }
                        catch (e) {
                          snackBar('Invalid OTP!!!');
                        }
                      }
                    },
                    child: Center(
                        child: Text(
                          "Continue".toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16,
                            color: Color(0xffffffff),
                          ),
                        )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: const Color(0xff2A2AC0),
                    borderRadius: BorderRadius.circular(5),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextButton(
                        onPressed: (){
                          snackBar("OTP resent!!");
                          verifyPhoneNumber();
                        },
                        child: const Text(
                          "Resend Code",
                          style: TextStyle(
                              color: Color(0xff2A2AC0),
                              fontSize: 14
                          ),
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: TextButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => PhonePage()),
                        ),
                        child: const Text(
                          "Change Number",
                          style: TextStyle(
                              color: Color(0xff2A2AC0),
                              fontSize: 14
                          ),
                        )
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
