import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plant_sell/provider/userData.dart';
import 'package:plant_sell/screens/CartScreen.dart';
import 'package:provider/provider.dart';

class AllPlantsScreen extends StatefulWidget {
  const AllPlantsScreen({super.key});

  @override
  State<AllPlantsScreen> createState() => _AllPlantsScreenState();
}

final String _allPlantApi = "http://localhost:8082/start/readAll";

class _AllPlantsScreenState extends State<AllPlantsScreen> {
  final String filterCategory = "orchid";

  List<dynamic> datas = [];
  //stores original data
  List<dynamic> masterData = [];

  Future<void> fetchAllPlantData() async {
    final response = await http.get(Uri.parse(_allPlantApi));

    if (response.statusCode == 200) {
      final List<dynamic> deCode = jsonDecode(response.body);
      setState(() {
        masterData = deCode;
        datas = List.from(masterData);
      });
    } else {
      print("Cannot get all data");
    }
  }

//cart func
  Future<void> addTocCart(String id, Map<String, dynamic> data) async {
    final String _addToCartApi =
        "http://localhost:8082/cartfun/cart/addCart/${id}";

    final response = await http.post(
      Uri.parse(_addToCartApi),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("added");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Added to Cart")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(" First Login to Add Cart")));
    }
  }

  //func for filter
  void filterPlant(String category) {
    setState(() {
      datas =
          masterData.where((plant) => plant["category"] == category).toList();
    });
  }

  void resetFilter() {
    setState(() {
      datas = List.from(masterData);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllPlantData();
  }

  bool btnFav = true;

  @override
  Widget build(BuildContext context) {
    int cartCount = Provider.of<UserDataModel>(context).cartCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Plants"),
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (contex) => CartScreen()));
              },
              icon: Row(
                children: [
                  const Icon(Icons.shopping_cart_rounded),
                  Text(cartCount.toString())
                ],
              )),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Filter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('All Plants'),
              onTap: () {
                resetFilter();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Orchids'),
              onTap: () {
                filterPlant("Orchids");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Indoor'),
              onTap: () {
                filterPlant("indoor");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: datas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: datas.length,
                itemBuilder: (context, index) {
                  final item = datas[index];
                  return InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item["productName"]),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.cancel))
                                ],
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 400,
                                      width: 400,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          item["img"],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "category :${item["category"]}",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text("Description:${item["description"]}"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "₹${item["price"]}",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors.green),
                                          onPressed: () {
                                            //add to cart
                                            String id =
                                                Provider.of<UserDataModel>(
                                                        context,
                                                        listen: false)
                                                    .userId;

                                            // Example product data
                                            final Map<String, dynamic>
                                                productData = {
                                              'productName':
                                                  item['productName'],
                                              'category': item['category'],
                                              'img': item['img'],
                                              'description':
                                                  item['description'],
                                              'price': item['price'],
                                              'productId': item[
                                                  'id'], // Replace with your product ID key
                                            };

                                            addTocCart(id, productData);
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.shopping_bag),
                                              Text("Add")
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 206, 205, 205)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            width: 300,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item["img"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['productName'] ?? 'No Name',
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 7, 7, 7),
                                          fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text("price :${item["price"]}")
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 7),
                                child: InkWell(
                                    onTap: () {
                                      String id = Provider.of<UserDataModel>(
                                              context,
                                              listen: false)
                                          .userId;

                                      // Example product data
                                      final Map<String, dynamic> productData = {
                                        'productName': item['productName'],
                                        'category': item['category'],
                                        'img': item['img'],
                                        'description': item['description'],
                                        'price': item['price'],
                                        'productId': item[
                                            'id'], // Replace with your product ID key
                                      };

                                      addTocCart(id, productData);
                                    },
                                    child: const Icon(
                                        Icons.shopping_cart_checkout_outlined)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
