import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drbot/pages/home_page.dart';
import 'package:drbot/widgets/profile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  late String email;
  late String name;
  late String mobile;
  late String image;
  ProfilePage({Key? key, required this.email, required this.name, required this.mobile, required this.image}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final _picker = ImagePicker();
  File? _image;
  bool isAPiCallProcess = false;

  _imgFromCamera() async {
    final pickedFile = await _picker.getImage(
        source: ImageSource.camera, imageQuality: 50
    );
    File image = File(pickedFile!.path);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    final pickedFile = await  _picker.getImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    File image = File(pickedFile!.path);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  final CollectionReference _users = FirebaseFirestore.instance.collection('Users');
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
  }

  Future<bool> _onBackPressed() {
    //Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false);

    return Future.value(true);
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _drawerKey,
        appBar: AppBar(
          brightness: Platform.isIOS || Platform.isAndroid ? Brightness.light : Brightness.dark,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xff181461),
              size: 30,),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    color: const Color(0xffFFFFFF),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0, bottom: 20.0),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                   Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                       Text(
                                        'Personal Information',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                   Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status ? _getEditIcon() : Container(),
                                    ],
                                  )
                                ],
                              )
                          ),
                          !_status
                              ? _image != null
                              ? InkWell(
                            child: CircleAvatar(
                              radius: 50.0,
                              child: Image.file(
                                _image!,
                                fit: BoxFit.fill,
                              ),
                            ),
                            onTap: () async {
                              _showPicker(context);
                            },
                          )
                              : widget.image == null
                              ? InkWell(
                            child: const SizedBox(
                              width: 100,
                              height: 100,
                              child: CircleAvatar(
                                child: Icon(Icons.photo_camera,size: 50,),
                              ),
                            ),
                            onTap: () async {
                              _showPicker(context);
                            },
                          )
                              : InkWell(
                            child: CircleAvatar(
                                radius: 50.0,
                                foregroundImage: NetworkImage(
                                  widget.image.isEmpty ? 'https://png.pngtree.com/png-vector/20190909/ourmid/pngtree-outline-user-icon-png-image_1727916.jpg' : widget.image,
                                )
                            ),
                            onTap: () async {
                              _showPicker(context);
                              // final pickedFile = await _picker.getImage(source: ImageSource.gallery);
                              // final File image = File(pickedFile.path);
                              //
                              // await uploadFile(image, id);
                              //
                              // setState(() {});
                            },
                          )
                              : widget.image == null
                              ? const SizedBox(
                                width: 100,
                                height: 100,
                                child: CircleAvatar(
                                  child: Icon(Icons.photo_camera,size: 50,),
                                ),
                              )
                              : CircleAvatar(
                                  radius: 50.0,
                                  foregroundImage: NetworkImage(
                                    widget.image.isEmpty ? 'https://png.pngtree.com/png-vector/20190909/ourmid/pngtree-outline-user-icon-png-image_1727916.jpg' : widget.image,
                                  )
                              ),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: CircleAvatar(
                          //     radius: 10.0,
                          //     foregroundImage: NetworkImage(
                          //         widget.image ?? 'https://png.pngtree.com/png-vector/20190909/ourmid/pngtree-outline-user-icon-png-image_1727916.jpg',
                          //     )
                          //   ),
                          // ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: "Enter Your Name",
                                      ),
                                      initialValue: widget.name.isEmpty ? '' : widget.name,
                                      enabled: !_status,
                                      onChanged: (value) {
                                        widget.name = value;
                                      },
                                      onSaved: (value){
                                        widget.name = value!;
                                      },
                                      //autofocus: !_status,

                                    ),
                                  ),
                                ],
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                       Text(
                                        'Email ID',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter Email ID"),
                                      initialValue: widget.email.isEmpty ? '' : widget.email,
                                      enabled: !_status,
                                      onChanged: (value) {
                                        widget.email = value;
                                      },
                                      onSaved: (value){
                                        widget.email = value!;
                                      },
                                    ),
                                  ),
                                ],
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                                      Text(
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child:  Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                   Flexible(
                                    child:  TextFormField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter Mobile Number"),
                                      keyboardType: TextInputType.phone,
                                      initialValue: widget.mobile.isEmpty ? '' : widget.mobile,
                                      enabled: !_status,
                                      onChanged: (value) {
                                        widget.mobile = value;
                                      },
                                      onSaved: (value){
                                        widget.mobile = value!;
                                      },
                                    ),
                                  ),
                                ],
                              )
                          ),
                          !_status ? _getActionButtons() : Container(),
                        ],
                      ),
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

  Widget _getActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                    _users
                        .doc(user!.uid).update({
                      "email": widget.email,
                      "name": widget.name,
                      'mobile': widget.mobile,
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF125688),
                  minimumSize: const Size(80, 28),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF125688),
                  minimumSize: const Size(80, 28),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: const CircleAvatar(
        backgroundColor: Color(0xFF125688),
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
