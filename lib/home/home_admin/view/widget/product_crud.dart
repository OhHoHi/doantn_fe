import 'package:doan_tn/home/model/product_reponse.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../base/controler/base_provider.dart';
import '../../../../base/widget/SkeletonTab.dart';
import '../../../../values/apppalette.dart';
import '../../../controller/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class ProductCrudPage extends StatefulWidget {
  const ProductCrudPage({super.key, this.product});

  final ProductResponse? product;

  @override
  State<ProductCrudPage> createState() => _ProductCrudPageState();
}

class _ProductCrudPageState extends State<ProductCrudPage> {

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _brandsNameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _chatLieuKhungVotController = TextEditingController();
  final TextEditingController _chatLieuThanVotController = TextEditingController();
  final TextEditingController _trongLuongController = TextEditingController();
  final TextEditingController _doCungController = TextEditingController();
  final TextEditingController _diemCanBangController = TextEditingController();
  final TextEditingController _chieuDaiVotController = TextEditingController();
  final TextEditingController _mucCangToiDaController = TextEditingController();
  final TextEditingController _chuViCanCamController = TextEditingController();
  final TextEditingController _trinhDoChoiController = TextEditingController();
  final TextEditingController _noiDungChoiController = TextEditingController();

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
    final productProvider =
    Provider.of<ProductProvider>(context, listen: false);
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
  Widget buildData (ProductProvider productProvider){
    return SkeletonTab(
      title:
      widget.product != null ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới',
      bodyWidgets: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 1,
                  controller: _nameController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Tên sản phẩm',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 5,
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Giới thiệu sản phẩm',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              // Padding(
              //   padding:
              //   const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //   child: GestureDetector(
              //     onTap: () {
              //       _getImages;
              //     },
              //     child: widget.product != null
              //         ? Container(
              //       width: double.infinity,
              //       height: 200,
              //       decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(25),
              //        ),
              //     )
              //         : DottedBorder(
              //       borderType: BorderType.RRect,
              //       radius: const Radius.circular(25),
              //       dashPattern: const [10, 4],
              //       strokeCap: StrokeCap.round,
              //       color: Colors.grey,
              //       child: Container(
              //         width: double.infinity,
              //         height: 200,
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(25),
              //         ),
              //         child: const Center(
              //           child: Icon(
              //             Icons.camera_alt_outlined,
              //             size: 50,
              //             color: AppPalette.thinTextColor,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
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
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 1,
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Giá tiền',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 1,
                  controller: _brandsNameController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Hãng sản xuất',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 1,
                  controller: _statusController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Trạng thái',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 1,
                  controller: _colorController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Màu vợt',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 1,
                  controller: _chatLieuKhungVotController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Chất liệu khung vợt',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 1,
                  controller: _chatLieuThanVotController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Chất liệu thân vợt',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 1,
                  controller: _trongLuongController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Trọng lượng vợt',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 1,
                  controller: _doCungController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Độ cứng',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 1,
                  controller: _diemCanBangController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Điểm cân bằng',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 1,
                  controller: _chieuDaiVotController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Chiều dài vợt',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 1,
                  controller: _mucCangToiDaController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Mức căng tối đa',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 1,
                  controller: _chuViCanCamController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Chu vi cán cầm',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 1,
                  controller: _trinhDoChoiController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Trình độ chơi',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextField(
                  maxLines: 1,
                  controller: _noiDungChoiController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                      labelStyle: TextStyle(color: AppPalette.textColor),
                      hintText: 'Nội dung chơi',
                      hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // _addProduct(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.green3Color,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  minimumSize: const Size(200, 50),
                ),
                child: widget.product != null
                    ? const Text(
                  'Chỉnh sửa',
                  style: TextStyle(fontSize: 16),
                )
                    : const Text(
                  'Tạo mới',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      isBack: true,
    );
  }
}
