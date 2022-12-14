import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:plotline_app/storage.dart';

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
  final Storage storage = Storage();

  uploadImage(String name, String path) async {
   
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
  
// getting a directory path for saving
// copy the file to a new path

    storage
        .uploadFilemodified(selectedImage!.path, "Modified_${name}", images)
        .then((value) => print("modified image uploaded"));
    setState(() {});
    // message = compute(base64Decode, res.body);
  }

  Future getImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    selectedImage = File(pickedImage!.path);
    storage
        .uploadFile(
          pickedImage.path,
          pickedImage.name,
        )
        .then((value) => print("image uploaded to firebase"));
    uploadImage(pickedImage.name, pickedImage.path);
    setState(() {});
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
      appBar: AppBar(
        title: Text(
          "Pick from gallery",
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          
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
                        Text(
                          "Original Image",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.file(selectedImage!),
                        ),
                      ],
                    ),
              // selectedImage == null
              //     ? Container()
              //     : TextButton.icon(
              //         style: ButtonStyle(
              //             backgroundColor:
              //                 MaterialStateProperty.all(Colors.blue)),
              //         onPressed: uploadImage,
              //         icon: const Icon(
              //           Icons.change_circle,
              //           color: Colors.white,
              //         ),
              //         label: const Text(
              //           "Convert",
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       ),
              selectedImage == null
                  ? Container()
                  : const Text(
                      "Detect edges by click on the convert button",
                      style: TextStyle(fontSize: 20),
                    ),
              images == null
                  ? selectedImage == null
                      ? Container()
                      : CircularProgressIndicator()
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
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
