import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'base_provider.dart';

class ConsumerBase<T> extends StatelessWidget {
  ConsumerBase(
      {Key? key,
        required this.onRepository,
        this.onRepositoryLoading,
        this.onRepositorySuccess,
        this.onRepositoryError,
        this.onRepositoryNoData,
        this.contextData})
      : super(key: key);
  late Function(dynamic provider) onRepository;
  late Function(dynamic provider)? onRepositoryLoading;
  late Function(dynamic provider)? onRepositorySuccess;
  late Function(dynamic provider)? onRepositoryError;
  late Function(dynamic provider)? onRepositoryNoData;
  late BuildContext? contextData;

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(builder: (context, T, child) {
      BaseProvider provider = T as BaseProvider;
      if (provider.isLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (provider.messagesLoading == "") {
            ProgressHUD.of(contextData ?? context)?.show();
          } else {
            ProgressHUD.of(contextData ?? context)
                ?.showWithText(provider.messagesLoading);
          }
        });
        if (onRepositoryLoading != null) {
          return onRepositoryLoading!(T);
        }
      } else if (provider.isLoaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ProgressHUD.of(contextData ?? context)?.dismiss();
        });
        if (onRepositorySuccess != null) {
          return onRepositorySuccess!(provider);
        }
      } else if (provider.loadingFailed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ProgressHUD.of(contextData ?? context)?.dismiss();
        });
        if (onRepositoryError != null) {
          return onRepositoryError!(provider);
        }
      } else if (provider.noData) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ProgressHUD.of(contextData ?? context)?.dismiss();
        });
        if (onRepositoryNoData != null) {
          return onRepositoryNoData!(provider);
        }
      }
      if (onRepository != null) {
        return onRepository(provider);
      } else {
        return Container();
      }
    });
  }
}
