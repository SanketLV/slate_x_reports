import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:slate_x_reports/core/widgets/loading_screen.dart';
import 'package:slate_x_reports/features/auth/state/auth_provider.dart';
import 'package:slate_x_reports/features/auth/ui/pages/login_page.dart';
import 'package:slate_x_reports/features/invoice/ui/pages/invoice_page.dart';
import 'package:slate_x_reports/features/user_profile/ui/pages/user_profile_page.dart';

enum Tab { invoice }

enum ProfileMenuAction { profile, logout }

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Tab _selectedTab = Tab.invoice;
  bool _showProfile = false;

  bool _isTabSelected(Tab t) => !_showProfile && _selectedTab == t;

  static const List<Widget> _widgetOptions = <Widget>[InvoicePage()];

  void _onTabTapped(Tab tab) {
    setState(() {
      _showProfile = false;
      _selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(authProvider).user;
    final authState = ref.watch(authProvider);
    final currentUser = ref.watch(authProvider).restaurantDetails;

    ref.listen(authProvider, (previous, next) {
      if (!next.isLoggedIn && !next.isLoading) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });

    if (authState.isLoading || (authState.isLoggedIn && currentUser == null)) {
      return LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        actions: [
          PopupMenuButton<ProfileMenuAction>(
            tooltip: "Account info",
            offset: Offset(-20, 40),
            elevation: 8,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onSelected: (value) async {
              switch (value) {
                case ProfileMenuAction.profile:
                  setState(() {
                    _showProfile = true;
                  });
                  break;
                case ProfileMenuAction.logout:
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                      title: Text("Confirm Logout"),
                      content: Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8),
                            ),
                          ),
                          child: Text(
                            "Logout",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (shouldLogout == true) {
                    ref.read(authProvider.notifier).logout();
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              //* User profile tile
              PopupMenuItem<ProfileMenuAction>(
                value: ProfileMenuAction.profile,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${currentUser?.firstName} ${currentUser?.lastName}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "${currentUser?.emailAddress ?? ""}",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              PopupMenuDivider(),
              //* Logout tile
              PopupMenuItem<ProfileMenuAction>(
                value: ProfileMenuAction.logout,
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 18, color: Colors.black87),
                    SizedBox(width: 8),
                    Text("Logout", style: TextStyle(color: Colors.black87)),
                  ],
                ),
              ),
            ],
            //* User profile button
            child: Container(
              decoration: BoxDecoration(),
              margin: EdgeInsets.only(right: 18),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Text(
                  "${currentUser?.firstName[0]}${currentUser?.lastName[0]}",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          children: [
            //* Logo section
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                // bottom: 10,
                left: 15,
              ),
              child: SvgPicture.asset(
                "assets/icons/logo.svg",
                height: 50,
                fit: BoxFit.contain,
              ),
            ),

            Divider(color: Colors.grey, endIndent: 40, indent: 40),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //* Invoice tile
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isTabSelected(Tab.invoice)
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Icon(
                          LucideIcons.paperclip,
                          color: _isTabSelected(Tab.invoice)
                              ? Colors.black
                              : Colors.white,
                        ),
                        title: Text(
                          "Invoice",
                          style: TextStyle(
                            color: _isTabSelected(Tab.invoice)
                                ? Colors.black
                                : Colors.white,
                            fontWeight: _isTabSelected(Tab.invoice)
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          _onTabTapped(Tab.invoice);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: _showProfile
          ? UserProfilePage()
          : Center(child: _widgetOptions.elementAt(_selectedTab.index)),
    );
  }
}
