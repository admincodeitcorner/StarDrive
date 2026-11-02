import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    super.key,
    required this._selectedIndex, required this.onTap,

  });

  final int _selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (index) {
        onTap(index);
      },
      backgroundColor: Colors.white,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          label: 'Ride Request',
          icon: Icon(Icons.directions_car),
        ),
        BottomNavigationBarItem(
          label: 'Demand',
          icon: Icon(Icons.local_fire_department_outlined),
        ),
        BottomNavigationBarItem(
          label: 'Performance',
          icon: Icon(Icons.trending_up),
        ),
        BottomNavigationBarItem(
          label: 'Wallet',
          icon: Icon(Icons.account_balance_wallet_outlined),
        ),
      ],
    );
  }
}

