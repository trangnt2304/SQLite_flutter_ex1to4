import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_sample/data/database/image_database.dart';
import 'package:sqlite_sample/data/service/image_service.dart';
import 'package:sqlite_sample/data/image_repository.dart';
import 'package:sqlite_sample/main_controller.dart';

import 'data/model/image_model.dart';

void main() async {
  /// Avoid errors caused by flutter upgrade
  WidgetsFlutterBinding.ensureInitialized();
  ImageDatabase.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

MainController mainController =
    MainController(ImageRepositoryImplement(ImageService()));

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController textEditingController = TextEditingController();
  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    mainController.getAllImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo SQLite'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 16,
              ),
              CarouselSlider(
                carouselController: carouselController,
                options: CarouselOptions(
                  height: size.height * 0.5,
                  initialPage: 0,
                  viewportFraction: 1,
                  reverse: false,
                  autoPlay: false,
                ),
                items: mainController.listImageUrl.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      if (i.imageUrl.isNotEmpty) {
                        return CachedNetworkImage(
                          imageUrl: i.imageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(64)),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          errorWidget: (BuildContext context, String url, _) =>
                              Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          placeholder: (BuildContext context, String url) =>
                              const Center(child: CupertinoActivityIndicator()),
                        );
                      }
                      return Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(16)),
                      );
                    },
                  );
                }).toList(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        carouselController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      },
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: const BorderSide(color: Colors.red)))),
                      child: const Text('Backward')),
                  const SizedBox(
                    width: 8,
                  ),
                  TextButton(
                      onPressed: () {
                        carouselController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      },
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  side: const BorderSide(color: Colors.red)))),
                      child: const Text('Forward')),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.topLeft,
                child: const Text('URL'),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                child: TextFormField(
                  controller: textEditingController,
                  validator: (value) {
                    if (value == null && value == '') {
                      return 'Nhập đường link';
                    }
                    return null;
                  },
                  enableSuggestions: false,
                  autocorrect: false,
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    filled: true,
                    hintStyle: const TextStyle(
                      color: Color(0xffcBFBFBF),
                    ),
                    hintText: "Mã dự án",
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: TextButton(
                    onPressed: () {
                      setState(
                        () {
                          mainController.insertImageUrl(
                              ImageUrl(imageUrl: textEditingController.text));
                        },
                      );
                      textEditingController.clear();
                    },
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    side:
                                        const BorderSide(color: Colors.red)))),
                    child: const Text('Add link')),
              ),
            ],
          ),
        ));
  }
}