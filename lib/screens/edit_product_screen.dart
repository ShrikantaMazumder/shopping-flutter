import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_flutter/providers/product.dart';
import 'package:shopping_flutter/providers/products_provider.dart';
import 'package:shopping_flutter/widgets/app_drawer.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/product-detail";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: null,
    title: "",
    description: "",
    price: 0,
    imageUrl: "",
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_imageUrlListener);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_imageUrlListener);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  _imageUrlListener() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  _submitForm() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    Provider.of<ProductsProvider>(context, listen: false)
        .addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _submitForm,
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Title",
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter title";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                    id: null,
                    title: newValue,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Price",
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter price";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  if (double.parse(value) <= 0) {
                    return "Please enter greater than 0";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                    id: null,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(newValue),
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Description",
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter description";
                  }
                  if (value.length < 10) {
                    return "Should be at least 10 characters";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _editedProduct = Product(
                    id: null,
                    title: _editedProduct.title,
                    description: newValue,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Container(
                        child: _imageUrlController.text.isNotEmpty
                            ? FittedBox(
                                child: Image.network(_imageUrlController.text),
                                fit: BoxFit.cover,
                              )
                            : Text("Enter Image URL")),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "Image Url"),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (value) => _submitForm(),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter image url";
                        }
                        if (!value.startsWith("http") &&
                            !value.startsWith("htpps")) {
                          return "Please enter a valid url";
                        }
                        // if (!value.endsWith(".jpg") &&
                        //     !value.endsWith(".jpeg") &&
                        //     !value.endsWith(".png")) {
                        //   return "Please enter a valid url";
                        // }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          id: null,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: newValue,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
