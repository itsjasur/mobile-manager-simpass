import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  List menuItems = [
    {
      'titleIndex': 0,
      'icon': Icons.home_outlined,
      'path': '/home',
    },
    {
      'titleIndex': 1,
      'icon': Icons.person_outline,
      'path': '/profile',
    },
    {
      'titleIndex': 2,
      'icon': Icons.description_outlined,
      'path': '/plans',
    },
    {
      'titleIndex': 3,
      'icon': Icons.assignment_outlined,
      'path': '/rental-forms',
    },
    {
      'titleIndex': 4,
      'icon': Icons.checklist_outlined,
      'path': '/applications',
    },
    {
      'titleIndex': 5,
      'icon': Icons.download_outlined,
      'path': '/download-forms',
    },
  ];

  Widget itemBuilder(index) {
    String currentPath = ModalRoute.of(context)?.settings.name ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () {
          Navigator.of(context).pushReplacementNamed(menuItems[index]['path']);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: currentPath == menuItems[index]['path']
              ? BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          child: Row(
            children: [
              Icon(
                menuItems[index]['icon'],
                color: Theme.of(context).colorScheme.onPrimary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                sideMenuNames[menuItems[index]['titleIndex']],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              ...List.generate(menuItems.length, (index) => itemBuilder(index)),
            ],
          ),
        ),
      ),
    );
  }
}