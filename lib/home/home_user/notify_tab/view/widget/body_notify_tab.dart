import 'package:doan_tn/home/home_user/notify_tab/model/notify_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../auth/login/model/login_response.dart';
import '../../../../../auth/login/model/test_luu_user.dart';
import '../../../../../base/controler/base_provider.dart';
import '../../controller/notify_provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
class BodyNotifyTab extends StatefulWidget {
  const BodyNotifyTab({Key? key}) : super(key: key);

  @override
  State<BodyNotifyTab> createState() => _BodyNotifyTabState();
}

class _BodyNotifyTabState extends State<BodyNotifyTab> {
  late NotifyProvider notifyProvider;
  late LoginResponse user;
  List<int> selectedIndexes = [];
  final ScrollController scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    notifyProvider = Provider.of<NotifyProvider>(context, listen: false);
    notifyProvider.listNotify = [];
    user = TempUserStorage.currentUser!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyProvider.getListNotify(user.user.id);
    });
  }
  Future<void> _refresh() async{
    // notifyProvider.refresh = true;
    // notifyProvider.resetPage();
    notifyProvider.getListNotify(user.user.id);
  }
  Future<void> _scrollListener() async {
   // productProvider.loadMore();
  }
  void selectAll() {
    setState(() {
      selectedIndexes.clear();
      for (int i = 0; i < notifyProvider.listNotify.length; i++) {
        selectedIndexes.add(notifyProvider.listNotify[i].id);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          color: const Color.fromRGBO(239, 239, 239, 1),
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    selectAll();
                  },
                  child: const Text(
                    'Tất cả',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Open Sans",
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 104, 133, 1)),
                  )),
              TextButton(
                  onPressed: () {
                      for (int notifyId in selectedIndexes) {
                        notifyProvider.deleteNotify(notifyId, user.user.id);
                      }
                      selectedIndexes.clear(); // Xóa danh sách tạm thời sau khi xóa các thông báo
                  },
                  child: const Text("Đánh dấu đã đọc",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Open Sans",
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 104, 133, 1)))),
            ],
          ),
        ),
        Selector<NotifyProvider, Status>(builder: (context, value, child) {
          print('--------statusListNotify--------');
          if (value == Status.loading) {
            notifyProvider.messagesLoading = "Loading Notify...";
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ProgressHUD.of(context)
                  ?.showWithText(notifyProvider.messagesLoading);
            });
          } else if (value == Status.loaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ProgressHUD.of(context)?.dismiss();
            });
          }  else if (value == Status.error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ProgressHUD.of(context)?.dismiss();
            });
            return const Center(child: Text('Khong co du lieu'));
          }
          else if (value == Status.noData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ProgressHUD.of(context)?.dismiss();
            });
            return  Expanded(
                child: RefreshLoadmore(
                    isLastPage: false,
                    onRefresh: _refresh,
                    onLoadmore: _scrollListener,
                    child: const Center(child: Text('Ban khong có thong bao nao'))));
          }
          return buildData(notifyProvider);
        }, selector: (context, pro) {
          return pro.statusListNotify;
        }),
        // ConsumerBase<NotifyProvider>(
        //     contextData: context,
        //     onRepository: (rep) {
        //       print('================-----');
        //       NotifyProvider pro = rep;
        //       if (pro.isLoading) {
        //         pro.messagesLoading = 'Đang lấy dữ liệu info.....';
        //       }
        //       return const SizedBox();
        //     },
        //     onRepositoryError: (rep) {
        //       return Center(
        //           child: Text(
        //             rep.messagesError ?? '',
        //             style: const TextStyle(fontSize: 14, color: Colors.black),
        //           ));
        //     },
        //     onRepositoryNoData: (rep) {
        //       return const Center(
        //         child: Text(
        //           'Khong co du thong bao',
        //           style: TextStyle(fontSize: 14, color: Colors.black),
        //         ),
        //       );
        //     },
        //     onRepositorySuccess: (rep) {
        //       NotifyProvider pro = rep;
        //       if (pro.isLoaded) {
        //         WidgetsBinding.instance.addPostFrameCallback((_) {
        //           ProgressHUD.of(context)?.dismiss();
        //         });
        //       }
        //       return buildData(pro);
        //     }),
        Selector<NotifyProvider, Status>(builder: (context, value, child) {
          print('--------statusMarkRead--------');
          if (value == Status.loading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ProgressHUD.of(context)?.show();
            });
          } else if (value == Status.loaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ProgressHUD.of(context)?.dismiss();
              _refresh();
            });
          } else if (value == Status.error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ProgressHUD.of(context)?.dismiss();
            });
          }
          return const SizedBox();
        }, selector: (context, pro) {
          return pro.statusDelete;
        }),
      ],
    );
  }
  Widget buildData(NotifyProvider provider) {
    return Expanded(
      child:
            RefreshLoadmore(
              isLastPage: false,
              onRefresh: _refresh,
              onLoadmore: _scrollListener,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: provider.listNotify.length,
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    itemList(provider.listNotify[index], index),
              ),
            )
    );
  }

  Widget itemList(NotifyResponse model, int index) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: NetworkImage(
            "https://cdn-icons-png.flaticon.com/512/3607/3607444.png"),
      ),
      title: Text(model.message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 16,
              fontFamily: "Open Sans",
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(0, 104, 133, 1))),
      subtitle: Text(model.sentDateTime,
          style: const TextStyle(
              fontSize: 14,
              fontFamily: "Open Sans",
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(146, 142, 133, 1))),
      trailing: Checkbox(
        checkColor: Colors.white,
        value: selectedIndexes.contains(model.id),
        onChanged: (value) {
          setState(() {
            if (value!) {
              selectedIndexes.add(model.id);
            } else {
              selectedIndexes.remove(model.id);
            }
          });
        },
      ),
    );
  }
}

