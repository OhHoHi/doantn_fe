import 'package:doan_tn/home/controller/brand_controller.dart';
import 'package:doan_tn/home/home_admin/view/admin_page.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import 'package:image_picker/image_picker.dart';
import 'package:doan_tn/home/controller/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../base/controler/base_provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import '../../../../base/controler/consumer_base.dart';
import '../../../../base/widget/dialog_base.dart';
import '../../../../values/apppalette.dart';
import '../../../../values/assets.dart';

class BodyAddProduct extends StatefulWidget {
  BodyAddProduct({Key? key, this.productResponse}) : super(key: key);
  ProductResponse? productResponse;

  @override
  State<BodyAddProduct> createState() => _BodyHomeViewState();
}

class _BodyHomeViewState extends State<BodyAddProduct> {
  late ProductProvider productProvider;

  late BrandProvider brandProvider;

  //FocusNode _nameFocusNode = FocusNode();
 String? _selectedStatus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  _nameFocusNode.requestFocus();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    brandProvider = Provider.of<BrandProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      brandProvider.getListBrand();
    });
    if (widget.productResponse != null) {
      _nameController.text = widget.productResponse!.name;
      _descriptionController.text = widget.productResponse!.description;
      _priceController.text = widget.productResponse!.price.toString();
      if (widget.productResponse!.brands != null) {
        _brandsNameController.text = widget.productResponse!.brands!.name;
      }


      _selectedStatus = widget.productResponse!.status;

      _colorController.text = widget.productResponse!.color;

      _chatLieuKhungVotController.text =
          widget.productResponse!.chatLieuKhungVot;

      _chatLieuThanVotController.text = widget.productResponse!.chatLieuThanVot;

      _trongLuongController.text = widget.productResponse!.trongLuong;

      _doCungController.text = widget.productResponse!.doCung;

      _diemCanBangController.text = widget.productResponse!.diemCanBang.toString();

      _chieuDaiVotController.text = widget.productResponse!.chieuDaiVot;

      _mucCangToiDaController.text = widget.productResponse!.mucCangToiDa;

      _chuViCanCamController.text = widget.productResponse!.chuViCanCam;

      _trinhDoChoiController.text = widget.productResponse!.trinhDoChoi;
      _noiDungChoiController.text = widget.productResponse!.noiDungChoi;
    }
  }

  @override
  void dispose() {
    _brandsNameController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _statusController.dispose();
    _colorController.dispose();
    _chatLieuKhungVotController.dispose();
    _chatLieuThanVotController.dispose();
    _trongLuongController.dispose();
    _doCungController.dispose();
    _diemCanBangController.dispose();
    _chieuDaiVotController.dispose();
    _mucCangToiDaController.dispose();
    _chuViCanCamController.dispose();
    _trinhDoChoiController.dispose();
    _noiDungChoiController.dispose();
    super.dispose();
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

  bool _isNameEmpty = false;
  bool _isDescriptionEmpty = false;
  bool _isPriceEmpty = false;
  bool _isBrandsNameEmpty = false;
  bool _isStatusEmpty = false;
  bool _isColorEmpty = false;
  bool _isChatLieuKhungVotEmpty = false;
  bool _isChatLieuThanVotEmpty = false;
  bool _isTrongLuongEmpty = false;
  bool _isDoCungEmpty = false;
  bool _isDiemCanBangEmpty = false;
  bool _isChieuDaiVotEmpty = false;
  bool _isMucCangToiDaEmpty = false;
  bool _isChuViCanCamEmpty = false;
  bool _isTrinhDoChoiEmpty = false;
  bool _isNoiDungChoiEmpty = false;
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

  Future<void> _addProduct() async {
    if (_images == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image.')),
      );
      return;
    }
    setState(() {
      _isNameEmpty = _nameController.text.isEmpty;
      _isDescriptionEmpty = _descriptionController.text.isEmpty;
      _isPriceEmpty = _priceController.text.isEmpty;
      _isBrandsNameEmpty = _brandsNameController.text.isEmpty;
      _isStatusEmpty = _selectedStatus!.isEmpty;
      _isColorEmpty = _colorController.text.isEmpty;
      _isChatLieuKhungVotEmpty = _chatLieuKhungVotController.text.isEmpty;
      _isChatLieuThanVotEmpty = _chatLieuThanVotController.text.isEmpty;
      _isTrongLuongEmpty = _trongLuongController.text.isEmpty;
      _isDoCungEmpty = _doCungController.text.isEmpty;
      _isDiemCanBangEmpty = _diemCanBangController.text.isEmpty;
      _isChieuDaiVotEmpty = _chieuDaiVotController.text.isEmpty;
      _isMucCangToiDaEmpty = _mucCangToiDaController.text.isEmpty;
      _isChuViCanCamEmpty = _chuViCanCamController.text.isEmpty;
      _isTrinhDoChoiEmpty = _trinhDoChoiController.text.isEmpty;
      _isNoiDungChoiEmpty = _noiDungChoiController.text.isEmpty;
    });

    if (_isNameEmpty || _isDescriptionEmpty || _isPriceEmpty || _isBrandsNameEmpty || _isStatusEmpty || _isColorEmpty || _isChatLieuKhungVotEmpty || _isChatLieuThanVotEmpty || _isTrongLuongEmpty || _isDoCungEmpty || _isDiemCanBangEmpty || _isChieuDaiVotEmpty || _isMucCangToiDaEmpty || _isChuViCanCamEmpty || _isTrinhDoChoiEmpty || _isNoiDungChoiEmpty || _images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }
    try {
      await productProvider.addProduct(
        _nameController.text,
        _descriptionController.text,
        _images,
        int.tryParse(_priceController.text) ?? 0,
        _brandsNameController.text,
        _selectedStatus ?? "",
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
      if (productProvider.checkAdd == true) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Product added successfully')),
        // );
        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thành công',
                content: 'Đã thêm sản phẩm thành công',
                icon: AppAssets.icoSuccess,
                button: true,
                function:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminPage(selectedIndex: 0),
                    ),
                  );
                } ,
              );
            });
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to add product')),
        // );
        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thất bại',
                content: 'Thêm sản phẩm thất bại',
                icon: AppAssets.icoFail,
                button: false,

              );
            });
      }
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product')),
      );
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return DialogBase(
      //         title: 'Thông báo',
      //         content: 'Thêm sản phẩm thất bại',
      //         icon: AppAssets.icoDefault,
      //         button: true,
      //       );
      //     });
    }
  }

  Future<void> _editProduct(int id) async {
    setState(() {
      _isNameEmpty = _nameController.text.isEmpty;
      _isDescriptionEmpty = _descriptionController.text.isEmpty;
      _isPriceEmpty = _priceController.text.isEmpty;
      _isBrandsNameEmpty = _brandsNameController.text.isEmpty;
      _isStatusEmpty = _selectedStatus!.isEmpty;
      _isColorEmpty = _colorController.text.isEmpty;
      _isChatLieuKhungVotEmpty = _chatLieuKhungVotController.text.isEmpty;
      _isChatLieuThanVotEmpty = _chatLieuThanVotController.text.isEmpty;
      _isTrongLuongEmpty = _trongLuongController.text.isEmpty;
      _isDoCungEmpty = _doCungController.text.isEmpty;
      _isDiemCanBangEmpty = _diemCanBangController.text.isEmpty;
      _isChieuDaiVotEmpty = _chieuDaiVotController.text.isEmpty;
      _isMucCangToiDaEmpty = _mucCangToiDaController.text.isEmpty;
      _isChuViCanCamEmpty = _chuViCanCamController.text.isEmpty;
      _isTrinhDoChoiEmpty = _trinhDoChoiController.text.isEmpty;
      _isNoiDungChoiEmpty = _noiDungChoiController.text.isEmpty;
    });

    if (_isNameEmpty || _isDescriptionEmpty || _isPriceEmpty || _isBrandsNameEmpty || _isStatusEmpty || _isColorEmpty || _isChatLieuKhungVotEmpty || _isChatLieuThanVotEmpty || _isTrongLuongEmpty || _isDoCungEmpty || _isDiemCanBangEmpty || _isChieuDaiVotEmpty || _isMucCangToiDaEmpty || _isChuViCanCamEmpty || _isTrinhDoChoiEmpty || _isNoiDungChoiEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }
    try {
      await productProvider.editProduct(
          _nameController.text,
          _descriptionController.text,
          int.tryParse(_priceController.text) ?? 0,
          _brandsNameController.text,
          _selectedStatus ?? "",
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
          id
          // 0,
          // '',
          // '','','','','','','','','','','',''
          );
      if (productProvider.checkEdit == true) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Product added successfully')),
        // );

        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thành công',
                content: 'Đã SỬA sản phẩm thành công',
                icon: AppAssets.icoSuccess,
                button: true,
                function:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminPage(selectedIndex: 0),
                    ),
                  );
                } ,
              );
            });
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to add product')),
        // );
        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thất bại',
                content: 'SỬA sản phẩm thất bại',
                icon: AppAssets.icoFail,
                button: true,
              );
            });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product')),
      );
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return DialogBase(
      //         title: 'Thông báo',
      //         content: 'Thêm sản phẩm thất bại',
      //         icon: AppAssets.icoDefault,
      //         button: true,
      //       );
      //     });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.productResponse != null
        ? Selector<ProductProvider, Status>(builder: (context, value, child) {
            if (value == Status.loading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ProgressHUD.of(context)?.show();
              });
              print('Bat dau load');
            } else if (value == Status.loaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                ProgressHUD.of(context)?.dismiss();
              });
              print("load thanh cong");
              print("load thanh cong edit ${productProvider.checkEdit}");
            } else if (value == Status.error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ProgressHUD.of(context)?.dismiss();
                print('Load error r');
                print('Load error edit ${productProvider.checkEdit}');
              });
            }
            return buildData();
          }, selector: (context, pro) {
            return pro.statusEditProduct;
          })
        : Selector<ProductProvider, Status>(builder: (context, value, child) {
            if (value == Status.loading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ProgressHUD.of(context)?.show();
              });
              print('Bat dau load');
            } else if (value == Status.loaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                ProgressHUD.of(context)?.dismiss();
              });
              print("load thanh cong");
              print("load thanh cong add ${productProvider.checkAdd}");
            } else if (value == Status.error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ProgressHUD.of(context)?.dismiss();
                print('Load error r ');
                print('Load error r add${productProvider.checkAdd}');
              });
            }
            return buildData();
          }, selector: (context, pro) {
            return pro.statusAddProduct;
          });
  }

  Widget buildData() {
    return SingleChildScrollView(
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
            widget.productResponse == null
                ? _images.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 50,
                              color: AppPalette.thinTextColor,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              final reversedIndex = _images.length - 1 - index; // Lấy chỉ số ngược lại
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(_images[reversedIndex],
                                    width: 100, height: 100),
                              );
                            },
                          ),
                        ),
                      )
                : const SizedBox(),
            widget.productResponse == null
                ? ElevatedButton(
                    onPressed: _getImages,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.green3Color,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      minimumSize: const Size(200, 50),
                    ),
                    child: const Text('Select Image'),
                  )
                : const SizedBox(),
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
            Selector<BrandProvider, Status>(
              builder: (context, value, child) {
                if (value == Status.loading) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ProgressHUD.of(context)?.show();
                  });
                  print('Bắt đầu load');
                } else if (value == Status.loaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    ProgressHUD.of(context)?.dismiss();
                  });
                  print("Load thành công");
                } else if (value == Status.error) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ProgressHUD.of(context)?.dismiss();
                    print('Load error');
                  });
                }
                return Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  color: Colors.white,
                  margin: const EdgeInsets.all(10),
                  child: Autocomplete<String>(
                      initialValue: TextEditingValue(text: _brandsNameController.text),
                      optionsBuilder: (TextEditingValue textEditingValue){
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      return brandProvider.listBrand.map((brand) => brand.name).where((String option) {
                        return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selection) {
                      _brandsNameController.text = selection;
                    },
                    fieldViewBuilder:(BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted){
                      fieldTextEditingController.text = _brandsNameController.text;
                      //_brandsNameController.text = fieldTextEditingController.text;
                      return TextField(
                        maxLines: 1,
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15),
                            labelStyle: TextStyle(color: AppPalette.textColor),
                            hintText: 'Hãng sản xuất',
                            hintStyle: TextStyle(color: AppPalette.thinTextColor)),
                      );
                    }
                  ),
                );
              },
              selector: (context, pro) {
                return pro.statusListBrand;
              },
            ),
            // Card(
            //   shape: const RoundedRectangleBorder(
            //     borderRadius: BorderRadius.all(Radius.circular(25)),
            //   ),
            //   color: Colors.white,
            //   margin: const EdgeInsets.all(10),
            //     child: TextField(
            //       maxLines: 1,
            //       controller: _brandsNameController,
            //       decoration: const InputDecoration(
            //           border: InputBorder.none,
            //           contentPadding: EdgeInsets.all(15),
            //           labelStyle: TextStyle(color: AppPalette.textColor),
            //           hintText: 'Hãng sản xuất',
            //           hintStyle: TextStyle(color: AppPalette.thinTextColor)),
            //     ),
            // ),
            // Card(
            //   shape: const RoundedRectangleBorder(
            //     borderRadius: BorderRadius.all(Radius.circular(25)),
            //   ),
            //   color: Colors.white,
            //   margin: const EdgeInsets.all(10),
            //   child: TextField(
            //     maxLines: 1,
            //     controller: _statusController,
            //     decoration: const InputDecoration(
            //         border: InputBorder.none,
            //         contentPadding: EdgeInsets.all(15),
            //         labelStyle: TextStyle(color: AppPalette.textColor),
            //         hintText: 'Trạng thái',
            //         hintStyle: TextStyle(color: AppPalette.thinTextColor)),
            //   ),
            // ),
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              child: DropdownButtonFormField<String>(
                value: _selectedStatus,
                onChanged: (newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
                items: <String>['Còn hàng', 'Hết hàng'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value , style: const TextStyle(color: Colors.red)),
                  );
                }).toList(),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Trạng thái',
                    hintStyle: TextStyle(color: AppPalette.thinTextColor)
                ),
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
                keyboardType: TextInputType.number,
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
                if(widget.productResponse != null){
                  _editProduct(
                      widget.productResponse!.id);
                } else {
                  _addProduct();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.green3Color,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                minimumSize: const Size(200, 50),
              ),
              child: widget.productResponse != null
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
    );

  }
}
