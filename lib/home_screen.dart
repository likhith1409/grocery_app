import 'package:flutter/material.dart';
import 'sign_in_screen.dart';


class HomeScreen extends StatefulWidget {
  final String message;

  HomeScreen({required this.message});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeSectionScreen(),
    SearchSectionScreen(),
    ShopSectionScreen(),
    CartSectionScreen(),
    ProfileSectionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/Grocery1.png',
            height: 30, 
          ),
        ),
        automaticallyImplyLeading: false, 
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _currentIndex == 2 ? Colors.red : Color(0xFF0E8059),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Icon(Icons.storefront, color: Colors.white),
          ),
          label: 'Shop',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _currentIndex,
      selectedItemColor: Color(0xFF0E8059),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}

// product deatils 
// We can use the cloud firestore to store this products insted of giving in this
class HomeSectionScreen extends StatelessWidget {
  final List<Product> products = [
    Product(
      name: 'Fortune',
      price: 250.00,
      discount: 10,
      imageUrl: 'assets/product 1.png',
      description: 'Fortune Sunflower Oil is a premium quality oil that enhances the taste of your dishes.',
    ),
    Product(
      name: 'Surf Excel',
      price: 150.00,
      discount: 15,
      imageUrl: 'assets/product 2.png',
      description: 'Surf Excel Matic Front Load Detergent Powder is designed for superior cleaning.',
    ),
    Product(
      name: 'Maggi',
      price: 20.00,
      discount: 5,
      imageUrl: 'assets/product 3.png',
      description: 'Maggi 2-Minute Noodles are a quick and tasty snack option.',
    ),
    Product(
      name: 'Cookies',
      price: 50.00,
      discount: 20,
      imageUrl: 'assets/product 5.png',
      description: 'Delicious cookies that are perfect for any occasion.',
    ),
    Product(
      name: 'Oil and Chilli Powder',
      price: 100.00,
      discount: 10,
      imageUrl: 'assets/product 6.png',
      description: 'A combination of high-quality oil and chilli powder for your kitchen needs.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shop by Category',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                CategoryCard(imageUrl: 'assets/product 7.png', name: 'Fruits'),
                CategoryCard(imageUrl: 'assets/product 5.png', name: 'Breakfast'),
                CategoryCard(imageUrl: 'assets/product 8.png', name: 'Cold Drinks'),
                CategoryCard(imageUrl: 'assets/product 3.png', name: 'Instant Food'),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Deals of the Day',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final double price;
  final double discount;
  final String imageUrl;
  final String description;

  Product({
    required this.name,
    required this.price,
    required this.discount,
    required this.imageUrl,
    required this.description,
  });
}

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    double discountedPrice = product.price - (product.price * product.discount / 100);

    return GestureDetector(
      onTap: () {
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                  child: Image.asset(
                    product.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name in two rows if needed
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          maxLines: 2,  // Allow up to 2 lines for the name
                          overflow: TextOverflow.ellipsis,  // Add ellipsis if text is too long
                          softWrap: true,  // Wrap text if it exceeds available width
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  if (product.discount > 0)
                    Text(
                      'MRP: ₹${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  // Discounted price and cart button in a row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${discountedPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[700],
                            ),
                          ),
                          if (product.discount > 0)
                            Text(
                              '${product.discount}% OFF',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      AddToCartButton(product: product),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddToCartButton extends StatefulWidget {
  final Product product;

  AddToCartButton({required this.product});

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  bool isAddedToCart = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isAddedToCart = !isAddedToCart;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isAddedToCart ? Colors.yellow : Colors.black,
        ),
        child: Icon(
          Icons.shopping_cart,
          color: isAddedToCart ? Colors.black : Colors.white,
          size: 16.0,
        ),
      ),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    double discountedPrice = product.price - (product.price * product.discount / 100);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              product.imageUrl,
              fit: BoxFit.contain,  // Ensures the image fits without cropping or zooming
              height: 200.0,
              width: double.infinity,
            ),
            SizedBox(height: 16.0),
            Text(
              product.name,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            if (product.discount > 0)
              Text(
                'MRP: ₹${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[700],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            Text(
              '₹${discountedPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8.0),
            if (product.discount > 0)
              Text(
                '${product.discount}% OFF',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            SizedBox(height: 16.0),
            Text(
              product.description,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle Buy Now action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Buy Now',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle Add to Cart action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String name;

  CategoryCard({required this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            imageUrl,
            height: 50.0,
            width: 50.0,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8.0),
        Flexible(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 12.0, // Reduced font size
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class ResponsiveProductGrid extends StatelessWidget {
  final List<Product> products;

  ResponsiveProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(product: products[index]);
          },
        );
      },
    );
  }
}

class ResponsiveCategoryGrid extends StatelessWidget {
  final List<CategoryCard> categories;

  ResponsiveCategoryGrid({required this.categories});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 600 ? 6 : 4;
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.0,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return categories[index];
          },
        );
      },
    );
  }
}


class SearchSectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Search for products here!'),
    );
  }
}

class ShopSectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Browse our shop here!'),
    );
  }
}

class CartSectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Your cart items are here!'),
    );
  }
}

class ProfileSectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Section'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Your profile details are here!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the SignInScreen and replace the current screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}