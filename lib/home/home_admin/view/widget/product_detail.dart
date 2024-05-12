import 'dart:typed_data';
import 'package:doan_tn/auth/login/model/login_response.dart';
import 'package:photo_view/photo_view.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../auth/login/model/test_luu_user.dart';
import '../../../../base/widget/SkeletonTab.dart';
import '../../../../base/widget/dialog_base.dart';
import '../../../../values/apppalette.dart';
import '../../../../values/assets.dart';
import '../../../controller/product_provider.dart';
import '../crud_product_tab.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key, required this.product, required this.productProvider, required this.isAdmin,
  });
  final ProductResponse product;
  final ProductProvider productProvider;
  final bool isAdmin;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>with TickerProviderStateMixin {

  String formatPrice(int price) {
    final formatter = NumberFormat('#,###');
    return formatter.format(price);
  }
  bool isProductDeleted = false;
  late final TabController _tabController;
  late LoginResponse user;
  late bool isInCart = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    user = TempUserStorage.currentUser!;

  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  Future<void> _addCart(int userId , int productId , int quantity) async {
    try {
      await widget.productProvider.addCart(
          userId ,
          productId,
          quantity
      );
      if (widget.productProvider.checkAddCart == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã thêm sản phẩm vào giỏ hàng thành công')),
        );
        setState(() {
          // Cập nhật trạng thái khi thêm vào giỏ hàng thành công
          isInCart = true;
        });
      } else {
        setState(() {
          // Cập nhật trạng thái khi thêm vào giỏ hàng thành công
          isInCart = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Cart')),
        );
      }
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add Cart')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    // final productProvider = Provider.of<ProductProvider>(context);
    return
      SkeletonTab(
        isbg: true,
        title: 'Thông tin sản phẩm',
        bodyWidgets: isProductDeleted ? _buildEmptyState() : _buildProductDetail(),
        isBack: true,
        actionsWidgets: widget.isAdmin
            ? Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Xác nhận"),
                    content: const Text("Bạn có chắc chắn muốn xóa sản phẩm này không?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Đóng hộp thoại
                        },
                        child: const Text("Hủy"),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.productProvider.deleteProduct(widget.product.id);
                          Navigator.of(context).pop(); // Đóng hộp thoại
                          setState(() {
                            isProductDeleted = true; // Đánh dấu là đã xóa sản phẩm
                          });
                        },
                        child: const Text("Xác nhận"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        )
            : Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border_rounded),
          ),
        ),
      );

  }
  Widget _buildProductDetail(){
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 350,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.productProvider.images[widget.product.id.toString()]!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(imageData:  widget.productProvider.images[widget.product.id.toString()]![index],),
                      ),
                    );
                  },
                  child: Image.memory(widget.productProvider.images[widget.product.id.toString()]![index],fit: BoxFit.cover),
                );
              },
            ),
          ),
          const SizedBox(height: 25),
          Text(
            widget.product.name,
            style: const TextStyle(color: AppPalette.textColor, fontSize: 30 , fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              const Text(
                "Thương hiệu : ",
                style: TextStyle(
                    color: AppPalette.textColor, fontSize: 16),
              ),
              Text(
                widget.product.brands.name,
                style: const TextStyle(
                    color: AppPalette.textColorRed, fontSize: 18),
              ),
              const Text(
                " | ",
                style: TextStyle(
                    color: AppPalette.textColor, fontSize: 20),
              ),
              const Text(
                "Tình trạng : ",
                style: TextStyle(
                    color: AppPalette.textColor, fontSize: 16),
              ),
              Text(
                widget.product.status, maxLines: 1, overflow: TextOverflow.ellipsis ,
                style: const TextStyle(
                  color: AppPalette.textColorRed, fontSize: 18 ,),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Text(
                '${formatPrice(widget.product.price)} vnd',
                style: const TextStyle(
                    color: AppPalette.textColorRed, fontSize: 26 , fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              widget.isAdmin
                  ? ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CrudProductScreen(productResponse: widget.product),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.green3Color,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(20))),
                ),
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Chỉnh sửa'),
              )
                  : ElevatedButton.icon(
                onPressed: isInCart
                    ? null // Không có hành động nếu sản phẩm đã có trong giỏ hàng
                    : () {
                  _addCart(user.user.id, widget.product.id, 1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.green3Color,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(20))),
                ),
                icon: const Icon(Icons.add_shopping_cart_rounded),
                label: const Text('Thêm vào giỏ hàng'),
              ),
            ],
          ),
          const SizedBox(height: 25),
          TabBar(
            labelColor: Colors.black, // Màu của văn bản được chọn
            unselectedLabelColor: Colors.grey, // Màu của văn bản không được chọn
            controller: _tabController,
            labelStyle: const TextStyle(color: AppPalette.textColor, fontSize: 18 , fontWeight: FontWeight.bold), // Kích thước văn bản được chọn
            unselectedLabelStyle: const TextStyle(color: AppPalette.textColor, fontSize: 16 ,fontWeight: FontWeight.bold), // Kích thước văn bản không được chọn
            tabs: const [
              Tab(text: 'Mô tả sản phẩm',),
              Tab(text: 'Thông số kỹ thuật'),
            ],
          ),
          SizedBox(
            height: 500,
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Text(
                    widget.product.description,
                    style: const TextStyle(color: AppPalette.textColor, fontSize: 16),
                  ),
                ),
                SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Thuộc tính')),
                      DataColumn(label: Text('Giá trị')),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text('Màu sắc')),
                        DataCell(Text(widget.product.color)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Chất liệu khung vợt')),
                        DataCell(Text(widget.product.chatLieuKhungVot)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Chất liệu thân vợt')),
                        DataCell(Text(widget.product.chatLieuThanVot)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Trọng lượng')),
                        DataCell(Text(widget.product.trongLuong)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Độ cứng')),
                        DataCell(Text(widget.product.doCung)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Điểm cân bằng')),
                        DataCell(Text("${widget.product.diemCanBang} mm")),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Chiều dài vợt')),
                        DataCell(Text(widget.product.chieuDaiVot)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Mức căng tối đa')),
                        DataCell(Text(widget.product.mucCangToiDa)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Chu vi cán cầm')),
                        DataCell(Text(widget.product.chuViCanCam)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Trình độ chơi')),
                        DataCell(Text(widget.product.trinhDoChoi)),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Nội dung chơi')),
                        DataCell(Text(widget.product.noiDungChoi)),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildEmptyState(){
    return Container(
      alignment: Alignment.center,
      child: const Text(
        'Sãn phẩm đã bị xóa',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final Uint8List imageData;

  const FullScreenImage({Key? key, required this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: PhotoView(
            imageProvider: MemoryImage(imageData),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
            initialScale: PhotoViewComputedScale.contained,
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}