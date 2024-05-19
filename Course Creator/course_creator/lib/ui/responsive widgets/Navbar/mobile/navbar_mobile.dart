import 'dart:developer';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

final items = {
  'Create Module': {
    'icon': Icons.list_alt_rounded,
    'onTap': () {
      log('Create Module tapped');
    },
  },
  'Add Link': {
    'icon': Icons.link_rounded,
    'onTap': () {
      log('Add Link tapped');
    },
  },
  'Upload': {
    'icon': Icons.upload_rounded,
    'onTap': () {
      log('Upload tapped');
    },
  },
};

class MobileNavBar extends StatelessWidget {
  const MobileNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 70,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Course Builder",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          NavButton(
            text: '+ Add',
            fontSize: 10,
          ),
        ],
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  final String text;
  final double fontSize;

  const NavButton({
    super.key,
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Row(
            children: [
              Text(
                '+ Add',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w100,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          items: items.entries
              .map<DropdownMenuItem<String>>(
                (MapEntry<String, Map<String, dynamic>> entry) =>
                    DropdownMenuItem<String>(
                  onTap: entry.value["onTap"],
                  value: entry.key,
                  child: Row(
                    children: [
                      Icon(
                        entry.value["icon"],
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          // value: selectedValue,
          onChanged: (value) {},
          buttonStyleData: ButtonStyleData(
            height: 40,
            width: 80,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.redAccent,
            ),
            elevation: 2,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
            ),
            iconSize: 20,
            iconEnabledColor: Colors.white,
            iconDisabledColor: Colors.black,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            offset: const Offset(0, -5),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }
}
