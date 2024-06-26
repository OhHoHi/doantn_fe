import 'package:doan_tn/home/home_user/view/user_page.dart';
import 'package:flutter/material.dart';

import '../../../../../values/colors.dart';
import '../../../../controller/brand_controller.dart';
import '../../../../controller/product_provider.dart';
import 'bottom_shet_widget.dart';

class SearchBarWidget extends StatefulWidget {
  SearchBarWidget(
      {required this.hintText,
      super.key,
      required this.productProvider,
      required this.brandProvider});

  final String hintText;
  final ProductProvider productProvider;
  final BrandProvider brandProvider;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xffffcb4e),
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
      child: Container(
        margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
        height: 45,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(37)),
            border: Border.all(color: Colors.black12, width: 1),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const Expanded(
              flex: 1,
              child: Icon(Icons.search),
            ),
            Expanded(
              flex: 6,
              child: TextFormField(
                onFieldSubmitted: (value) {
                  widget.productProvider.resetPageSearch();
                  widget.productProvider.refreshAllSearch();
                  widget.productProvider.search(value);
                  if (value == "") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserPage(selectedIndex: 1),
                        ));
                  }
                },
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return BottomSheetWidget(
                      productProvider: widget.productProvider,
                      listBrand: widget.brandProvider.listBrand,
                    );
                  },
                );
              },
              icon: const Icon(Icons.filter_alt),
            )),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    );
  }
}
