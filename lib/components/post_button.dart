import 'package:flutter/material.dart';

class PostButton extends StatelessWidget {
  void Function()? onTap;
  PostButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.white54,
        borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.only(left:10),
        child: Center(child: Icon(Icons.done),
        ),
      ),
    );
  }
}