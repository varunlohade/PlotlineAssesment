import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:plotline_app/storage.dart';

class UrlPicker extends StatefulWidget {
  const UrlPicker({Key? key}) : super(key: key);

  @override
  State<UrlPicker> createState() => _UrlPickerState();
}

class _UrlPickerState extends State<UrlPicker> {
  File? selectedImage;
  String message = "";
  var progress = 0;
  var images;
    final Storage storage = Storage();

  Future<void> _download() async {
    final response = await http.get(Uri.parse(controller.text));

    // Get the image name
    final imageName = path.basename(controller.text);
    // Get the document directory path
    final appDir = await path_provider.getApplicationDocumentsDirectory();

    // This is the saved image path
    // You can use it to display the saved image later
    final localPath = path.join(appDir.path, imageName);

    // Downloading
    final imageFile = File(localPath);
    await imageFile.writeAsBytes(response.bodyBytes);
    print("Saved");

    setState(() {
      selectedImage = imageFile;
    });
    uploadImage(imageName);
  }

  uploadImage(String name) async {
    // print("Selected Image ${bytes}");

    print("Working");
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
    // uploadImage();
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

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Url Picker")),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Center(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: TextField(
                keyboardType: TextInputType.url,
                enableInteractiveSelection: true,
                controller: controller,
                decoration: InputDecoration(hintText: "Enter the URL"),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: _download,
              child: Text("load"),
            ),
          ),
          controller.text.isEmpty
              ? Container()
              : Container(
                  child: Image.file(selectedImage!),
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
        ]),
      ))),
    );
  }
}
