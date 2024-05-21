import 'package:doan_tn/home/home_admin/thongke_tab/model/monthly_response.dart';
import 'package:doan_tn/home/home_admin/thongke_tab/model/product_top_10_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:intl/intl.dart';
import '../../../../../base/controler/base_provider.dart';
import '../../../../../base/services/dio_option.dart';
import '../../controller/thongke_controller.dart';
import '../../servicer/thongke_service.dart';
import 'package:fl_chart/fl_chart.dart';

class OrderTopProduct extends StatelessWidget {
  const OrderTopProduct({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>ThongKeProvider(ThongKeService(DioOption().createDio())),
        ),
      ],
      child: BodyOrderTopProduct(),
    );
  }
}

class BodyOrderTopProduct extends StatefulWidget {
  BodyOrderTopProduct({Key? key }) : super(key: key);
  @override
  State<BodyOrderTopProduct> createState() => _OrderTopProductState();
}

class _OrderTopProductState extends State<BodyOrderTopProduct> {
  late ThongKeProvider thongKeProvider;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    thongKeProvider = Provider.of<ThongKeProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      thongKeProvider.getListOrderWithProductTop10();
    });
  }
  String formatDateTime(DateTime dateTime) {
    String format = 'dd/MM/yyyy HH:mm:ss';
    return DateFormat(format).format(dateTime);
  }
  String formatPrice(double price) {
    final formatter = NumberFormat('#,###');
    return formatter.format(price);
  }


  @override
  Widget build(BuildContext context) {
    return
      Selector<ThongKeProvider, Status>(builder: (context, value, child) {
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
        } else if (value == Status.error) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ProgressHUD.of(context)?.dismiss();
            print('Load error r');
          });
        } else if (value == Status.noData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ProgressHUD.of(context)?.dismiss();
          });
          return const Center(child: Text("Không có mục đơn hàng nào"));
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildChart(thongKeProvider.listProductTop10),
        );
      }, selector: (context, pro) {
        return pro.statusTop10Product;
      });
  }
  Widget _buildChart(List<ProductTop10Response> data) {
    return Container(
      padding: const EdgeInsets.only(left: 20 , top: 40 , right: 20),
      height: 600,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _calculateMaxValue(data),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => const TextStyle(color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
              margin: 10,
              getTitles: (double value) {
                return '${data[value.toInt()].productId}';
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => const TextStyle(color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 12),
              margin: 20,
              interval: _calculateMaxValue(data) == 0 ? 1 : _calculateMaxValue(data) / 25, // Điều chỉnh giá trị interval để tăng khoảng cách
            ),
          ),
          borderData: FlBorderData(
            show: true, // Hiển thị lưới
            border: const Border(
              bottom: BorderSide(color: Colors.black), // Màu sắc của đường kẻ
              left: BorderSide(color: Colors.black), // Màu sắc của đường kẻ
            ),
          ),
          gridData: FlGridData(
            show: true, // Hiển thị lưới
            horizontalInterval: _calculateMaxValue(data) == 0 ? 1 : _calculateMaxValue(data) / 20, // Khoảng cách giữa các đường kẻ ngang
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.black, // Màu sắc của đường kẻ
                strokeWidth: 1, // Độ dày của đường kẻ
              );
            },
          ),

          barGroups: _createBarGroups(data),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.grey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  " ${data[groupIndex].productName}", textAlign: TextAlign.center,
                  const TextStyle( fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold , ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  double _calculateMaxValue(List<ProductTop10Response> data) {
    double max = 0;
    for (var item in data) {
      if (item.totalRevenue > max) {
        max = item.totalRevenue;
      }
    }
    return max;
  }

// List<BarChartGroupData> _createBarGroups(List<MonthlyResponse> data) {
//   return List.generate(
//     data.length,
//         (index) => BarChartGroupData(
//       x: index,
//       barRods: [
//         BarChartRodData(
//           width: 50,
//           y: data[index].revenue,
//           colors: [Colors.blue],
//         ),
//       ],
//     ),
//   );
// }
  List<BarChartGroupData> _createBarGroups(List<ProductTop10Response> data) {
    return List.generate(
      data.length,
          (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: data[index].totalRevenue,
            colors: [Colors.blue],
            width: 40,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
        ],
      ),
    );
  }


  Widget _buildPieChart(List<MonthlyResponse> data) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 600,
      child: PieChart(
        PieChartData(
          sections: _createPieChartSections(data),
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  List<PieChartSectionData> _createPieChartSections(List<MonthlyResponse> data) {
    return List.generate(
      data.length,
          (index) {
        final revenue = data[index].revenue;
        final title = '${data[index].month}/${data[index].year}';
        final color = Colors.primaries[index % Colors.primaries.length];

        return PieChartSectionData(
          color: color,
          value: revenue,
          title: title,
          radius: 100,
          titleStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
