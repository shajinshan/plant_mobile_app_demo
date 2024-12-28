import 'package:flutter/material.dart';
import 'package:plant_sell/provider/userData.dart';
import 'package:plant_sell/screens/CartScreen.dart';
import 'package:plant_sell/screens/HomeScreen.dart';
import 'package:plant_sell/screens/LoginUser.dart';
import 'package:plant_sell/screens/Register.dart';
import 'package:plant_sell/screens/searchScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserDataModel(),
      child: (const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orchids',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> screens = [HomeScreen(), CartScreen()];

  List<String> _appBarTit = ["Orchids", "Cart"];
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    //user Id
    String _id = Provider.of<UserDataModel>(context).userId;

    //LoginStatus
    bool loginStatus = Provider.of<UserDataModel>(context).loginStatus;

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTit[_currentPageIndex]),
        actions: [
          IconButton(
            onPressed: () {
              loginStatus
                  ? showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Logout"),
                          content: ElevatedButton(
                            onPressed: () {
                              loginStatus = false;
                              Provider.of<UserDataModel>(context, listen: false)
                                  .updateLoginStatus(false);

                              Navigator.pop(context);
                            },
                            child: Text("logout"),
                          ),
                        );
                      })
                  : Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                      return UserLogin();
                    }));
            },
            icon:
                loginStatus ? Icon(Icons.person) : Icon(Icons.person_add_alt_1),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchWithDropdown();
              }));
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Orchids',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);

                // Handle navigation to home
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart_checkout),
              title: const Text('Order'),
              onTap: () {
                // Handle navigation to order
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_late_rounded),
              title: const Text('About'),
              onTap: () {
                // Handle navigation to about
              },
            ),
          ],
        ),
      ),
      body: screens[_currentPageIndex], // Main content
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) => setState(() {
          _currentPageIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: "cart",
          ),
        ],
      ),
    );
  }
}
