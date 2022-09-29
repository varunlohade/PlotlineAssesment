import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? selectedImage;
  String message = "";
  var progress = 0;
  var images;
  uploadImage() async {
    final request = http.MultipartRequest("POST",
        Uri.parse("https://edgedetectionassesment.herokuapp.com/upload"));
    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(http.MultipartFile('image',
        selectedImage!.readAsBytes().asStream(), selectedImage!.lengthSync(),
        filename: selectedImage!.path.split("/").last));

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    print(res);
    print("This is res body ${res.bodyBytes}");
    // final resJson = jsonDecode(res.body);
    images = res.bodyBytes;

    setState(() {});
    // message = compute(base64Decode, res.body);
  }

  Future getImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    selectedImage = File(pickedImage!.path);
    setState(() {});
    Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
  }

  Future getImageCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    selectedImage = File(pickedImage!.path);
    setState(() {});
  }

  Widget? LoadingImage(var images) {
    if (images == null) {
      return Center(
        child: Container(
          child: Text("NO Image"),
        ),
      );
    } else if (images.length == 0) {
      return Center(
        child: Column(children: [CircularProgressIndicator(), Text("Loading")]),
      );
    } else {
      Image.memory(
        images,
        fit: BoxFit.fitWidth,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              selectedImage == null
                  ? Text(
                      "Please pick a image to convert",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )
                  : Column(
                      children: [
                        Text("Original Image"),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.file(selectedImage!),
                        ),
                      ],
                    ),
              selectedImage == null
                  ? Container()
                  : TextButton.icon(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue)),
                      onPressed: uploadImage,
                      icon: const Icon(
                        Icons.change_circle,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Convert",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              selectedImage == null
                  ? Container()
                  : const Text(
                      "Detect edges by click on the convert button",
                      style: TextStyle(fontSize: 20),
                    ),
              images == null
                  ? selectedImage == null
                      ? Container()
                      : Text("NO Image")
                  : Column(
                      children: [
                        images.length == 0
                            ? CircularProgressIndicator()
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.memory(images),
                              )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
