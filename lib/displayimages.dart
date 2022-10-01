import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:plotline_app/storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DisplayImages extends StatefulWidget {
  const DisplayImages({Key? key}) : super(key: key);

  @override
  State<DisplayImages> createState() => _DisplayImagesState();
}

class _DisplayImagesState extends State<DisplayImages> {
  @override
  Widget build(BuildContext context) {
    final storage = Storage();
    return Scaffold(
      appBar: AppBar(
        title: Text("Images > Firebase Storage"),
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: storage.listFiles(),
        builder: (BuildContext context,
            AsyncSnapshot<firebase_storage.ListResult> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.items.length,
                      itemBuilder: ((context, index) {
                        var url = storage.downloadURL;
                        var name = snapshot.data!.items[index].name;
                        print(url);
                        return Column(
                          children: [
                            FutureBuilder<String>(
                              future:
                                  snapshot.data!.items[index].getDownloadURL(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      Text("Image: ${name}"),
                                      Container(
                                        height: 200,
                                        width: 200,
                                        child: Image.network(
                                            snapshot.data.toString()),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  );
                                }
                                return CircularProgressIndicator();
                              },
                            ),
                            // Align(
                            //   alignment: snapshot.data!.items[index].name
                            //           .contains("Modified_image")
                            //       ? Alignment.centerLeft
                            //       : Alignment.centerRight,
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Container(
                            //       width: 50,
                            //       decoration: BoxDecoration(
                            //           color: Colors.blueAccent,
                            //           borderRadius: BorderRadius.circular(20)),
                            //       child: Container(child: Text("")),
                            //     ),
                            //   ),
                            // ),
                          ],
                        );
                        // : Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Container(
                        //       alignment: Alignment.centerRight,
                        //       child: Container(
                        //           child: Text(
                        //         snapshot.data!.items[index].name,
                        //         style: TextStyle(fontSize: 15),
                        //       )),
                        //     ),
                        //   );
                      }),
                    ),
                  ],
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return Container();
        },
      )),
    );
  }
}
