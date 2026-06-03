import 'package:flutter/material.dart';

import '../../profile/pages/profile_page.dart';
import '../screens/exam_list_screen.dart';
import '../screens/history_screen.dart';
import '../screens/home_screen.dart';
import '../theme/pocket_colors.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 1});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.initialIndex;

  final _pages = const <Widget>[
    ProfilePage(),
    HomeScreen(),
    ExamListScreen(),
    HistoryScreen(),
  ];

  void _onTap(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: _PocketBottomNav(index: _index, onTap: _onTap),
    );
  }
}

class _PocketBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const _PocketBottomNav({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = <IconData>[
      Icons.person,
      Icons.home_rounded,
      Icons.description_outlined,
      Icons.history,
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: PocketColors.cardBorder, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final selected = i == index;
            return InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => onTap(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: Container(
                  decoration: selected
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: PocketColors.lightBlue.withOpacity(0.35),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        )
                      : null,
                  child: Icon(
                    items[i],
                    size: 30,
                    color: PocketColors.navy,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
