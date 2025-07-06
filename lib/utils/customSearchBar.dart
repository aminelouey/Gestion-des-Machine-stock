
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Customsearchbar extends StatelessWidget {
  const Customsearchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromRGBO(238, 238, 238, 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/Search.svg'),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for task',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SvgPicture.asset('assets/icons/Close Square.svg', height: 20),
        ],
      ),
    );
  }
}
