import 'package:desaihomes_crm_application/core/constants/colors.dart';
import 'package:desaihomes_crm_application/core/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class SearchableDropdownFormTextField extends StatefulWidget {
  final String? initialValue;
  final String? hintText;
  final IconData? suffixIcon;
  final TextStyle? textStyle;
  final Function(String?)? onChanged;
  final List<String> items;

  const SearchableDropdownFormTextField({
    super.key,
    this.initialValue,
    this.hintText,
    this.suffixIcon = Iconsax.arrow_down_1,
    this.textStyle,
    required this.onChanged,
    required this.items,
  });

  @override
  State<SearchableDropdownFormTextField> createState() =>
      _SearchableDropdownFormTextFieldState();
}

class _SearchableDropdownFormTextFieldState
    extends State<SearchableDropdownFormTextField> {
  late List<String> filteredItems;
  late TextEditingController searchController;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool isDropdownVisible = false;
  // Add focus node to track focus state
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
    searchController = TextEditingController(text: widget.initialValue);

    // Add listener for real-time search
    searchController.addListener(() {
      _filterItems(searchController.text);
    });

    // Add focus listener to handle outside taps
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    if (filteredItems.isNotEmpty) {
      if (!isDropdownVisible) _showOverlay();
      _updateOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _toggleDropdown() {
    if (isDropdownVisible) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    if (overlay != null) {
      _overlayEntry = _createOverlayEntry();
      overlay.insert(_overlayEntry!);
      setState(() {
        isDropdownVisible = true;
      });
    }
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      isDropdownVisible = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Add a transparent overlay to detect taps outside
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _focusNode.unfocus();
                _removeOverlay();
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            width: size.width,
            left: offset.dx,
            top: offset.dy + size.height + 4,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(8),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: filteredItems.length == 1
                      ? 56.0
                      : (filteredItems.length == 2 ? 112.0 : 180.0),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return ListTile(
                      tileColor: Colors.white,
                      title: Text(item),
                      onTap: () {
                        searchController.text = item;
                        widget.onChanged?.call(item);
                        _focusNode.unfocus();
                        _removeOverlay();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        height: 38.sp,
        width: double.infinity,
        child: TextField(
          cursorColor: ColorTheme.desaiGreen,
          controller: searchController,
          focusNode: _focusNode,
          onTap: _toggleDropdown,
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(widget.suffixIcon, size: 15.sp),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffD5D7DA)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xffD5D7DA)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
          style: widget.textStyle ??
              GLTextStyles.manropeStyle(
                weight: FontWeight.w400,
                size: 14.sp,
                color: const Color.fromARGB(255, 87, 87, 87),
              ),
        ),
      ),
    );
  }
}
