import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget{
  final bool isLiked;
  void Function()? onTap;
  LikeButton({required this.isLiked, required this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.yellow : Colors.grey,
        size:30,
      ),
    );
  }
}