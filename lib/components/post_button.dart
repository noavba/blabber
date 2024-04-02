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
        borderRadius: BorderRadius.circular(30),
        ),
        margin: const EdgeInsets.only(left:30),
        child: Center(child: 
        Icon(Icons.done, size: 25)
        ),
      ),
    );
  }
}