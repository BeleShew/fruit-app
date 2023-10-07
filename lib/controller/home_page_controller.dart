import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import '../services/access_firebase_data.dart';
import '../model/fruit_model.dart';
import '../services/loading.dart';

class HomePageController extends GetxController {
  int pageViewIndex = 0;
  int currentCarouselIndex = 0;
  Color selectedColor=const Color(0xff202020);
  CarouselController carouselController = CarouselController();
  List<CarouselList> carouselItemList=[];
  bool isAllCardDismissed=false;
  bool isSearching=true;

  init(context) async{
    carouselItemList=[];
    ShowEasyLoading.showDotedProgress(context:context);
    await FlutterFireBaseData.getFruitList();
    await initializeCards();
    isSearching=false;
   update();
    ShowEasyLoading.dismisLoading();
  }
  initializeCards() async{
    try{
      carouselItemList=[];
      if(FlutterFireBaseData.fruitList.isNotEmpty){
        for (var element in FlutterFireBaseData.fruitList) {
         var details= await fruitDetailsCards(element);
          carouselItemList.add(CarouselList(carouselDetails:details));
        }
      }
    }catch(ex){
      if (kDebugMode) {
        print(ex);
      }
    }
  }
 Future<List<Widget>> fruitDetailsCards(FruitModel dataModel) async{
    try{
      List<Widget> fruitDetails =[];
      for (int i=0;i<dataModel.images!.length;i++){
        dataModel.images?[i].split(',');
        List<String> parts =dataModel.images?[i].split(',')??[];
        if (parts.length == 2){
          dataModel.images?[i]=parts[1];
          update();
        }
        if(i==0){
          fruitDetails.add(
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:const BorderRadius.all(Radius.circular(20)),
                    image: (dataModel.images?[1]!=null &&dataModel.images![0].isNotEmpty&&dataModel.images![0].startsWith("https"))?
                    DecorationImage(
                      image:NetworkImage(dataModel.images?[0]??""),
                      onError: (exception, stackTrace) {
                        const Center(
                          child:CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      },
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0),
                          BlendMode.darken
                      ),
                    ):
                    DecorationImage(
                      image:MemoryImage(
                          Uint8List.fromList(base64.decode(dataModel.images?[0]??""))
                      ),
                      onError: (exception, stackTrace) {
                        const Center(
                          child:CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      },
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0),
                          BlendMode.darken
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Container(
                    height: 450,
                    decoration:const BoxDecoration(
                      borderRadius:BorderRadius.all(Radius.circular(20)),
                      gradient:LinearGradient(
                        begin: FractionalOffset.bottomCenter,
                        end: FractionalOffset.topCenter,
                        colors:[
                          Color(0xff212121),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child:Padding(padding:const EdgeInsets.symmetric(horizontal: 20,),
                        child:Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                      color:const Color(0xff000000),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        side:const BorderSide(
                                          color: Color(0xff212121),
                                        ),
                                      ),
                                      child: Padding(padding:const EdgeInsets.symmetric(vertical: 6,horizontal: 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.star_rounded,color: Color(0xff2F2F2F),size: 20,),
                                            const SizedBox(width: 3,),
                                            Text("${dataModel.likeCount}",
                                              style:const TextStyle(
                                                fontFamily: 'Pretendard',
                                                letterSpacing: -0.6,
                                                color: Color(0xffFCFCFC),
                                                fontWeight: FontWeight.w500,
                                            ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text("${dataModel.name}",
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontFamily: 'Pretendard',
                                            letterSpacing: -0.6,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFFCFCFC),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          dataModel.age?.toString() ?? "",
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w300,
                                            color: Color(0xFFFCFCFC),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 5,),
                                    Text("${dataModel.location}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xFFD9D9D9),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Align(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  child:Transform.translate(
                                    offset: const Offset(0, 30),
                                    child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: GradientBoxBorder(
                                        gradient: LinearGradient(colors: [Color(0xff45FFF4),Color(0xff7000FF)]),
                                        width: 1.5,
                                      ),

                                    ),
                                    child: Padding(padding:const EdgeInsets.all(10),
                                      child: Image.asset('assets/images/heart_28.png'),
                                    ),
                                  ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            const Align(
                              alignment: Alignment.bottomCenter,
                              child: Icon(Icons.keyboard_arrow_down_sharp,color: Colors.white,),
                            ),
                            const SizedBox(height: 15,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        else if(i==1){
          fruitDetails.add( Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:const BorderRadius.all(Radius.circular(20)),
                  image:(dataModel.images?[1]!=null &&dataModel.images![1].isNotEmpty&&dataModel.images![1].startsWith("https"))?
                  DecorationImage(
                    image:NetworkImage(dataModel.images?[1]??""),
                    onError: (exception, stackTrace) {
                      const Center(
                        child:CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    },
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0),
                        BlendMode.darken
                    ),
                  ):
                  DecorationImage(
                    image:MemoryImage( Uint8List.fromList(base64.decode(dataModel.images?[1]??""))
                    ),
                    onError: (exception, stackTrace) {
                      const Center(
                        child:CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    },
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0),
                        BlendMode.darken
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Container(
                  height: 300,
                  decoration:const BoxDecoration(
                    borderRadius:BorderRadius.all(Radius.circular(20)),
                    gradient:LinearGradient(
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter,
                      colors:[
                        Color(0xff212121),
                        Color(0x00000000),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child:Padding(padding:const EdgeInsets.symmetric(horizontal: 20,),
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    color:const Color(0xff000000),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side:const BorderSide(
                                        color: Color(0xff212121),
                                      ),
                                    ),
                                    child: Padding(padding:const EdgeInsets.symmetric(vertical: 6,horizontal: 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.star_rounded,color: Color(0xff2F2F2F),size: 20,),
                                          const SizedBox(width: 3,),
                                          Text("${dataModel.likeCount}",
                                          style:const TextStyle(
                                            fontFamily: 'Pretendard',
                                            letterSpacing: -0.6,
                                            color: Color(0xffFCFCFC),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("${dataModel.name}",
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontFamily: 'Pretendard',
                                          letterSpacing: -0.6,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFFCFCFC),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        dataModel.age?.toString() ?? "",
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xFFFCFCFC),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Text("${dataModel.description}",
                                    style:const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xFFD9D9D9),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Align(
                                alignment: AlignmentDirectional.bottomCenter,
                                child:Transform.translate(
                                  offset: const Offset(0, 30),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: GradientBoxBorder(
                                        gradient: LinearGradient(colors: [Color(0xff45FFF4),Color(0xff7000FF)]),
                                        width: 1.5,
                                      ),

                                    ),
                                    child: Padding(padding:const EdgeInsets.all(10),
                                      child: Image.asset('assets/images/heart_28.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          const Align(
                            alignment: Alignment.bottomCenter,
                            child: Icon(Icons.keyboard_arrow_down_sharp,color: Colors.white,),
                          ),
                          const SizedBox(height: 15,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),);
        }
        else if(i==2){
          fruitDetails.add(Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:const BorderRadius.all(Radius.circular(20)),
                  image:
                  (dataModel.images?[2]!=null &&dataModel.images![2].isNotEmpty&&dataModel.images![2].startsWith("https"))?
                  DecorationImage(
                    image:NetworkImage(dataModel.images?[2]??""),
                    onError: (exception, stackTrace) {
                      const Center(
                        child:CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    },
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0),
                        BlendMode.darken
                    ),
                  ):
                  DecorationImage(
                    image:MemoryImage( Uint8List.fromList(base64.decode(dataModel.images?[2]??""))),
                    onError: (exception, stackTrace) {
                      const Center(
                        child:CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    },
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0),
                        BlendMode.darken
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Container(
                  height: 450,
                  decoration:const BoxDecoration(
                    borderRadius:BorderRadius.all(Radius.circular(20)),
                    gradient:LinearGradient(
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter,
                      colors:[
                        Color(0xff212121),
                        Color(0x00000000),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child:Padding(padding:const EdgeInsets.symmetric(horizontal: 20,),
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    color: const Color(0xff000000),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: const BorderSide(
                                        color: Color(0xff212121),
                                      ),
                                    ),
                                    child: Padding(padding:const EdgeInsets.symmetric(vertical: 6,horizontal: 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.star_rounded,color: Color(0xff2F2F2F),size: 20,),
                                          const SizedBox(width: 3,),
                                          Text("${dataModel.likeCount}",
                                            style:const TextStyle(
                                              fontFamily: 'Pretendard',
                                              letterSpacing: -0.6,
                                              color: Color(0xffFCFCFC),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("${dataModel.name}",
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontFamily: 'Pretendard',
                                          letterSpacing: -0.6,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFFCFCFC),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        dataModel.age?.toString() ?? "",
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xFFFCFCFC),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Wrap(
                                    spacing:10,
                                    direction:Axis.horizontal,
                                    children:_tagWidget(dataModel.tags??[]),
                                  ),
                                ],
                              ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.bottomCenter,
                                child:Transform.translate(
                                  offset: const Offset(0, 65),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: GradientBoxBorder(
                                        gradient: LinearGradient(colors: [Color(0xff45FFF4),Color(0xff7000FF)]),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Padding(padding:const EdgeInsets.all(10),
                                      child: Image.asset('assets/images/heart_28.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          const Align(
                            alignment: Alignment.bottomCenter,
                            child: Icon(Icons.keyboard_arrow_down_sharp,color: Colors.white,),
                          ),
                          const SizedBox(height: 15,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),);
        }
        else{
          fruitDetails.add(Stack(children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:const BorderRadius.all(Radius.circular(20)),
                image: (dataModel.images?[i]!=null &&dataModel.images![i].isNotEmpty&&dataModel.images![i].startsWith("https"))?
                DecorationImage(
                  image:NetworkImage(dataModel.images?[i]??""),
                  onError: (exception, stackTrace) {
                    const Center(
                      child:CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  },
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0),
                      BlendMode.darken
                  ),
                ):
                DecorationImage(
                  image:MemoryImage(
                      Uint8List.fromList(base64.decode(dataModel.images?[i]??""))
                    // const Base64Decoder().convert(dataModel.images![i]?? ""),
                  ),
                  onError: (exception, stackTrace) {
                    const Center(
                      child:CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  },
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0),
                      BlendMode.darken
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                height: 300,
                decoration:const BoxDecoration(
                  borderRadius:BorderRadius.all(Radius.circular(20)),
                  gradient:LinearGradient(
                    begin: FractionalOffset.bottomCenter,
                    end: FractionalOffset.topCenter,
                    colors:[
                      Color(0xff212121),
                      Color(0x00000000),
                    ],
                  ),
                ),
                child: Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child:Padding(padding:const EdgeInsets.symmetric(horizontal: 20,),
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(child:Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  color:const Color(0xff000000),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side:const BorderSide(
                                      color: Color(0xff212121),
                                    ),
                                  ),
                                  child: Padding(padding:const EdgeInsets.symmetric(vertical: 6,horizontal: 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.star_rounded,color: Color(0xff2F2F2F),size: 20,),
                                        const SizedBox(width: 3,),
                                        Text("${dataModel.likeCount}",
                                        style:const TextStyle(
                                          fontFamily: 'Pretendard',
                                          letterSpacing: -0.6,
                                          color: Color(0xffFCFCFC),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("${dataModel.name}",
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontFamily: 'Pretendard',
                                        letterSpacing: -0.6,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFFCFCFC),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      dataModel.age?.toString() ?? "",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xFFFCFCFC),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5,),
                                Wrap(
                                  spacing:10,
                                  direction:Axis.horizontal,
                                  children:_tagWidget(dataModel.tags??[]),
                                ),
                              ],
                            ),),
                            Align(
                              alignment: AlignmentDirectional.bottomCenter,
                              child:Transform.translate(
                                offset: const Offset(0, 65),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: GradientBoxBorder(
                                      gradient: LinearGradient(colors: [Color(0xff45FFF4),Color(0xff7000FF)]),
                                      width: 1.5,
                                    ),

                                  ),
                                  child: Padding(padding:const EdgeInsets.all(10),
                                    child: Image.asset('assets/images/heart_28.png'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: Icon(Icons.keyboard_arrow_down_sharp,color: Colors.white,),
                        ),
                        const SizedBox(height: 15,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          ),
          );
        }
      }
      return fruitDetails;
    }catch(ex){
      if (kDebugMode) {
        print(ex);
      }
      return [];
    }
  }
  List<Widget> _tagWidget(List<String> tages){
    try{
      List<Widget> fruitTagList=[];
      for (int i=0;i<tages.length;i++) {
        if(i==0){
          fruitTagList.add(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff621133).withOpacity(0.6),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    border: Border.all(
                      color: const Color(0xffFF016B),
                    ),
                  ),
                  child: Padding(
                    padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                    child: Text(tages[i],
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        color:Color(0xFFF5F5F5),
                        letterSpacing: -0.6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
              ],
            ),
          );
        }
        else{
          fruitTagList.add(
            Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff1A1A1A),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    border: Border.all(
                      color: const Color(0xff3A3A3A),
                    ),
                  ),
                  child: Padding(
                    padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                    child:  Text(tages[i],
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        color:Color(0xFFF5F5F5),
                        letterSpacing: -0.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
      return fruitTagList;
    }catch(ex){
      if (kDebugMode) {
        print(ex);
      }
      return [];
    }
  }
  List<Widget> carouselSliderIndicator(int index) {
    try{
      List<Widget> carouselIndicatorList=[];
      for (int i=0;i<FlutterFireBaseData.fruitList.length; i++){
        if(i==index){
          carouselIndicatorList.add(Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width:50,
                    height:3,
                    decoration: BoxDecoration(
                        borderRadius:const BorderRadius.all(Radius.circular(20)),
                        color:selectedColor,
                        gradient: const LinearGradient(colors:[
                          Color(0xffFF006B),
                          Color(0xffFF4593),
                        ])
                    ),
                  ),
                  i==FlutterFireBaseData.fruitList.length?Container():const SizedBox(width:5),
                ],
              ));
        }
        else{
          carouselIndicatorList.add(
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width:50,
                    height:3,
                    decoration: BoxDecoration(
                        borderRadius:const BorderRadius.all(Radius.circular(20)),
                        color:selectedColor,
                        gradient: const LinearGradient(colors:[
                          Color(0xff3A3A3A),
                          Color(0xff3A3A3A),
                        ])
                    ),
                  ),
                  i==FlutterFireBaseData.fruitList.length?Container():const SizedBox(width:5),
                ],
              )
          );
        }
      }
      update();
      return carouselIndicatorList;
    }catch(ex){
      if (kDebugMode) {
        print(ex);
      }
      return[];
    }
  }
  Future<bool> swipeCarouselSlider(DismissDirection direction, int index){
    if(direction==DismissDirection.down||direction==DismissDirection.endToStart) {
      carouselItemList.removeAt(index);
      currentCarouselIndex=index;
      pageViewIndex=0;
      update();
      return Future.value(true);
    }
    else{
      return Future.value(false);
    }
  }
}
class CarouselList{
  List<Widget> carouselDetails =[];
  CarouselList({required this.carouselDetails});
}