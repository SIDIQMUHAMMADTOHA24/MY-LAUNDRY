import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_laundry/config/app_colors.dart';
import 'package:my_laundry/config/failure.dart';
import 'package:my_laundry/config/nav.dart';
import 'package:my_laundry/data_source/shop_datasource.dart';
import 'package:my_laundry/model/shop_model.dart';
import 'package:my_laundry/pages/detail_shop_pages.dart';
import 'package:my_laundry/providers/search_by_city_provider.dart';

class SearchByCityPages extends ConsumerStatefulWidget {
  const SearchByCityPages({super.key, required this.query});
  final String query;

  @override
  ConsumerState<SearchByCityPages> createState() => _SearchByCityPagesState();
}

class _SearchByCityPagesState extends ConsumerState<SearchByCityPages> {
  final edtSearch = TextEditingController();

  execute() {
    ShopDataSource.searchByCity(name: edtSearch.text).then((value) {
      setSearchByCityStatus(ref, 'Loading');
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setSearchByCityStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setSearchByCityStatus(ref, 'Not Found');
              break;
            case ForbiddenFailure:
              setSearchByCityStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setSearchByCityStatus(ref, 'Bad request');
              break;
            case UnauthorisedFailure:
              setSearchByCityStatus(ref, 'Unauthorised');
              break;
            default:
              setSearchByCityStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setSearchByCityStatus(ref, 'Success');
          List data = result['data'];
          List<ShopModel> list =
              data.map((e) => ShopModel.fromJson(e)).toList();
          ref.read(searchByCityListProvider.notifier).setData(list);
        },
      );
    });
  }

  @override
  void initState() {
    if (widget.query != '') {
      edtSearch.text = widget.query;

      execute();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(children: [
              const Text(
                'City: ',
                style:
                    TextStyle(color: Colors.black54, fontSize: 16, height: 1),
              ),
              Expanded(
                child: TextField(
                  controller: edtSearch,
                  decoration: const InputDecoration(
                      border: InputBorder.none, isDense: true),
                  style: const TextStyle(height: 1),
                  onSubmitted: (value) => execute(),
                ),
              )
            ]),
          ),
        ),
        actions: [
          IconButton(onPressed: () => execute(), icon: const Icon(Icons.search))
        ],
      ),
      body: Consumer(
        builder: (_, wiRef, __) {
          String status = wiRef.watch(searchByCityStatusProvider);
          List<ShopModel> list = wiRef.watch(searchByCityListProvider);
          if (status.isEmpty) return DView.nothing();
          if (status == 'Loading') return DView.loadingCircle();
          if (status == 'Success') {
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                ShopModel item = list[index];
                return ListTile(
                  onTap: () {
                    Nav.push(context, DetailShopPages(shop: item));
                  },
                  leading: CircleAvatar(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(item.name),
                  subtitle: Text(item.city),
                  trailing: const Icon(Icons.navigate_next),
                );
              },
            );
          }
          return DView.error(data: status);
        },
      ),
    );
  }
}
