// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace, avoid_print, prefer_final_fields, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlTextController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: "",
    description: "",
    imageUrl: "",
    price: 0,
  );
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isloading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        _editedProduct = Provider.of<ProductProvider>(context, listen: false)
            .findById(productId);

        _initValues = {
          'title': _editedProduct.title!,
          'description': _editedProduct.description!,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlTextController.text = _editedProduct.imageUrl!;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlTextController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      // if (!_imageUrlFocusNode.toString().startsWith('http') &&
      //     !_imageUrlFocusNode.toString().startsWith('https')) {
      //   return;
      // }
      setState(() {});
    }
  }

  // It was match with 1st way to addProduct and Error handling

  // void _saveFormProduct() {
  //   final _isValid = _formKey.currentState!.validate();
  //
  //   if (!_isValid) {
  //     return;
  //   }
  //   _formKey.currentState!.save();
  //   setState(() {
  //     _isloading = true;
  //   });
  //
  //   if (_editedProduct.id != null) {
  //     Provider.of<ProductProvider>(context, listen: false)
  //         .updateProduct(_editedProduct.id!, _editedProduct);
  //     setState(() {
  //       _isloading = false;
  //     });
  //     Navigator.pop(context);
  //   } else {
  //     Provider.of<ProductProvider>(context, listen: false)
  //         .addProduct(_editedProduct)
  //         .catchError((error) {
  //       return showDialog(
  //           context: context,
  //           builder: (ctx) => AlertDialog(
  //                 title: Text('An Error Occurred !!'),
  //                 content: Text('Something to be wrong '),
  //                 actions: [
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.pop(ctx);
  //                     },
  //                     child: Text('Okay'),
  //                   ),
  //                 ],
  //               ));
  //     }).then((_) {
  //       setState(() {
  //         _isloading = false;
  //       });
  //       Navigator.pop(context);
  //     });
  //   }
  // }

  // It was match with 2nd way to addProduct and Error handling

  Future<void> _saveFormProduct() async {
    final _isValid = _formKey.currentState!.validate();

    if (!_isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isloading = true;
    });

    if (_editedProduct.id != null) {
      await Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(_editedProduct.id!, _editedProduct);
    } else {
      try {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An Error Occurred !!'),
            content: Text('Something to be wrong '),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text('Okay'),
              ),
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isloading = false;
      //   });
      //   Navigator.pop(context);
      // }
    }
    setState(() {
      _isloading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Your Product'),
          actions: [
            IconButton(
              onPressed: _saveFormProduct,
              icon: Icon(Icons.save),
            ),
          ],
        ),
        body: _isloading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context).requestFocus(_priceFocusNode);
                        // },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please provide a value';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: value!,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        // focusNode: _priceFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than Zero';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value!),
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a description.';
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: value!,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 10, right: 6),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlTextController.text.isEmpty
                                ? FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text('Enter Image Url'),
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlTextController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'ImageUrl'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlTextController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveFormProduct();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please provide a image url';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid url';
                                }
                                // if (!value.endsWith('.png') &&
                                //     !value.endsWith('.jpg') &&
                                //     !value.endsWith('.jpeg')) {
                                //   return 'Please enter a valid image url';
                                // }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  imageUrl: value!,
                                  price: _editedProduct.price,
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
      ),
    );
  }
}
