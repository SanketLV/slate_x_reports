import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:slate_x_reports/features/invoice/data/invoice_service.dart';
import 'package:slate_x_reports/features/invoice/ui/widgets/custom_dropdown.dart';
import 'package:slate_x_reports/features/invoice/ui/widgets/info_tile.dart';
import 'package:slate_x_reports/features/invoice/ui/widgets/invoice_data_source.dart';
import 'package:slate_x_reports/features/invoice/ui/widgets/quick_select.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:table_calendar/table_calendar.dart';

class OrderTypeItems {
  final String value;
  final String label;

  OrderTypeItems(this.value, this.label);
}

List<OrderTypeItems> orderTypes = [
  OrderTypeItems("", "All Order Types"),
  OrderTypeItems("0", "Dine-in"),
  OrderTypeItems("1", "Take Away"),
  OrderTypeItems("2", "Delivery"),
];

class PaymentStatusItems {
  final String value;
  final String label;

  PaymentStatusItems(this.value, this.label);
}

List<PaymentStatusItems> paymentStatuss = [
  PaymentStatusItems("", "All Status"),
  PaymentStatusItems("3", "Paid"),
  PaymentStatusItems("4", "Void"),
  PaymentStatusItems("5", "Refunded"),
  PaymentStatusItems("6", "Complimentary"),
];

List<String> _columnOrder = [
  "invoice_no",
  "order_date_time",
  "terminal_id",
  "user_name",
  "order_mode",
  "order_type",
  "sub_total_bill",
  "total_discount",
  "other_charges",
  "service_tax",
  "total_tax",
  "total_bill",
  "payment_mode",
  "payment_status",
  "server_name",
];

Map<String, String> _columnLabels = {
  "invoice_no": "Invoice No",
  "order_date_time": "Date & Time",
  "terminal_id": "Terminal",
  "user_name": "Customer Name",
  "order_mode": "Order mode",
  "order_type": "Order Type",
  "sub_total_bill": "Sub Total",
  "total_discount": "Discount",
  "other_charges": "Other Charges",
  "service_tax": "Service Charges",
  "total_tax": "Tax",
  "total_bill": "Total",
  "payment_mode": "Payment Type",
  "payment_status": "Payment Status",
  "server_name": "Server Name",
};

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  // final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String? _error;

  List<Map<String, dynamic>> _tableData = const [];
  List<String> _columns = const [];

  String _cellText(dynamic value) {
    if (value == null) return "";
    if (value is num) return value.toString();
    return value.toString();
  }

  // Sales box values
  int _totalOrders = 0;
  double _totalSales = 0;
  double _totalTax = 0;
  double _serviceTax = 0;
  double _totalDiscount = 0;
  double _totalOtherCharges = 0;
  double _averageOrderValue = 0;

  double _asDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v.trim().isEmpty ? "0" : v) ?? 0;
    return 0;
  }

  int _asInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v.trim().isEmpty ? "0" : v) ?? 0;
    return 0;
  }

  DateTimeRange? selectedRange;
  final DateFormat formatter = DateFormat("MM/dd/yyyy");

  CalendarFormat _calendarFormat = CalendarFormat.month;

  final TextEditingController orderTypeController = TextEditingController();
  OrderTypeItems? selectedOrderType = orderTypes.first;

  final TextEditingController paymentStatusController = TextEditingController();
  PaymentStatusItems? selectedPaymentStatus = paymentStatuss.first;

  final InvoiceService _invoiceService = InvoiceService();

  Future<void> _fetchInvoiceReport() async {
    final range =
        selectedRange ??
        DateTimeRange(start: DateTime.now(), end: DateTime.now());

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await _invoiceService.fetchInvoiceReport(
        startDate: range.start,
        endDate: range.end,
        orderType: selectedOrderType?.value ?? "",
        paymentStatus: selectedPaymentStatus?.value ?? "",
        paymentMode: "",
        branchId: 1,
        start: 0,
        length: 10,
        value: "",
      );

      log("$response");

      // If your service returns ApiAuthResponse, unwrap; otherwise treat as Map directly
      final Map<String, dynamic> payload = (() {
        if (response is Map<String, dynamic>) return response;
        try {
          final maybe = (response.result as Map<String, dynamic>?);
          return maybe ?? <String, dynamic>{};
        } catch (_) {
          return <String, dynamic>{};
        }
      })();

      // sales_box could vary in shape/case; handle robustly
      final salesBoxDyn = payload['sales_box'];
      final List<dynamic> dataDyn =
          (payload['data']) as List<dynamic>? ?? const [];

      final table = dataDyn.whereType<Map<String, dynamic>>().toList();

      final availableKeys = table.isNotEmpty
          ? table.first.keys.map((k) => k.toString()).toSet()
          : <String>{};

      // final cols = table.isNotEmpty
      //     ? table.first.keys.map((k) => k.toString()).toList()
      //     : <String>[];

      final cols = _columnOrder
          .where((k) => availableKeys.contains(k))
          .toList();

      log("Table Data: $table");

      final Map<String, dynamic> salesBox = salesBoxDyn is Map<String, dynamic>
          ? salesBoxDyn
          : <String, dynamic>{};

      final totalOrders = _asInt(salesBox['total_orders']);
      final totalSales = _asDouble(salesBox['total_sales']);
      final totalTax = _asDouble(salesBox['total_tax']);
      final serviceTax = _asDouble(salesBox['service_tax']);
      final totalDiscount = _asDouble(salesBox['total_discount']);
      final totalOther = _asDouble(salesBox['total_other_charges']);
      final aov = _asDouble(salesBox['average_order_value']);

      if (!mounted) return;
      setState(() {
        _totalOrders = totalOrders;
        _totalSales = totalSales;
        _totalTax = totalTax;
        _serviceTax = serviceTax;
        _totalDiscount = totalDiscount;
        _totalOtherCharges = totalOther;
        _averageOrderValue = aov;
        _loading = false;
        _tableData = table;
        _columns = cols;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  //* Open Quick Select Bottom Sheet
  void _openDateRangeDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return QuickSelect(
          onRangeSelected: (range) {
            setState(() {
              selectedRange = range;
            });
            Navigator.pop(context);
            _fetchInvoiceReport();
          },
          onCustomRangeTap: () {
            Navigator.pop(context);
            _openCalendar();
          },
        );
      },
    );
  }

  //* Open Calendar for Custom Range
  void _openCalendar() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime? start;
        DateTime? end;

        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TableCalendar(
                    focusedDay: DateTime.now(),
                    firstDay: DateTime(2020),
                    lastDay: DateTime.now(),
                    rangeSelectionMode: RangeSelectionMode.enforced,
                    rangeStartDay: start,
                    rangeEndDay: end,
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      setState(() => _calendarFormat = format);
                    },
                    onRangeSelected: (startDate, endDate, _) {
                      setState(() {
                        start = startDate;
                        end = endDate;
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      if (start != null && end != null) {
                        this.setState(() {
                          selectedRange = DateTimeRange(
                            start: start!,
                            end: end!,
                          );
                        });
                        Navigator.pop(context);
                        _fetchInvoiceReport();
                      }
                    },
                    child: Text("Apply"),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  late InvoiceDataSource _invoiceDataSource;
  final DataPagerController _dataPagerController = DataPagerController();

  @override
  void initState() {
    super.initState();

    //* Default to current day
    selectedRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());

    //* Fire after first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInvoiceReport();
    });

    _invoiceDataSource = InvoiceDataSource(_tableData, _columns);
  }

  @override
  Widget build(BuildContext context) {
    final display = selectedRange == null
        ? "${formatter.format(DateTime.now())} - ${formatter.format(DateTime.now())}"
        : "${formatter.format(selectedRange!.start)} - ${formatter.format(selectedRange!.end)}";

    if (_loading) {
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(),
      );
    }
    if (_error != null) {
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(_error!, style: TextStyle(color: Colors.red)),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Invoice Report",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),

                  SizedBox(height: 10),

                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(color: Colors.grey.shade300, width: 4),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // child: Form(
                    //   key: _formKey,
                    child: Column(
                      children: [
                        //* Date Range Picker
                        InkWell(
                          onTap: _openDateRangeDialog,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: "Date Range",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                //* Calendar Icon
                                Icon(LucideIcons.calendar),

                                SizedBox(width: 16),

                                //* Selected Date
                                Text(display, style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        //* Order Type Dropdown Menu
                        CustomDropdown<OrderTypeItems>(
                          items: orderTypes,
                          selectedItems: selectedOrderType,
                          onChanged: (OrderTypeItems? orderType) {
                            setState(() {
                              selectedOrderType = orderType;
                            });
                          },
                          getLabel: (OrderTypeItems item) => item.label,
                          getValue: (OrderTypeItems item) => item.value,
                          label: "Order Type",
                          hintText: "Select an Option",
                        ),

                        SizedBox(height: 16),

                        //* Payment Status Dropdown Menu
                        CustomDropdown<PaymentStatusItems>(
                          items: paymentStatuss,
                          selectedItems: selectedPaymentStatus,
                          onChanged: (PaymentStatusItems? paymentStatus) {
                            setState(() {
                              selectedPaymentStatus = paymentStatus;
                            });
                          },
                          getLabel: (PaymentStatusItems item) => item.label,
                          getValue: (PaymentStatusItems item) => item.value,
                          label: "Payment Status",
                          hintText: "Select an Option",
                        ),
                      ],
                    ),
                  ),

                  // ),
                  InfoTile(
                    title: "Total Invoice Count",
                    value: "$_totalOrders",
                    icon: LucideIcons.shoppingBag,
                  ),

                  InfoTile(
                    title: "Final Net Sales",
                    subtitle:
                        "(Sub Total – Order Discount + Other Charges + Total Tax)",
                    value: "\$${_totalSales.toStringAsFixed(2)}",
                    icon: LucideIcons.dollarSign,
                  ),

                  InfoTile(
                    title: "Total Tax",
                    subtitle:
                        "All Taxes (including on gratuity and service charges)",
                    value: "\$${_totalTax.toStringAsFixed(2)}",
                    icon: LucideIcons.dollarSign,
                  ),

                  InfoTile(
                    title: "Service Charges",
                    subtitle: "(Gratuity + Service Charges)",
                    value: "\$${_serviceTax.toStringAsFixed(2)}",
                    icon: LucideIcons.dollarSign,
                  ),

                  InfoTile(
                    title: "Total Discount",
                    subtitle: "(Other Discount)",
                    value: "\$${_totalDiscount.toStringAsFixed(2)}",
                    icon: LucideIcons.dollarSign,
                  ),

                  InfoTile(
                    title: "Other Charges",
                    subtitle: "(Packaging Charges + Delivery Charges)",
                    value: "\$${_totalOtherCharges.toStringAsFixed(2)}",
                    icon: LucideIcons.dollarSign,
                  ),

                  InfoTile(
                    title: "Average Order Value",
                    subtitle: "(Final Net Sales / Total Invoice Count)",
                    value: "\$${_averageOrderValue.toStringAsFixed(2)}",
                    icon: LucideIcons.dollarSign,
                  ),

                  //* Invoice Table
                  if (_columns.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      height: 400,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SfDataGrid(
                            source: InvoiceDataSource(_tableData, _columns),
                            // allowSorting: true,
                            // allowTriStateSorting: true,
                            // showSortNumbers: true,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            columns: _columns
                                .map(
                                  (c) => GridColumn(
                                    minimumWidth: 150,
                                    columnName: c,
                                    label: Container(
                                      padding: EdgeInsets.all(8),
                                      alignment: Alignment.centerLeft,
                                      color: Colors.grey.shade200,
                                      child: Row(
                                        children: [
                                          Text(
                                            _columnLabels[c] ?? c,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.visible,
                                          ),
                                          SizedBox(width: 4),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          SfDataPager(
                            delegate: _invoiceDataSource,
                            controller: _dataPagerController,
                            availableRowsPerPage: const [5, 20, 50],
                            pageCount: (_tableData.length / 10).ceilToDouble(),
                            onPageNavigationStart: (pageIndex) {
                              _invoiceDataSource.updateDataPager(pageIndex);
                            },
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    SizedBox(height: 16),
                    Text("No Table Data"),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
