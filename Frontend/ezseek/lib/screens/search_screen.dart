import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';
  File? _imageFile;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    setState(() {
      _isLoading = true;
      _products = [];
    });

    final url = Uri.parse('https://be25-14-192-242-19.ngrok-free.app/query');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'question': query,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _products = jsonResponse['products'];
        _isLoading = false;
      });
      print('Search successful: ${response.body}');
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Search failed: ${response.statusCode}');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black12))),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      child: Icon(Icons.arrow_back_ios_new),
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        height: 40,
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(Icons.search),
                            SizedBox(width: 5),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(height: 1.7),
                                  border: InputBorder.none,
                                ),
                                onSubmitted: (value) {
                                  _search(value);
                                },
                              ),
                            ),
                            GestureDetector(
                              child: _imageFile == null
                                  ? Icon(
                                      Icons.camera_alt,
                                      color: Colors.black,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.file(
                                        _imageFile!,
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              onTap: () => _showImageSourceActionSheet(context),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.mic,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Search",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text("Searching..."),
                          ],
                        ),
                      )
                    : _errorMessage.isNotEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  repeat: false,
                                  'assets/animations/empty_box.json',
                                ),
                                SizedBox(height: 10),
                                Text(_errorMessage),
                              ],
                            ),
                          )
                        : _products.isNotEmpty
                            ? GridView.builder(
                                padding: const EdgeInsets.all(10.0),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: _products.length,
                                itemBuilder: (context, index) {
                                  final product = _products[index];
                                  return Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['product_name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                            'Category: ${product['category']}'),
                                        Text(
                                            'Subcategory: ${product['subcategory']}'),
                                        Text(
                                            'Price: RM${product['product_price']}'),
                                        Text(
                                            'Rating: ${product['product_ratings']}'),
                                        Text(
                                            'Reviews: ${product['rating_count']}'),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : SingleChildScrollView(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Lottie.asset(
                                            repeat: false,
                                            'assets/animations/empty_box.json'),
                                      ),
                                      Text('No products found.'),
                                    ],
                                  ),
                                ),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
