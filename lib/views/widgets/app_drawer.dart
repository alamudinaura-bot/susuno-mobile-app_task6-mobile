import 'package:flutter/material.dart';

const kSusunoGreen = Color(0xFF5B6A32);

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: kSusunoGreen),
            child: Row(
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.inventory_2, color: kSusunoGreen),
                ),
                SizedBox(width: 12),
                Text(
                  'SUSUNO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
          ),
          const ListTile(leading: Icon(Icons.inventory), title: Text('Stock')),
          const ListTile(
            leading: Icon(Icons.qr_code_scanner),
            title: Text('Scanner'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          const ListTile(leading: Icon(Icons.logout), title: Text('Log out')),
        ],
      ),
    );
  }
}
