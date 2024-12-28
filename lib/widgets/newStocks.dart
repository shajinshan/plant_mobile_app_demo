import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:plant_sell/provider/userData.dart';
import 'package:provider/provider.dart';

class NewStocks extends StatefulWidget {
  const NewStocks({super.key});

  @override
  State<NewStocks> createState() => _NewStocksState();
}

class _NewStocksState extends State<NewStocks> {
  final String newStocksApi = "http://localhost:8082/start/latest";

  List<dynamic> data = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(newStocksApi));
    try {
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);

        setState(() {
          data = decodedData;
        });
      } else {
        print("error occured new Stocks api");
      }
    } catch (error) {
      print(error);
    }
  }

//new stock popup
  void newStockPopup(index) {
    showDialog(
        context: context,
        builder: (context) {
          final item = data[index];
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  // SizedBox(
                  //   width: 100,
                  //   child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           foregroundColor: Colors.white,
                  //           backgroundColor: Colors.green),
                  //       onPressed: () {
                  //         //add to cart
                  //         String id =
                  //             Provider.of<UserDataModel>(context, listen: false)
                  //                 .userId;

                          
                  //         final Map<String, dynamic> productData = {
                  //           'productName': item['productName'],
                  //           'category': item['category'],
                  //           'img': item['img'],
                  //           'description': item['description'],
                  //           'price': item['price'],
                  //           'productId':
                  //               item['id'], 
                  //         };

                  //         // addTocCart(id, productData);
                  //       },
                  //       child: const Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [Icon(Icons.shopping_bag), Text("Add")],
                  //       )),
                  // )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                //new stack btn
                newStockPopup(index);
              },
              child: Container(
                child: Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item['img'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["productName"],
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("category :${item["category"]}"),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 100,
                            width: 200,
                            child: Text("Description : ${item["description"]}"),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("₹${item["price"]}")
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
