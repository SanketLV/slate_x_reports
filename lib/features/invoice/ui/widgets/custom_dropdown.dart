import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedItems;
  final ValueChanged<T?>? onChanged;
  final String Function(T) getLabel;
  final String Function(T) getValue;
  final String label;
  final String hintText;
  final bool enableFilter;
  final double? width;
  final bool requestFocusOnTap;

  const CustomDropdown({
    super.key,
    required this.items,
    this.selectedItems,
    this.onChanged,
    required this.getLabel,
    required this.getValue,
    required this.label,
    this.hintText = "Select an Option",
    this.enableFilter = true,
    this.width,
    this.requestFocusOnTap = true,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dropdownWidth = widget.width ?? screenWidth - 70;

    return DropdownMenu<T>(
      initialSelection: widget.selectedItems ?? widget.items.first,
      width: dropdownWidth,
      controller: _controller,
      enableFilter: widget.enableFilter,
      requestFocusOnTap: widget.requestFocusOnTap,
      label: Text(widget.label),
      hintText: widget.hintText,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        fixedSize: WidgetStateProperty.all(Size.fromWidth(dropdownWidth)),
      ),
      onSelected: (T? item) {
        if (widget.onChanged != null) {
          widget.onChanged!(item);
        }
        FocusScope.of(context).unfocus();
      },
      dropdownMenuEntries: widget.items.map<DropdownMenuEntry<T>>((T item) {
        final isSelected =
            widget.getValue(widget.selectedItems ?? widget.items.first) ==
            widget.getValue(item);

        return DropdownMenuEntry(
          value: item,
          label: widget.getLabel(item),
          labelWidget: Text(
            widget.getLabel(item),
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        );
      }).toList(),
    );
  }
}
