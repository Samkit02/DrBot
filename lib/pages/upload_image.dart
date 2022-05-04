import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drbot/pages/Hb-Results.dart';
import 'package:drbot/upload_image_model.dart';
import 'package:drbot/widgets/ProgressHUD.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  final _picker = ImagePicker();
  File? _image;
  bool isAPiCallProcess = false;
  bool showResultButton = false;

  _imgFromCamera() async {
    final pickedFile = await _picker.getImage(
        source: ImageSource.camera, imageQuality: 50
    );
    File image = File(pickedFile!.path);
    base64Image = base64Encode(image.readAsBytesSync());

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    final pickedFile = await  _picker.getImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    File image = File(pickedFile!.path);
    base64Image = base64Encode(image.readAsBytesSync());

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  Future<File>? file;
  String status = '';
  String? base64Image;
  File? tmpFile;
  String errMessage = 'Error Uploading Image';

  chooseImage() async {
    final file = await  _picker.pickImage(
        source: ImageSource.gallery
    );
    File image = File(file!.path);
    setState(() {

      setState(() {
        tmpFile = image;
      });
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload(BuildContext context) {
    setState(() {
      isAPiCallProcess = true;
    });
    setStatus('Uploading Image...');
    if (null == _image) {
      setStatus(errMessage);
      return;
    }
    //String fileName = tmpFile.path.split('/').last;
    upload(_image!, context);
  }

  UploadImage1? _uploadImage;

  upload(File imageFile, BuildContext context) async {

    // http.post(
    //     Uri.parse("https://entwinetechnology.com/fileUploadScript.php"),
    //     body: {
    //   "fimage": base64Image,
    //   "fimage": imageFile,
    // }).then((result) {
    //   if(result.statusCode == 200) {
    //     _uploadImage = uploadImageFromJson(result.body);
    //   }
    //   setStatus(result.statusCode == 200 ? result.body : errMessage);
    // }).catchError((error) {
    //   setStatus(error.toString());
    // });
    // open a bytestream
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("https://127.0.0.1/Hemoglobin1/fileUploadScript.php");
    //var uri = Uri.parse("https://entwinetechnology.com/fileUploadScript.php");

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = http.MultipartFile('fimage', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      _uploadImage = uploadImageFromJson(value);
      if(response.statusCode == 200) {
        setState(() {
          isAPiCallProcess = false;
          showResultButton = true;
        });
        print(value);
        print(_uploadImage?.message);
        Navigator.push(context, MaterialPageRoute(builder: (context) => HbResults()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _uploadImage = UploadImage1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: ProgressHUD(
        inAsyncCall: isAPiCallProcess,
        opacity: 0.3,
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                OutlinedButton(
                  onPressed: () {
                    _showPicker(context);
                  },
                  child: const Text('Choose Image'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                _image != null
                    ? InkWell(
                  child: Image.file(
                    _image!,
                    fit: BoxFit.fill,
                  ),
                  onTap: () async {
                    _showPicker(context);
                  },
                )
                : const SizedBox(
                  width: 100,
                  height: 100,
                  child: Icon(Icons.photo_camera,size: 50,),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                OutlinedButton(
                  onPressed: () {
                    startUpload(context);
                  },
                  child: const Text('Upload Image'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HbResults()));
                  },
                  child: const Text('View Results'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                // Text(
                //   status,
                //   textAlign: TextAlign.center,
                //   style: const TextStyle(
                //     color: Colors.green,
                //     fontWeight: FontWeight.w500,
                //     fontSize: 20.0,
                //   ),
                // ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}