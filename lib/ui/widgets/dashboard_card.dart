import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key, required this.comment});

  final String comment;

  @override
  Widget build(BuildContext context) {
    return Text(comment);
  }
}
