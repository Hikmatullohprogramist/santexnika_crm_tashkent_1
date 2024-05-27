import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/tools/appColors.dart';

class PaginatedDataTableWidget extends StatelessWidget {
  final List<DataColumn> columns;
  final DataTableSource source;
  final Function(int) onPageChanged;
  final Function(int?) onRowsPerPage;

  const PaginatedDataTableWidget({
    super.key,
    required this.columns,
    required this.source,
    required this.onPageChanged,
    required this.onRowsPerPage,
  });

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: AppColors.primaryColor,
        dataTableTheme: DataTableThemeData(
          dividerThickness: 1,
          columnSpacing: 100,

          decoration: const BoxDecoration(),
          headingTextStyle:
              TextStyle(color: AppColors.whiteColor, fontSize: 200),
          dataTextStyle: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: AppColors.whiteColor,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),

          headingRowColor: MaterialStateColor.resolveWith(
              (states) => AppColors.primaryColor),

          dataRowColor: MaterialStateColor.resolveWith(
            (states) => AppColors.primaryColor,
          ), // Change the col

          // or here
        ),
      ),

      child: Container(
        color: AppColors.primaryColor,
        child: PaginatedDataTable(
           showFirstLastButtons: true,
           dataRowHeight: 80.h,
          columnSpacing: 90.h,
          showCheckboxColumn: false,
          columns: columns,
          source: source,
          onPageChanged: onPageChanged,
          onRowsPerPageChanged: (a) {},
        ),
      ),
    );
  }
}
