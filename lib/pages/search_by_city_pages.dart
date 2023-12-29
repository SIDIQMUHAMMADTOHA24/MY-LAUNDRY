import 'package:flutter/material.dart';
import 'package:my_laundry/config/failure.dart';
import 'package:my_laundry/data_source/shop_datasource.dart';
import 'package:my_laundry/model/shop_model.dart';

class SearchByCityPages extends StatefulWidget {
  const SearchByCityPages({super.key, required this.query});
  final String query;

  @override
  State<SearchByCityPages> createState() => _SearchByCityPagesState();
}

class _SearchByCityPagesState extends State<SearchByCityPages> {
  final edtSearch = TextEditingController();

  execute() {
    ShopDataSource.searchByCity(name: edtSearch.text)
        .then((value) => value.fold((failure) {
              switch (failure.runtimeType) {
                case ServerFailure:
                  break;
                case NotFoundFailure:
                  break;
                case ForbiddenFailure:
                  break;
                case BadRequestFailure:
                  break;
                case UnauthorisedFailure:
                  break;
                default:
                  break;
              }
            }, (result) {
              List data = result['data'];
              List<ShopModel> list =
                  data.map((e) => ShopModel.fromJson(e)).toList();
                  
            }));
  }

  @override
  void initState() {
    if (widget.query.isNotEmpty) {
      edtSearch.text = widget.query;
      execute();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
