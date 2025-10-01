import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class InvoiceDataSource extends DataGridSource {
  final List<Map<String, dynamic>> data;
  final List<String> columns;

  List<DataGridRow> _rows = [];
  int _startIndex = 0;
  int _endIndex = 0;
  int _rowsPerPage = 10;

  InvoiceDataSource(this.data, this.columns) {
    buildPaginatedData();
  }

  void buildPaginatedData() {
    _startIndex = _startIndex;
    _endIndex = _startIndex + _rowsPerPage;
    if (_endIndex > data.length) {
      _endIndex = data.length;
    }
    _rows = data
        .getRange(_startIndex, _endIndex)
        .map(
          (row) => DataGridRow(
            cells: columns.map((c) {
              return DataGridCell(columnName: c, value: row[c]?.toString());
            }).toList(),
          ),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          alignment: Alignment.centerLeft,
          child: Text(cell.value.toString(), style: TextStyle(fontSize: 14)),
        );
      }).toList(),
    );
  }

  void updateDataPager(int pageIndex) {
    _startIndex = pageIndex * _rowsPerPage;
    buildPaginatedData();
    notifyListeners();
  }
}
