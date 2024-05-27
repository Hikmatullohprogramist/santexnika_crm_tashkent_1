// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:santexnika_crm/tools/appColors.dart';

class DataTableWidget extends StatefulWidget {
  final List<DataColumn> dataColumn;
  final List<DataRow> dataRow;
  final double? dataRowHeight;
  final double? fontSize;
  final double? columnSpacing;
  final FontWeight? fontWeight;
  final bool? checkbox;
  final bool? isHorizantal;

  const DataTableWidget({
    super.key,
    required this.dataColumn,
    required this.dataRow,
    this.dataRowHeight,
    this.fontSize,
    this.columnSpacing,
    this.fontWeight,
    this.checkbox,
    this.isHorizantal,
  });

  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: AppColors.primaryColor,
        dataTableTheme: const DataTableThemeData(),
        checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all(AppColors.primaryColor),
            // mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
            checkColor: MaterialStateProperty.all(AppColors.whiteColor),
            side: BorderSide(color: AppColors.whiteColor)),
      ),
      child: widget.isHorizantal == true
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: widget.checkbox ?? false,
                dividerThickness: 1,
                columnSpacing: widget.columnSpacing ?? 60,
                dataRowHeight: widget.dataRowHeight ?? 80,
                dataTextStyle: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.black,
                  fontSize: widget.fontSize ?? 19,
                  fontWeight: widget.fontWeight ?? FontWeight.w600,
                ),
                decoration: const BoxDecoration(),
                columns: widget.dataColumn,
                rows: widget.dataRow,
              ),
            )
          : DataTable(
              showCheckboxColumn: widget.checkbox ?? false,
              dividerThickness: 1,
              columnSpacing: widget.columnSpacing ?? 60,
              dataRowHeight: widget.dataRowHeight ?? 80,
              dataTextStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.black,
                fontSize: widget.fontSize ?? 19,
                fontWeight: widget.fontWeight ?? FontWeight.w600,
              ),
              decoration: const BoxDecoration(),
              columns: widget.dataColumn,
              rows: widget.dataRow,
            ),
    );
  }
}
