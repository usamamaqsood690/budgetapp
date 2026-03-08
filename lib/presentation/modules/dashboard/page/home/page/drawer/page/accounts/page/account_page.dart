import 'package:flutter/material.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "Accounts"),
    );
  }
}
