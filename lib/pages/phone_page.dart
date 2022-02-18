import 'dart:async';

import 'package:drbot/pages/home_page.dart';
import 'package:drbot/pages/verification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'location_page.dart';

class PhonePage extends StatefulWidget {
  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  final TextEditingController phoneNumber = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  late String phone;
  late bool validate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECF1FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.png',
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Mobile Number',
            style: TextStyle(
              fontFamily: 'Lato Black',
              fontSize: 24,
              color: Color(0xff2a2ac0),
            ),
          ),
          const Text(
            'The code will be sent to the full mobile number',
            style: TextStyle(
              fontFamily: 'Lato Black',
              fontSize: 14,
              color: Color(0xff1c1c1c),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Form(
            key: formKey,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  debugPrint(number.phoneNumber);
                  phone = number.toString();
                },
                onInputValidated: (bool value) {
                  debugPrint(value.toString());
                  validate = value;
                },
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.DIALOG,
                  showFlags: false,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  color: Color(0xf72a2ac0),
                ),
                initialValue: number,
                hintText: 'Mobile Number',
                textFieldController: phoneNumber,
                formatInput: false,
                keyboardType:
                const TextInputType.numberWithOptions(signed: true, decimal: true),
                inputBorder: InputBorder.none,
                onSaved: (PhoneNumber number) {
                  debugPrint('On Saved: $number');
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
            child: ButtonTheme(
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: const Color(0xff181461),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate() && validate == true) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VerificationPage(phone: phone,)
                      )
                    );
                  }
                  else {
                    snackBar("Enter Valid Details!!!");
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
        ],
      ),
    );
  }
}
