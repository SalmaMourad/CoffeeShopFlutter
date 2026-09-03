import 'package:flutter/material.dart';
import 'package:flutter_project_1/Apis/auth_service.dart';
import 'package:flutter_project_1/Screens/LoginScreen.dart';
import 'package:flutter_project_1/Screens/MainScreen.dart';
import 'package:flutter_project_1/Screens/OrderHistoryScreen.dart';

const Color _cream = Color(0xFFFFF9F7);
const Color _brown = Color(0xFF5D4037);
const Color _darkBrown = Color(0xFF3E2723);
const Color _softBrown = Color(0xFF795548);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _darkBrown,
                ),
              ),
              const SizedBox(height: 20),
              _ProfileHeaderCard(),
              const SizedBox(height: 16),
              const _DeliveryAddressCard(),
              const SizedBox(height: 24),
              const Text(
                'Menu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _darkBrown,
                ),
              ),
              const SizedBox(height: 12),
              _MenuTile(
                icon: Icons.receipt_long_outlined,
                title: 'My Orders',
                subtitle: 'View your previous orders',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OrderHistoryScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _MenuTile(
                icon: Icons.favorite_border,
                title: 'Favorites',
                subtitle: 'View your favorite coffees',
                onTap: () {
                  MainScreen.switchToTab.value = 1;
                },
              ),
              const SizedBox(height: 24),
              _LogoutTile(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.brown.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: _darkBrown,

                child: CircleAvatar(
                  radius: 42,
                  // backgroundColor: const Color(0xFFFADFD5),
                  backgroundColor: const Color(0xFFFADFD5),
                  backgroundImage: const AssetImage('images/delivery.png'),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Salma Mourad',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _darkBrown,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Coffee Lover',
                style: TextStyle(fontSize: 14, color: _softBrown),
              ),
              const SizedBox(height: 18),
              const Divider(height: 1, color: Color(0xFFEFEBE9)),
              const SizedBox(height: 14),
              _InfoRow(
                icon: Icons.email_outlined,
                value: 'salmamouradd992@gmail.com',
              ),
              const SizedBox(height: 10),
              _InfoRow(icon: Icons.phone_outlined, value: '01112345678'),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _EditIconButton(onPressed: () {}),
          ),
        ],
      ),
    );
  }
}

class _EditIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _EditIconButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF6EDE7),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.edit, size: 18, color: _brown),
        ),
      ),
    );
  }
}

class _DeliveryAddressCard extends StatelessWidget {
  const _DeliveryAddressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.brown.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF6EDE7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              size: 24,
              color: _brown,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _darkBrown,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '123 Coffee Street, New Cairo, Cairo, Egypt',
                  style: TextStyle(
                    fontSize: 13,
                    color: _softBrown,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _EditIconButton(onPressed: () {}),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String value;

  const _InfoRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _cream,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: _brown),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: _brown),
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.brown.shade100),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6EDE7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 22, color: _brown),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _darkBrown,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: _softBrown),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: _softBrown),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutTile extends StatelessWidget {
  const _LogoutTile();

  Future<void> _logout(BuildContext context) async {
    await AuthService.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _logout(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.red.shade100),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.logout,
                  size: 22,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB71C1C),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
