import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_sample/controller/main_controller.dart';
import 'package:sqlite_sample/data/database/image_database.dart';
import 'package:sqlite_sample/data/image_repository.dart';
import 'package:sqlite_sample/data/model/image_model.dart';
import 'package:sqlite_sample/data/service/image_service.dart';

void main() async {
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
  ValueNotifier<List<ImageUrl>> listImageUrl = ValueNotifier(<ImageUrl>[]);

  @override
  void initState() {
    super.initState();
    onInit();
  }

  Future<void> onInit() async {
    await mainController.getAllImageUrl();
    listImageUrl.value = mainController.listImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print('Dong 59: ${mainController.listImageUrl.length}');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo SQLite'),
          backgroundColor: const Color(0xff4C4646),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 32,
              ),
              Container(
                margin: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: const Color(0xffFFE4E1),
                    borderRadius: BorderRadius.circular(8)),
                child: ValueListenableBuilder<List<ImageUrl>>(
                    valueListenable: listImageUrl,
                    builder: (context, newValue, widget) {
                      return CarouselSlider(
                        carouselController: carouselController,
                        options: CarouselOptions(
                          height: size.height * 0.5,
                          initialPage: 0,
                          viewportFraction: 1,
                          reverse: false,
                          autoPlay: false,
                        ),
                        items: listImageUrl.value.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              if (i.imageUrl.isNotEmpty) {
                                return CachedNetworkImage(
                                  imageUrl: i.imageUrl,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    margin: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(64)),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  errorWidget:
                                      (BuildContext context, String url, _) {
                                    if (File(i.imageUrl).existsSync() == true) {
                                      return Container(
                                        child: Image.file(
                                          File(i.imageUrl),
                                        ),
                                        margin: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        margin: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/image/ic_no_img.jpeg'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  placeholder: (BuildContext context,
                                          String url) =>
                                      const Center(
                                          child: CupertinoActivityIndicator()),
                                );
                              }
                              return Container(
                                margin: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/image/ic_no_img.jpeg'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(16)),
                              );
                            },
                          );
                        }).toList(),
                      );
                    }),
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
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
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
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
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
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextButton(
                    onPressed: () async {
                      listImageUrl.value = await mainController.insertImageUrl(
                          ImageUrl(imageUrl: textEditingController.text));
                      textEditingController.clear();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    side:
                                        const BorderSide(color: Colors.red)))),
                    child: const Text('Add URL to Database')),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ));
  }
}
