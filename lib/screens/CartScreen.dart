import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:plant_sell/provider/userData.dart';
import 'package:plant_sell/screens/LoginUser.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? idForUser;

  List<dynamic> data = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    idForUser = Provider.of<UserDataModel>(context, listen: false).userId;
    getAllCartItemsById();
  }

  Future<void> getAllCartItemsById() async {
    String cartApi =
        "http://localhost:8082/cartfun/cart/readAllByUserId/${idForUser}";

    final response = await http.get(Uri.parse(cartApi));

    if (response.statusCode == 200) {
      List<dynamic> decodeData = jsonDecode(response.body);
      setState(() {
        data = decodeData;
      });
      Provider.of<UserDataModel>(context, listen: false)
          .updateCartCount(data.length);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(" First Login to Add Cart")));
    }
  }

  Future<void> deleteItemFromCart(String productId) async {
    String deleteApi = "http://localhost:8082/cartfun/cart/delete/${productId}";

    final response = await http.delete(
      Uri.parse(deleteApi),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Removed from cart")));
      setState(() {
        data.removeWhere((item) => item['id'] == productId);
      });
      Provider.of<UserDataModel>(context, listen: false)
          .updateCartCount(data.length);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("unable to remove")));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool loginState =
        Provider.of<UserDataModel>(context, listen: false).loginStatus;
    return Scaffold(
        body: !loginState
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("First Login To Add Cart"),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return UserLogin();
                          }));
                        },
                        child: const Text("Login"))
                  ],
                ),
              )
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final items = data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          items['img'],
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        items['productName'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      subtitle: Text(items['category']),
                      trailing: IconButton(
                        onPressed: () {
                          //delete from cart
                          deleteItemFromCart(items['id'].toString());
                        },
                        icon: const Icon(Icons.delete),
                      ),
                      tileColor: const Color.fromARGB(255, 243, 237, 237),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  );
                },
              ));
  }
}
