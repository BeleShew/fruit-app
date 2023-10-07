import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_page_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key){
   Get.put(HomePageController());
  }
  @override
  Widget build(BuildContext context) {
    var controllers= Get.find<HomePageController>();
    controllers.init(context);
    return GetBuilder<HomePageController>(
      builder: (controller){
        return Scaffold(
          backgroundColor:const Color(0x0ff00000),
          drawerDragStartBehavior:DragStartBehavior.start,
          drawerEnableOpenDragGesture: true,
          bottomNavigationBar:ClipRRect(
            borderRadius:const BorderRadius.only(
              topLeft: Radius.circular(5.0),
              topRight: Radius.circular(5.0),
            ),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 2,color: Color(0xff3A3A3A))
                )
              ),
              child:BottomNavigationBar(
                  selectedItemColor:const  Color(0xffFF016B), // Set the selected item color
                  unselectedItemColor:const Color(0xff3A3A3A),
                  type: BottomNavigationBarType.fixed,
                  backgroundColor:Colors.black.withOpacity(0.4),
                  items: [
                    BottomNavigationBarItem(
                      backgroundColor:const Color(0xff000000),
                      // icon: Icon(Icons.home_outlined,color: Color(0xffFF016B)),
                      icon: Image.asset('assets/images/home_icon.png'),
                      label: '홈',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset('assets/images/btcon_28.png'),
                      label: '스팟',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset('assets/images/chat_icon.png'),
                      label: '채팅',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset('assets/images/user_icon.png'),
                      label: '마이',
                    ),
                  ],
                ),
            ),
          ),
          floatingActionButton: Container(
            margin: const EdgeInsets.only(top: 30),
            height: 45,
            width: 45 ,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF393939),
                  width: 2,
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Color(0xff2F2F2F),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(500.0),
                onTap: () {},
                child: const ImageIcon(
                  AssetImage(
                    'assets/images/center_nav_bar.png',
                  ),
                  color: Colors.black,
                  size: 10,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          body:SafeArea(
            child:Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child:Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/btcon_28.png'),
                          const SizedBox(width: 5,),
                          const Text("목이길어슬픈기린님의 새로운 스팟",style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                    Card(
                      // color:const Color(000000),
                      color:const Color(0xff000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side:const BorderSide(
                          color: Color(0xff212121),
                        ),
                      ),
                      child: const Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded,color: Color(0xffFF006B),),
                            SizedBox(width: 5,),
                            Text("323,233",style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(padding:const EdgeInsets.only(right: 5,),
                          child: Image.asset('assets/images/btcon_40.png'),
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 40,),
                Container(
                  decoration:const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  height:MediaQuery.of(context).size.height-250,
                  child: controller.carouselItemList.isEmpty && !controller.isSearching?
                  Center(
                    child:Container(
                      color:const Color(0xff000000),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("추천 드릴 친구들을 준비 중이에요",style: TextStyle(color: Color(0xffFCFCFC),
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),),
                          SizedBox(height:10),
                          Text("매일 새로운 친구들을 소개시켜드려요",style: TextStyle(color: Color(0xffADADAD),
                              fontWeight: FontWeight.normal,
                              fontSize: 13
                          ),),
                        ],
                      ),
                    ),
                  ):
                  CarouselSlider(
                    carouselController: controller.carouselController,
                    items:List.generate(controller.carouselItemList.length, (index) {
                      return Dismissible(
                        direction:DismissDirection.down,
                        onDismissed: (direction){
                          if (kDebugMode) {
                            print(direction);
                          }
                        },
                        confirmDismiss: (direction){
                          var swipes= controller.swipeCarouselSlider(direction,index);
                          return swipes;
                        },
                        key:UniqueKey(),
                        child: Dismissible(
                          direction:DismissDirection.endToStart,
                          onDismissed: (direction){
                            if (kDebugMode) {
                              print(direction);
                            }
                          },
                          confirmDismiss: (direction){
                            var swipes= controller.swipeCarouselSlider(direction,index);
                            return swipes;
                          },
                          key:UniqueKey(),
                          child:Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Stack(
                              children: [
                                index==controller.currentCarouselIndex?
                                SizedBox(
                                    child:controller.carouselItemList[index].carouselDetails[controller.pageViewIndex]
                                ):SizedBox(
                                    child:controller.carouselItemList[index].carouselDetails.first
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      onTap: () {
                                        if(controller.pageViewIndex>0){
                                          controller.pageViewIndex--;
                                        }
                                        controller.update();
                                      },
                                      child:Container(
                                        height: 100,
                                        width: 100,
                                        decoration:const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          color:Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      onTap: () {
                                        if(controller.pageViewIndex<controller.carouselItemList[index].carouselDetails.length-1){
                                          controller.pageViewIndex++;
                                        }
                                        controller.update();
                                      },
                                      child:Container(
                                        height: 100,
                                        width: 100,
                                        decoration:const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          color:Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                index==controller.currentCarouselIndex?Padding(
                                  padding: const EdgeInsets.only(top:10,left: 10),
                                  child:
                                  SizedBox(
                                    width: Get.size.width,
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: controller.carouselSliderIndicator(controller.pageViewIndex),
                                    ),
                                  ),
                                ):Container(),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    options: CarouselOptions(
                      height:Get.size.height,
                      viewportFraction: 0.89,
                      initialPage: 0,
                      scrollPhysics:const NeverScrollableScrollPhysics(),
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: false,
                      padEnds:false,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (int index, CarouselPageChangedReason reason) {
                      },
                    ),
                  ),
                ),
              ],
            ),

          ),
        );
      },
    );
  }
}
