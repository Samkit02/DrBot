import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drbot/dr_bot_icons_icons.dart';
import 'package:drbot/pages/allopathic_chatbot.dart';
import 'package:drbot/pages/ayurvedic_chatbot.dart';
import 'package:drbot/pages/location_page.dart';
import 'package:drbot/pages/profile_page.dart';
import 'package:drbot/pages/sign_up_page.dart';
import 'package:drbot/pages/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final CollectionReference _users = FirebaseFirestore.instance.collection('Users');
  User? user = FirebaseAuth.instance.currentUser;
  String? email;
  String? name;
  String? image;
  String? phone;

  getDataFromFirestore() async {
    await _users
        .doc(user!.uid)
        .get().then((value) {

          setState(() {
            image = value['image_url'];
            name = value['name'];
            email = value['email'];
            phone = value['phone'];
          });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height) / 2.5;
    final double itemWidth = size.width / 2;
    return Scaffold(
      key: _key,
      backgroundColor: const Color(0xffECF1FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () => _key.currentState!.openDrawer(),
            child: const Icon(
              DrBotIcons.path_3,
              color: Color(0xff181461),
              size: 18,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            name: name.toString(),
                            email: email.toString(),
                            image: image.toString(),
                            mobile: phone.toString(),
                          )
                      )
                  );
                },
                child: const Icon(
                  DrBotIcons.group_3,
                  color: Color(0xff181461),
                  size: 30,
                ),
              ),
            ),
          ],
          bottom: const PreferredSize(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Dashboard',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 24,
                      color: Color(0xff181461),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              preferredSize: Size.fromHeight(0.0)
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.vertical,
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
        children: [
          InkWell(
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AyurvedicChatbot() ));
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Ayurvedic Chatbot',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 16,
                      color: Color(0xff181461),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Image.asset(
                    'assets/pic2.png',
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UploadImage() ));
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Haemoglobin Detection',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 16,
                      color: Color(0xff181461),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Image.asset(
                    'assets/pic2.png',
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LocationPage() ));
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Chemist Near You',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 16,
                      color: Color(0xff181461),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Image.asset(
                    'assets/pic3.png',
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        name: name.toString(),
                        email: email.toString(),
                        image: image.toString(),
                        mobile: phone.toString(),
                      )
                  )
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Account Settings',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 16,
                      color: Color(0xff181461),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Image.asset(
                    'assets/pic4.png',
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 30.0,
                      foregroundImage: NetworkImage(
                        image ?? 'https://png.pngtree.com/png-vector/20190909/ourmid/pngtree-outline-user-icon-png-image_1727916.jpg',
                      )
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name ?? 'Name',
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 18,
                          color: Color(0xff181461),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          email ?? 'Email-Id',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16,
                            color: Color(0xff181461),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadImage())
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(
                        DrBotIcons.group_25,
                        color: Color(0xff181461),
                        size: 18,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, ),
                        child: Text(
                          'Haemoglobin Detection',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            name: name.toString(),
                            email: email.toString(),
                            image: image.toString(),
                            mobile: phone.toString(),
                          )
                      )
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(
                      DrBotIcons.group_3,
                      color: Color(0xff181461),
                      size: 18,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, ),
                      child: Text(
                        'Account Settings',
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => const SignUp()), (route) => false
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(
                      DrBotIcons.path_421,
                      color: Color(0xff181461),
                      size: 18,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, ),
                      child: Text(
                        'Logout',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
