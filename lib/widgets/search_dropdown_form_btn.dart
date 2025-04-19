import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchDropdownFormBtn extends StatefulWidget {
  const SearchDropdownFormBtn({
    super.key,
    this.onChanged,
    this.validator,
    required this.items,
    this.hintText = 'Select Item',
    this.searchHintText = 'Search for an item...',
    this.enableSearch = true,
    this.initialValue,
    this.readOnly = false,
    this.prefixIcon,
  });

  final bool enableSearch;
  final bool readOnly;
  final String? initialValue;
  final String hintText;
  final String searchHintText;
  final List<String> items;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;
  final Widget? prefixIcon;

  @override
  State<SearchDropdownFormBtn> createState() => _SearchDropdownFormBtnState();
}

class _SearchDropdownFormBtnState extends State<SearchDropdownFormBtn> {
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    setState(() {
      if (widget.items.contains(widget.initialValue)) {
        selectedValue = widget.initialValue;
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dropdownStyle = DropdownStyleData(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      maxHeight: 200.0,
    );
    final searchInputDecoration = InputDecoration(
      isDense: true,
      filled: true,
      fillColor: Theme.of(context).colorScheme.primary.withOpacity(.2),
      focusColor: Theme.of(context).colorScheme.primary.withOpacity(.2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      hintText: widget.searchHintText,
      hintStyle: Theme.of(
        context,
      ).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.normal),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    );

    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2<String>(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: const OutlineInputBorder(),
          prefix: widget.prefixIcon,
          prefixIconConstraints: const BoxConstraints.tightFor(
            height: 15,
            width: 15,
          ),
        ),

        validator: widget.validator,
        isExpanded: true,

        hint: Text(
          widget.hintText,
          style: GoogleFonts.montserrat(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        items:
            widget.items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                )
                .toList(),

        value: selectedValue, //?? widget.initialValue,
        onChanged: _updateValue,
        iconStyleData: IconStyleData(
          iconSize: 30,
          icon: GestureDetector(
            onTap:
                selectedValue == null || widget.readOnly
                    ? null
                    : () => setState(() => _updateValue(selectedValue = null)),
            child:
                selectedValue == null || widget.readOnly
                    ? const Icon(CupertinoIcons.chevron_down_circle)
                    : const Icon(Icons.cancel_outlined),
          ),
        ),
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 4),
        ),
        dropdownStyleData: dropdownStyle,
        menuItemStyleData: MenuItemStyleData(
          height: 40,
          selectedMenuItemBuilder:
              (context, child) => Container(
                color: Theme.of(context).colorScheme.primary.withOpacity(.2),
                child: child,
              ),
        ),
        dropdownSearchData:
            !widget.enableSearch
                ? null
                : DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                    child: TextField(
                      style: Theme.of(context).textTheme.bodySmall,
                      expands: true,
                      maxLines: null,
                      controller: textEditingController,
                      decoration: searchInputDecoration,
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value.toString().toLowerCase().contains(
                      searchValue.trim().toLowerCase(),
                    );
                  },
                ),
        //This to clear the search value when you close the menu
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            textEditingController.clear();
          }
        },
      ),
    );
  }

  void _updateValue(String? val) {
    if (widget.onChanged == null) {
      return;
    }
    setState(() {
      widget.onChanged!(selectedValue = val);
    });
  }
}
