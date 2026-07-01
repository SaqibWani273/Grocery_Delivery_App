import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/categories_screen.dart';
import 'package:grocery_delivery_app/dashboard/dashboard_provider.dart';
import 'package:grocery_delivery_app/dashboard/dashboard_screen.dart';
import 'package:grocery_delivery_app/navigation_provider.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as faf;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NavigationProvider()),
          ChangeNotifierProvider(create: (context) => DashboardProvider()),
        ],
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Read the provider once at the top of build for the controller
    final navProvider = context.read<NavigationProvider>();
    // Watch the index specifically for updating the UI elements
    final selectedIndex = context.watch<NavigationProvider>().selectedIndex;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Swap IndexedStack for PageView
          PageView(
            controller: navProvider.pageController,
            physics:
                const NeverScrollableScrollPhysics(), // Disables finger swiping
            children: const [
              DashboardScreen(),
              CategoriesScreen(),
              DashboardScreen(),
              DashboardScreen(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: context.deviceWidth * 0.18,
                vertical: context.deviceHeight * 0.05,
              ),
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: navItems.map((e) {
                  final index = navItems.indexOf(e);
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () => navProvider.selectedIndex = index,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: isSelected
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryAccent.withAlpha(100),
                            )
                          : null,
                      child: Icon(
                        faf.FaIcon(
                          isSelected ? e.iconFilled : e.icon,
                          color: AppColors.primaryAccent,
                        ).icon,
                        color: isSelected
                            ? AppColors.primaryDark
                            : AppColors.textSecondaryGrey,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           IndexedStack(
//             index: context.watch<NavigationProvider>().selectedIndex,
//             children: [
//               DashboardScreen(),
//               CategoriesScreen(),
//               DashboardScreen(),
//               DashboardScreen(),
//             ],
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               margin: EdgeInsets.symmetric(
//                 horizontal: context.deviceWidth * 0.18,
//                 vertical: context.deviceHeight * 0.05,
//               ),
//               height: 70,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(50)),
//                 boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: navItems.map((e) {
//                   final isSelected =
//                       context.watch<NavigationProvider>().selectedIndex ==
//                       navItems.indexOf(e);
//                   return GestureDetector(
//                     onTap:() =>  context.read<NavigationProvider>().selectedIndex = navItems.indexOf(e),
//                     child: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: isSelected
//                           ? BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: AppColors.primaryAccent.withAlpha(100),
//                             )
//                           : null,
//                       child: Icon(
//                         faf.FaIcon(
//                           isSelected ? e.iconFilled : e.icon,
//                           color: AppColors.primaryAccent,
//                         ).icon,
//                         color: isSelected
//                             ? AppColors.primaryDark
//                             : AppColors.textSecondaryGrey,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class NavItemData {
  final String title;
  final faf.FaIconData icon;
  final faf.FaIconData iconFilled;

  NavItemData({
    required this.title,
    required this.icon,
    required this.iconFilled,
  });
}

final List<NavItemData> navItems = [
  NavItemData(
    title: 'Home',
    icon: faf.FontAwesomeIcons.house,
    iconFilled: faf.FontAwesomeIcons.solidHouse,
  ),
  NavItemData(
    title: 'Categories',
    icon: faf.FontAwesomeIcons.list,
    iconFilled: faf.FontAwesomeIcons.solidRectangleList,
  ),
  NavItemData(
    title: 'Favorites',
    icon: faf.FontAwesomeIcons.heart,
    iconFilled: faf.FontAwesomeIcons.solidHeart,
  ),
  NavItemData(
    title: 'Cart',
    icon: faf.FontAwesomeIcons.cartArrowDown,
    iconFilled: faf.FontAwesomeIcons.cartShopping,
  ),
];
