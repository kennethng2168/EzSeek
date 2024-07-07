import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShopScreen extends StatelessWidget {
  List<Map<String, String>> products = [
    {
      'name': 'Skincare',
      'price': 'RM299.00',
      'imageUrl': 'https://via.placeholder.com/150',
      'height': '300',
    },
    {
      'name': 'Apple Watch SE',
      'price': 'RM999.00',
      'imageUrl': 'https://via.placeholder.com/150',
      'height': '230',
    },
    {
      'name': 'Headphones',
      'price': 'RM199.00',
      'imageUrl': 'https://via.placeholder.com/150',
      'height': '250',
    },
    {
      'name': 'Laptop',
      'price': 'RM4599.00',
      'imageUrl': 'https://via.placeholder.com/150',
      'height': '300',
    },
    // Add more products as needed
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff1f1f1),
        title: _buildSearchBar(),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildCarouselOffers("New Customer Offer"),
              _buildCarouselOffers("Flash Sale"),
              _buildCategories(),
              _buildBottomContainers(products),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red,
        ), // Red border
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(height: 2),
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 10), // Space between camera icon and search icon
              Icon(Icons.search, color: Colors.red), // Search icon
            ],
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AI Capabilities',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10), // Space between text and camera icon
              Icon(Icons.image,
                  color: Colors.redAccent), // Camera icon on the right end
              const SizedBox(width: 10),
            ],
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildCarouselOffers(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white,
            Color(0xfff9a2b5).withOpacity(1),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(10), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2), // changes the shadow position
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            10), // Ensure child respects the border radius
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _buildOfferItems(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOfferItems() {
    return [
      _buildOfferItem('assets/milo.png', 'Milo', 'RM19.90', '27%'),
      _buildOfferItem('assets/tissue.png', 'Tissue', 'RM29.50', '1%'),
      _buildOfferItem('assets/card.png', 'Card', 'RM10.00', '0%'),
      _buildOfferItem('assets/hair_dryer.png', 'Hair Dryer', 'RM23.98', '80%'),
    ];
  }

  Widget _buildOfferItem(
      String imagePath, String name, String price, String discount) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 5),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            'Discount: $discount',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashSale() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: _buildCarouselCard(
          title: 'Flash Sale',
          items: [
            _buildFlashSaleItem('Item 1', 'RM31.98', '22%'),
            _buildFlashSaleItem('Item 2', 'RM1,720.00', '84%'),
            _buildFlashSaleItem('Item 3', 'RM1.53', '0%'),
            _buildFlashSaleItem('Item 4', 'RM8.99', '48%'),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselCard(
      {required String title, required List<Widget> items}) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 150,
            child: PageView(
              children: items,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashSaleItem(String name, String price, String discount) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network('https://via.placeholder.com/100', height: 80),
          Text(name),
          Text(price),
          Text(discount),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 80, // Adjust height as needed
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10),
        children: [
          _buildCategoryItem('Mall'),
          _buildCategoryItem('Muslim Fashion'),
          _buildCategoryItem('Muslim Fashion'),
          _buildCategoryItem('Muslim Fashion'),
          _buildCategoryItem('Bro, Jom Shopping'),
          // Add more categories here
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title) {
    return GestureDetector(
      onTap: () {
        // Handle category tap
        print('$title clicked');
        // You might want to navigate to another screen or show more items for the selected category
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Icon(Icons.category, size: 40), // Adjust icon size as needed
            SizedBox(height: 5),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomContainers(List<Map<String, String>> products) {
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        shrinkWrap: true, // To prevent infinite height error
        physics:
            NeverScrollableScrollPhysics(), // To prevent scrolling inside the GridView
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.75, // Adjust this to control the height
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          var product = products[index];
          return Material(
              elevation: 10,
              shadowColor: Colors.black,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 0.1)),
                height: double.parse(product['height'] ?? '200'),
                child: _buildProductItem(
                  product['name']!,
                  product['price']!,
                  product['imageUrl']!,
                ),
              ));
        },
      ),
    );
  }

  Widget _buildProductItem(String name, String price, String imageUrl) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          imageUrl,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 10),
        Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
