import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    @required this.photoUrl,
    @required this.radius,
    @required this.onPressed,
    this.borderRadius = 0,
    this.borderColor = Colors.white,
  });

  final String photoUrl;
  final double radius;
  final VoidCallback onPressed;
  final double borderRadius;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: borderColor, // border color
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(borderRadius),
      child: InkWell(
        onTap: onPressed,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey[400],
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
          child: photoUrl == null
              ? Icon(
                  Icons.person,
                  size: radius,
                  color: Colors.grey[600],
                )
              : null,
        ),
      ),
    );
  }
}
