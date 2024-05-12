import 'package:doan_tn/home/controller/brand_controller.dart';
import 'package:doan_tn/home/controller/product_provider.dart';
import 'package:doan_tn/home/model/brand_response.dart';
import 'package:flutter/material.dart';

import '../../../../../values/colors.dart';
import '../../../../../values/styles.dart';


class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({super.key,
    required this.productProvider, required this.listBrand});

  final ProductProvider productProvider;
  final List<BrandResponse> listBrand;


  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  RangeValues _currentRangeValues = const RangeValues(0, 5000000);

  late BrandResponse? brandValue = widget.listBrand.first;
  String? loaivotValue = 'Tất cả';
  @override
  void initState() {
    super.initState();
    // Đặt giá trị mặc định là null hoặc bất kỳ giá trị nào khác
    brandValue = null;

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
          borderRadius:  BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          color: Colors.white),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              const SizedBox(width: 50),
              Expanded(
                child: Text(
                  'Bộ lọc',
                  style: AppStyles.nuntio_18,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 20),
                alignment: Alignment.centerRight,
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
            height: 1,
            thickness: 0,
          ),
          Row(
            children: [
              const SizedBox(width: 30),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thương hiệu',
                        style: AppStyles.h4.copyWith(
                          color: ColorApp.subTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      DropdownButton<BrandResponse>(
                        value:  widget.productProvider.selectedBrand, // Giá trị được chọn ban đầu
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        elevation: 16,
                        style: AppStyles.nuntio_14_black,
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              widget.productProvider.selectedBrand = value;
                              // widget.productProvider.brandId = value.id;
                            } else {
                              // Người dùng chọn "Tất cả thương hiệu"
                              widget.productProvider.selectedBrand = null;
                            }
                            // brandValue = value!;
                            // widget.productProvider.brandId = value.id;
                            // print( "lấy được giá trị không ${widget.productProvider.brandId}");
                          });
                        },
                        items: <DropdownMenuItem<BrandResponse>> [
                          // Thêm mục "Tất cả thương hiệu" vào đầu danh sách
                          const DropdownMenuItem<BrandResponse>(
                            value: null, // Hoặc giá trị phù hợp với bạn
                            child: Text('Tất cả thương hiệu'),
                          ),
                          ...widget.listBrand // Danh sách các mục
                            .map<DropdownMenuItem<BrandResponse>>((BrandResponse value) {
                          return DropdownMenuItem<BrandResponse>(
                            value: value, // Giá trị của mục
                            child: Text(value.name), // Hiển thị nội dung của mục
                          );
                        }).toList(),
                        ],
                      ),
                      // DropDownThuongHieuWidget(
                      //     listDropDown: widget.provider.listStatusJob,
                      //     assignedWorkProvider: widget.provider),
                      const SizedBox(height: 10),
                      Text(
                        'Loại vợt ( nối chơi )',
                        style: AppStyles.h4.copyWith(
                          color: ColorApp.subTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      DropdownButton<String>(
                        value: widget.productProvider.selectedLoaivot, // Giá trị được chọn ban đầu
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        elevation: 16,
                        style: AppStyles.nuntio_14_black,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            widget.productProvider.selectedLoaivot = newValue;
                          });
                        },
                        items: <String>["Tất cả", 'Nhẹ đầu', 'Cân bằng', 'Nặng đầu'] // Danh sách các mục
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value, // Giá trị của mục
                            child: Text(value), // Hiển thị nội dung của mục
                          );
                        }).toList(),
                      ),
                      // DropDownCoQuanWidget(
                      //   listDropDown: widget.provider.listStatusType,
                      //   assignedWorkProvider: widget.provider,),
                      const SizedBox(height: 10),
                      Text(
                        'Gía tiền',
                        style: AppStyles.h4.copyWith(
                          color: ColorApp.subTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      RangeSlider(
                        values: RangeValues(widget.productProvider.minPrice ?? 0, widget.productProvider.maxPrice ?? 5000000),
                        min: 0,
                        max: 5000000,
                        divisions: 10, // Tạo các bước giữa min và max
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentRangeValues = values;
                            widget.productProvider.minPrice = values.start;
                            widget.productProvider.maxPrice = values.end;

                          });
                        },
                        labels: RangeLabels(
                          widget.productProvider.minPrice.toString(),
                          widget.productProvider.maxPrice.toString(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                ElevatedButton(
                onPressed: (){
                  setState(() {
                    widget.productProvider.refreshAllSearch();
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(160, 40),
                  backgroundColor:Colors.white ,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(
                    color: ColorApp.buttonColor,
                    width: 1.5,
                  ),
                ),
                child: Text("Thiết lập lại",
                    style: AppStyles.h4.copyWith(
                      color: Colors.yellow,
                      fontWeight: FontWeight.w700,
                    )), // <-- Text
              ),
                  ElevatedButton(
                    onPressed: (){
                      widget.productProvider.resetPageSearch();
                      widget.productProvider.getListSearch();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(160, 40),
                      backgroundColor:ColorApp.buttonColor ,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(
                        color: ColorApp.buttonColor,
                        width: 1.5,
                      ),
                    ),
                    child: Text("Áp dụng",
                        style: AppStyles.h4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        )), // <-- Text
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

