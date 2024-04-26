import 'package:image_picker/image_picker.dart';
import 'package:doan_tn/home/controller/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../base/controler/base_provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'dart:io';

class BodyAddProduct extends StatefulWidget {
  const BodyAddProduct({Key? key}) : super(key: key);

  @override
  State<BodyAddProduct> createState() => _BodyHomeViewState();
}

class _BodyHomeViewState extends State<BodyAddProduct> {
  late ProductProvider productProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider.getListProduct();
    });
  }
   TextEditingController _nameController = TextEditingController();
   TextEditingController _descriptionController = TextEditingController();
   TextEditingController _priceController = TextEditingController();
   TextEditingController _brandsNameController = TextEditingController();
   TextEditingController _statusController = TextEditingController();
   TextEditingController _colorController = TextEditingController();
   TextEditingController _chatLieuKhungVotController = TextEditingController();
   TextEditingController _chatLieuThanVotController = TextEditingController();
   TextEditingController _trongLuongController = TextEditingController();
   TextEditingController _doCungController = TextEditingController();
   TextEditingController _diemCanBangController = TextEditingController();
   TextEditingController _chieuDaiVotController = TextEditingController();
   TextEditingController _mucCangToiDaController = TextEditingController();
   TextEditingController _chuViCanCamController = TextEditingController();
   TextEditingController _trinhDoChoiController = TextEditingController();
   TextEditingController _noiDungChoiController = TextEditingController();

  List<File> _images = [];
  final picker = ImagePicker();

  Future<void> _getImages() async {
    List<XFile>? pickedFiles = await picker.pickMultiImage(
      imageQuality: 70,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedFiles != null) {
      setState(() {
        _images.addAll(pickedFiles.map((XFile image) => File(image.path)));
      });
    }
    // if (pickedFiles != null) {
    //   setState(() {
    //     _images.addAll(pickedFiles.map((XFile image) {
    //       String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    //       String fileName = path.basename(image.path);
    //       return File(image.path)..renameSync('${timestamp}_$fileName');
    //     }));
    //   });
    // }
  }

  Future<void> _addProduct(BuildContext context) async {
    if (_images == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image.')),
      );
      return;
    }

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    try {
      await productProvider.addProduct(
        _nameController.text,
        _descriptionController.text,
        _images,
        int.tryParse(_priceController.text) ?? 0,
        _brandsNameController.text,
        _statusController.text,
        _colorController.text,
        _chatLieuKhungVotController.text,
        _chatLieuThanVotController.text,
        _trongLuongController.text,
        _doCungController.text,
        _diemCanBangController.text,
        _chieuDaiVotController.text,
        _mucCangToiDaController.text,
        _chuViCanCamController.text,
        _trinhDoChoiController.text,
        _noiDungChoiController.text,
        // 0,
        // '',
        // '','','','','','','','','','','',''
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ProductProvider, Status>(builder: (context, value, child) {
      if (value == Status.loading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ProgressHUD.of(context)?.show();
        });
        print('Bat dau load');
      } else if (value == Status.loaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          ProgressHUD.of(context)?.dismiss();
          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //     builder: (_) => const LoginScreen(
          //     )));
        });
        print("load thanh cong");
      } else if (value == Status.error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ProgressHUD.of(context)?.dismiss();
          print('Load error r');
        });
      }
      return buildData(productProvider);
    }, selector: (context, pro) {
      return pro.statusAddProduct;
    });
  }

  Widget buildData(ProductProvider productProvider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Product Description'),
          ),
          SizedBox(height: 16.0),
          // _image == null
          //     ? Text('No image selected.')
          //     : Image.file(_image!),
          _images.isEmpty
              ? Text('No image selected.')
              : Row(
                  children: _images
                      .map((image) => SizedBox(
                          width: 100, height: 100, child: Image.file(image)))
                      .toList(),
                ),
          ElevatedButton(
            onPressed: _getImages,
            child: Text('Select Image'),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(labelText: 'Price '),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _brandsNameController,
            decoration: InputDecoration(labelText: 'Brand Name'),
          ),
          TextField(
            controller: _statusController,
            decoration: InputDecoration(labelText: 'Status Name'),
          ),
          TextField(
            controller: _colorController,
            decoration: InputDecoration(labelText: 'Color Name'),
          ),
          TextField(
            controller: _chatLieuKhungVotController,
            decoration: InputDecoration(labelText: 'Chất liệu khung vợt'),
          ),
          TextField(
            controller: _chatLieuThanVotController,
            decoration: InputDecoration(labelText: 'Chất liệu thân vợt'),
          ),
          TextField(
            controller: _trongLuongController,
            decoration: InputDecoration(labelText: 'Trọng lượng'),
          ),
          TextField(
            controller: _doCungController,
            decoration: InputDecoration(labelText: 'Độ cứng'),
          ),
          TextField(
            controller: _diemCanBangController,
            decoration: InputDecoration(labelText: 'Điểm cân bằng'),
          ),
          TextField(
            controller: _chieuDaiVotController,
            decoration: InputDecoration(labelText: 'Chiều dài vợt'),
          ),
          TextField(
            controller: _mucCangToiDaController,
            decoration: InputDecoration(labelText: 'Mức căng tối đa'),
          ),
          TextField(
            controller: _chuViCanCamController,
            decoration: InputDecoration(labelText: 'Chu vi cán cầm'),
          ),
          TextField(
            controller: _trinhDoChoiController,
            decoration: InputDecoration(labelText: 'Trình độ chơi'),
          ),
          TextField(
            controller: _noiDungChoiController,
            decoration: InputDecoration(labelText: 'Nội dung chơi'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => _addProduct(context),
            child: Text('Add Product'),
          ),
        ],
      ),
    );
  }
}
