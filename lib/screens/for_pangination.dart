import 'dart:async';

import 'package:dartz/dartz.dart' as DZ;
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:santexnika_crm/models/base_model.dart';
import 'package:santexnika_crm/models/orders/ordersModel.dart';
import 'package:santexnika_crm/service/api_service/orders/orders.dart';
import 'package:santexnika_crm/widgets/input/mobile_search.dart';

class ForPagination extends StatefulWidget {
  const ForPagination({super.key});

  @override
  State<ForPagination> createState() => _ForPaginationState();
}

class _ForPaginationState extends State<ForPagination> {
  static const _pageSize = 20;

  int page = 1;
  Timer? searchTime;
  String searchQuery = "";
  final PagingController<int, OrdersModel> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener(
      (pageKey) {
        _fetchPage(pageKey, searchQuery);
      },
    );
    super.initState();
  }

  handleRefresh() {
    _pagingController.refresh();
  }

  Future<void> _fetchPage(int pageKey, String query) async {
    bool isLastPage = false;
    DZ.Either<String, BaseModel<List<OrdersModel>>> newItems =
        await OrdersService().getOrders(pageKey, query);

    newItems.fold((l) => null, (r) {
      isLastPage = r.currentPage == r.lastPage;
      if (isLastPage) {
        _pagingController.appendLastPage(r.data);
      } else {
        final nextPageKey = pageKey + 1;
          _pagingController.appendPage(r.data, nextPageKey);
      }
    });
  }

  void handleSearch(String query) {
    if (mounted) {
      searchTime?.cancel();
      searchTime = Timer(const Duration(microseconds: 600), () {
        if (query.isNotEmpty) {
          searchQuery = query;
          OrdersService().searchSold(query.trim());
        } else {
          OrdersService().getOrders(page, query);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MobileSearchInput(
          onChanged: (v) {
            searchQuery = v;
            handleRefresh();
          },
        ),
        actions: [
          Text(
            _pagingController.itemList?.length.toString() ?? "",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      body: PagedListView<int, OrdersModel>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<OrdersModel>(
            itemBuilder: (context, item, index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: Text(index.toString()),
            color: Colors.green,
            margin: EdgeInsets.all(10),
          );
        }),
      ),
    );
  }
}
