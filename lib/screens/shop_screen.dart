import 'package:flutter/material.dart';
import 'points.dart';

void main() {
  runApp(FamilyApp());
}

class FamilyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShopScreen(),
    );
  }
}

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<Product> _products = [
    Product(
      name: 'Voi Pass',
      price: 400,
      description: '(Sponsored by Voi Technology)',
      isPurchased: false,
    ),
    Product(
      name: 'Max',
      price: 360,
      description: '€5 gift card at Max (Sponsored by Max Burgers)',
      isPurchased: false,
    ),
    Product(
      name: 'Nike',
      price: 300,
      description: '7% discount code at Nike (Sponsored by Nike Inc)',
      isPurchased: false,
    ),
  ];

  int _totalPoints = Points.totalPoints;
  bool _isParentLoggedIn = false;

  void _buyProduct(Product product) {
    if (_totalPoints >= product.price) {
      setState(() {
        _totalPoints -= product.price;
        product.isPurchased = true;
        Points.updatePoints(_totalPoints);
      });
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Purchase Successful'),
          content: Text('You bought ${product.name} for ${product.price} pts'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Insufficient Points'),
          content: Text('You do not have enough points to buy this product'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _loginAsParent(String password) {
    if (password == 'Test123') {
      setState(() {
        _isParentLoggedIn = true;
      });
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Logged in as Parent'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Invalid Password'),
          content: Text('Please enter the correct password.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _logoutAsParent() {
    setState(() {
      _isParentLoggedIn = false;
    });
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Logged out'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addProduct(Product newProduct) {
    setState(() {
      _products.add(newProduct);
    });
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Product Added'),
        content: Text('The product has been added successfully.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _totalPoints = Points.totalPoints;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          if (!_isParentLoggedIn)
            IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => ParentLoginDialog(
                    onLogin: _loginAsParent,
                  ),
                );
              },
            ),
          if (_isParentLoggedIn)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logoutAsParent,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total Points: $_totalPoints'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (ctx, index) {
                final product = _products[index];
                return ListTile(
                  onTap:
                      product.isPurchased ? null : () => _buyProduct(product),
                  title: Text(
                    product.name,
                    style: TextStyle(
                      color: product.isPurchased ? Colors.green : null,
                    ),
                  ),
                  subtitle: Text(product.description),
                  trailing: Text('${product.price} pts'),
                );
              },
            ),
          ),
          if (_isParentLoggedIn)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AddProductDialog(
                      onAddProduct: _addProduct,
                    ),
                  );
                },
                child: Text('Add Product'),
              ),
            ),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final int price;
  final String description;
  bool isPurchased;

  Product({
    required this.name,
    required this.price,
    required this.description,
    this.isPurchased = false,
  });
}

class ParentLoginDialog extends StatefulWidget {
  final Function(String password) onLogin;

  ParentLoginDialog({required this.onLogin});

  @override
  _ParentLoginDialogState createState() => _ParentLoginDialogState();
}

class _ParentLoginDialogState extends State<ParentLoginDialog> {
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Parent Login'),
      content: TextField(
        controller: _passwordController,
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final password = _passwordController.text;
            widget.onLogin(password);
          },
          child: Text('Login'),
        ),
      ],
    );
  }
}

class AddProductDialog extends StatefulWidget {
  final Function(Product newProduct) onAddProduct;

  AddProductDialog({required this.onAddProduct});

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Product'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text;
            final description = _descriptionController.text;
            final price = int.tryParse(_priceController.text) ?? 0;

            if (name.isNotEmpty && description.isNotEmpty && price > 0) {
              final newProduct = Product(
                name: name,
                description: description,
                price: price,
              );

              widget.onAddProduct(newProduct);
              Navigator.of(context).pop();
            } else {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Invalid Input'),
                  content: Text('Please enter valid values for all fields'),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}