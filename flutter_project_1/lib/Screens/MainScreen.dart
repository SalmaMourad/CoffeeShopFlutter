import 'package:flutter/material.dart';
import 'package:flutter_project_1/Apis/cart_service.dart';
import 'package:flutter_project_1/Screens/ProfileScreen.dart';
import 'package:flutter_project_1/Screens/HomePageCoffee.dart';
import 'package:flutter_project_1/Screens/CartScreen.dart';
import 'package:flutter_project_1/Widgets/FavoritesDataGetter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static final ValueNotifier<int> switchToTab = ValueNotifier<int>(-1);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    CoffeeScreen(),
    FavoritesDataGetter(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    CartService.refreshItemCount();
    MainScreen.switchToTab.addListener(_onSwitchTab);
  }

  @override
  void dispose() {
    MainScreen.switchToTab.removeListener(_onSwitchTab);
    super.dispose();
  }

  void _onSwitchTab() {
    final index = MainScreen.switchToTab.value;
    if (index >= 0 && index != currentIndex && mounted) {
      setState(() => currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9F7),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF6D4C41),
            unselectedItemColor: const Color(0xFFA1887F),
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            backgroundColor: const Color(0xFFFFF9F7),
            elevation: 0,
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: "Home",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                label: "Favorites",
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart_outlined),
                    ValueListenableBuilder<int>(
                      valueListenable: CartService.itemCount,
                      builder: (context, count, _) {
                        if (count == 0) return const SizedBox.shrink();
                        return Positioned(
                          right: -10,
                          top: -8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8D6E63),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              count > 99 ? '99+' : '$count',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                label: "Cart",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined),
                activeIcon: Icon(Icons.person_2),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
