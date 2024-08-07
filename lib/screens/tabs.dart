import 'package:flutter/material.dart';
import 'package:meals_app/screens/filters.dart';
import '../screens/categories.dart';
import '../screens/meals.dart';
import '../widgets/main_drawer.dart';
import '../providers/meals_provider.dart';
import '../providers/favorites_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filters_provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false
};

class TabScreen extends ConsumerStatefulWidget {
  const TabScreen({super.key});

  @override
  ConsumerState<TabScreen> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends ConsumerState<TabScreen> {
  int _selectedPageIndex = 0;

  void _setScreen(String id) {
    Navigator.pop(context);
    if (id == 'Filters') {
      Navigator.push<Map<Filter, bool>>(
          context, MaterialPageRoute(builder: (ctx) => const FiltersScreen()));
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMeals = ref.watch(favoriteMealsProvider);
    final meals = ref.watch(mealsProvider);
    final activeFilters = ref.watch(filtersProvider);
    final availableMeals = ref.watch(filteredMealsProvider);
    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';
    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: favoriteMeals,
      );
      activePageTitle = 'Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
