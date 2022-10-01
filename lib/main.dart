import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:plotline_app/camerapick.dart';
import 'package:plotline_app/displayimages.dart';
import 'package:plotline_app/homescreen.dart';
import 'package:plotline_app/urlpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlotLine Assesment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Plotline '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? selectedImage;
  String message = "";
  ScrollController _scrollController = ScrollController();

  var progress = 0;
  var images;
  // uploadImage() async {
  //   final request = http.MultipartRequest("POST",
  //       Uri.parse("https://edgedetectionassesment.herokuapp.com/upload"));
  //   final headers = {"Content-type": "multipart/form-data"};
  //   request.files.add(http.MultipartFile('image',
  //       selectedImage!.readAsBytes().asStream(), selectedImage!.lengthSync(),
  //       filename: selectedImage!.path.split("/").last));

  //   request.headers.addAll(headers);
  //   final response = await request.send();
  //   http.Response res = await http.Response.fromStream(response);
  //   print(res);
  //   print("This is res body ${res.bodyBytes}");
  //   // final resJson = jsonDecode(res.body);
  //   images = res.bodyBytes;

  //   setState(() {});
  //   // message = compute(base64Decode, res.body);
  // }

  // Future getImage() async {
  //   final pickedImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   selectedImage = File(pickedImage!.path);
  //   setState(() {});
  // }

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
    // Timer(
    //   Duration(seconds: 1),
    //   () => _scrollController.animateTo(
    //     _scrollController.position.maxScrollExtent,
    //     duration: Duration(seconds: 1),
    //     curve: Curves.fastOutSlowIn,
    //   ),
    // );
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => UrlPicker()));
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.link,
                              color: Colors.white,
                            ),
                            Text(
                              "URL",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => CameraPick()));
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                              ),
                              Text(
                                "Camera",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => HomePage()));
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_album,
                              color: Colors.white,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          // SingleChildScrollView(
          //   controller: _scrollController,
          //   child: Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         selectedImage == null
          //             ? Text(
          //                 "Please pick a image to convert",
          //                 style: TextStyle(
          //                     fontWeight: FontWeight.bold, fontSize: 20),
          //               )
          //             : Column(
          //                 children: [
          //                   Text("Original Image"),
          //                   Padding(
          //                     padding: const EdgeInsets.all(10.0),
          //                     child: Image.file(selectedImage!),
          //                   ),
          //                 ],
          //               ),
          //         selectedImage == null
          //             ? Container()
          //             : TextButton.icon(
          //                 style: ButtonStyle(
          //                     backgroundColor:
          //                         MaterialStateProperty.all(Colors.blue)),
          //                 onPressed:
          //                   uploadImage,

          //                 icon: const Icon(
          //                   Icons.change_circle,
          //                   color: Colors.white,
          //                 ),
          //                 label: const Text(
          //                   "Convert",
          //                   style: TextStyle(color: Colors.white),
          //                 ),
          //               ),
          //         selectedImage == null
          //             ? Container()
          //             : const Text(
          //                 "Detect edges by click on the convert button",
          //                 style: TextStyle(fontSize: 20),
          //               ),
          //         images == null
          //             ? selectedImage == null
          //                 ? Container()
          //                 : Text("NO Image")
          //             : Column(
          //                 children: [
          //                   images.length == 0
          //                       ? CircularProgressIndicator()
          //                       : Padding(
          //                           padding: const EdgeInsets.all(10.0),
          //                           child: Image.memory(images),
          //                         )
          //                 ],
          //               )
          //       ],
          //     ),
          //   ),
          // ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => DisplayImages()));
        },
        child: Icon(Icons.download),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
