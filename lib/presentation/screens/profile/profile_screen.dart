import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profiles Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildProfileItem('Emenalo', 'assets/images/Rectangle 2.png', isSelected: true),
                        _buildProfileItem('Onyeka', 'assets/images/Rectangle 3.png'),
                        _buildProfileItem('Thelma', 'assets/images/Rectangle 4.png'),
                        _buildProfileItem('Kids', 'assets/images/Rectangle 5.png'),
                        _buildAddProfileItem(context),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Vector.png',
                          width: 14,
                          height: 14,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Manage Profiles',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tell friends about Netflix banner section
              Container(
                color: const Color(0xFF1E1E1E),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Tell friends about Netflix.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sit quam dui, vivamus bibendum ut. A morbi mi tortor ut felis non accumsan accumsan quis. Massa,',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Copy Link Row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 38,
                            color: Colors.black,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: const RoundedRectangleBorder(),
                          ),
                          child: const Text(
                            'Copy Link',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Social Icons Row matching Figma exact icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset('assets/images/icon_whatsapp.png', width: 36, height: 36),
                        _buildDivider(),
                        Image.asset('assets/images/icon_facebook.png', width: 36, height: 36),
                        _buildDivider(),
                        Image.asset('assets/images/icon_gmail.png', width: 36, height: 36),
                        _buildDivider(),
                        Image.asset('assets/images/icon_more.png', width: 36, height: 36),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Options List Section
              Container(
                color: Colors.black,
                child: Column(
                  children: [
                    // My List option item
                    Container(
                      color: const Color(0xFF1E1E1E),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: const Row(
                        children: [
                          Icon(Icons.check, color: Colors.white, size: 24),
                          SizedBox(width: 14),
                          Text(
                            'My List',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    _buildOptionTile('App Settings', onTap: () {}),
                    _buildOptionTile('Account', onTap: () {}),
                    _buildOptionTile('Help', onTap: () {}),
                    _buildOptionTile('Sign Out', onTap: () {
                      Navigator.pushReplacementNamed(context, '/LogoScreen');
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(String name, String imageAsset, {bool isSelected = false}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Image.asset(
              imageAsset,
              width: 58,
              height: 58,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[400],
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildAddProfileItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/LogoScreen');
      },
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white54, width: 1.2),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 6),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 32,
      width: 1,
      color: Colors.white24,
    );
  }

  Widget _buildOptionTile(String title, {required VoidCallback onTap}) {
    return ListTile(
      dense: true,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
