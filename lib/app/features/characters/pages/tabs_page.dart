import 'package:flutter/material.dart';
import 'home_page.dart';
import 'favorites_page.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dragon Ball'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Personagens'),
              Tab(icon: Icon(Icons.favorite), text: 'Favoritos'),
            ],
          ),
        ),
        body: const TabBarView(children: [HomePage(), FavoritesPage()]),
      ),
    );
  }
}
