import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:photo_collage/Data.dart';

class PhotoCollage extends StatefulWidget {
  @override
  _PhotoCollageState createState() => _PhotoCollageState();
}

class _PhotoCollageState extends State<PhotoCollage> {
  int currentIndex = 1;
  List photosCollection1;
  ScrollController photo1ScrollController = ScrollController();
  ScrollController photo2ScrollController = ScrollController();

  List photosCollection2;
  String clientId = "Paste Your Api Key";
  int photo1Page = 1;
  int photo2Page = 1;
  @override
  void initState() {
    photosCollection1 = [];
    photosCollection2 = [];

    getPicturesCollection1();
    getPicturesCollection2();
    photo1ScrollController = ScrollController()
      ..addListener(() async {
        if (photo1ScrollController.position.pixels ==
            photo1ScrollController.position.maxScrollExtent) {
          photo1Page++;
          setState(() {});
          try {
            await getPicturesCollection1(page: photo1Page);
          } catch (e) {}
        }
      });
    photo2ScrollController = ScrollController()
      ..addListener(() async {
        if (photo2ScrollController.position.pixels ==
            photo2ScrollController.position.maxScrollExtent) {
          photo2Page++;
          setState(() {});
          try {
            await getPicturesCollection2(page: photo2Page);
          } catch (e) {}
        }
      });
    super.initState();
  }

  getPicturesCollection1({page = 1}) async {
    Response res;
    try {
      res = await Dio().get(
          "https://api.unsplash.com/collections/139386/photos/?client_id=$clientId&page=$page");
      photosCollection1.addAll(res.data);
      print(photosCollection1.length);
      setState(() {});
      return res;
    } on DioError catch (e) {
      print(e);
      photosCollection1 = data1;
      setState(() {});
    }
  }

  getPicturesCollection2({page = 1}) async {
    Response res;
    try {
      res = await Dio().get(
          "https://api.unsplash.com/collections/1580860/photos/?client_id=$clientId&page=$page");
      photosCollection2.addAll(res.data);
      print(photosCollection2.length);
      setState(() {});
      return res;
    } on DioError catch (e) {
      print(e);
      photosCollection2 = data2;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight - 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              children: <Widget>[
                albumTypeUI(1, "Pets"),
                albumTypeUI(2, "Nature"),
              ],
            ),
          ],
        ),
      ),
      body: photosCollection1 == [] || photosCollection2 == []
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              controller: currentIndex == 1
                  ? photo1ScrollController
                  : photo2ScrollController,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 5,
                childAspectRatio: .56,
              ),
              itemCount: currentIndex == 1
                  ? photosCollection1 != [] ? photosCollection1.length : 0
                  : photosCollection2 != [] ? photosCollection2.length : 0,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      color: Colors.white,
                    ),
                    width: 200,
                    height: 350,
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          currentIndex == 1
                              ? photosCollection1[index]["urls"]["regular"]
                              : photosCollection2[index]["urls"]["regular"],
                          fit: BoxFit.fill,
                          height: 283,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 3.0, left: 3, right: 3),
                          child: Text(
                            currentIndex == 1
                                ? photosCollection1[index]["description"] ?? ""
                                : photosCollection2[index]["description"] ?? "",
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget albumTypeUI(index, text) {
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.0,
        height: MediaQuery.of(context).size.height / 14,
        color: Colors.grey[300],
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 2.2,
            height: MediaQuery.of(context).size.height / 15,
            padding: EdgeInsets.all(7),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: index == currentIndex ? Colors.white : Colors.transparent,
              shape: BoxShape.rectangle,
            ),
            child: Center(
              child: Text(
                text.toString(),
                style: TextStyle(
                    color: index == currentIndex ? Colors.black : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
