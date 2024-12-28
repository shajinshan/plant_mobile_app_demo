import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plant_sell/screens/Register.dart';
import 'package:plant_sell/screens/allPlantsScreen.dart';
import 'package:plant_sell/widgets/curosalHome.dart';
import 'package:plant_sell/widgets/newStocks.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<String> _imagePath = [
  "https://plus.unsplash.com/premium_photo-1667516411046-f0ee053f7d58?q=80&w=3269&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "https://plus.unsplash.com/premium_photo-1675293872218-34f853669263?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  "https://plus.unsplash.com/premium_photo-1675635167686-f5694cd793f3?q=80&w=3271&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
];

late List<Widget> _pages;
late List<Widget> _newStockPages;
late List<Widget> _allPlants;

final PageController _pageController = PageController(initialPage: 0);

int _activePage = 0;

Timer? _timer;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.page == _pages.length - 1) {
        _pageController.animateToPage(0,
            duration: Duration(milliseconds: 500), curve: Curves.bounceInOut);
      } else {
        _pageController.nextPage(
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
  }

  void initState() {
    _pages = List.generate(
        _imagePath.length,
        (index) => ImageCurosal(
              imgPath: _imagePath[index],
            ));

    _newStockPages = List.generate(3, (index) => NewStocks());
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //image slider
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 255, 255)),
                child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        _activePage = value;
                      });
                    },
                    controller: _pageController,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _pages[index];
                    }),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  _pages.length,
                  (index) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                            _pageController.animateToPage(index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          },
                          child: CircleAvatar(
                            radius: _activePage == index ? 6 : 4,
                            backgroundColor: _activePage == index
                                ? Colors.black
                                : const Color.fromARGB(255, 137, 137, 137),
                          ),
                        ),
                      )),
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text(
                "New Stocks",
                style: TextStyle(fontSize: 22),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 4 + 10,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: Color.fromARGB(255, 223, 223, 223)),
                    color: Color.fromARGB(255, 231, 230, 230)),
                child: PageView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return _newStockPages[index];
                    }),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AllPlantsScreen();
                  }));
                },
                child: Text("show all"))
          ],
        ),
      ),
    );
  }
}
