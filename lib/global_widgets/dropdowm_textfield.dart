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
  final String? label;

  const SearchableDropdownFormTextField({
    super.key,
    this.initialValue,
    this.hintText,
    this.suffixIcon = Iconsax.arrow_down_1,
    this.textStyle,
    required this.onChanged,
    required this.items, 
    this.label,
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

    if (_overlayEntry != null && isDropdownVisible) {
      _removeOverlay();
    }

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
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    if (mounted) {
      setState(() {
        isDropdownVisible = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _focusNode.unfocus();
                  _removeOverlay();
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              width: size.width,
              left: offset.dx,
              top: offset.dy + size.height + 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isSelected = item == searchController.text;
                      
                      return InkWell(
                        onTap: () {
                          searchController.text = item;
                          widget.onChanged?.call(item);
                          _focusNode.unfocus();
                          _removeOverlay();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          color: isSelected
                              ? ColorTheme.desaiGreen.withOpacity(0.1)
                              : Colors.white,
                          child: Text(
                            item,
                            style: GLTextStyles.manropeStyle(
                              size: 14.sp,
                              weight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? ColorTheme.desaiGreen
                                  : const Color(0xFF575757),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Text(
                widget.label!,
                style: GLTextStyles.manropeStyle(
                  color: ColorTheme.blue,
                  size: 14.sp,
                  weight: FontWeight.w500,
                ),
              ),
            ),
          SizedBox(
            height: 38.sp,
            child: TextField(
              controller: searchController,
              focusNode: _focusNode,
              onTap: _toggleDropdown,
              cursorColor: ColorTheme.desaiGreen,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: GLTextStyles.manropeStyle(
                  size: 14.sp,
                  weight: FontWeight.w400,
                  color: const Color(0xFF8C8E90),
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: isDropdownVisible ? 0.5 : 0,
                  child: Icon(
                    widget.suffixIcon,
                    size: 15.sp,
                    color: ColorTheme.blue,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Color(0xFFD5D7DA)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Color(0xFFD5D7DA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: ColorTheme.desaiGreen),
                ),
              ),
              style: widget.textStyle ??
                  GLTextStyles.manropeStyle(
                    weight: FontWeight.w400,
                    size: 14.sp,
                    color: const Color(0xFF575757),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

