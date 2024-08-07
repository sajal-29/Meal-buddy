import 'package:flutter/material.dart';
import 'package:meals_app/providers/favorites_provider.dart';
import '../models/meal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealDetails extends ConsumerWidget {
  const MealDetails({super.key, required this.meal});
  final Meal meal;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritemMeals = ref.watch(favoriteMealsProvider);

    final isFavorite = favoritemMeals.contains(meal);
    return Scaffold(
        appBar: AppBar(
          title: Text(meal.title),
          actions: [
            IconButton(
              onPressed: () {
                final wasAdded = ref
                    .read(favoriteMealsProvider.notifier)
                    .toggleMealFavoriteStatus(meal);
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(wasAdded
                        ? 'Meal Added as a Favorite.'
                        : 'Meal Removed.')));
              },
              icon: AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(-0.5, 0.0),
                              end: const Offset(0.0, 0.0))
                          .animate(animation),
                      child: child,
                    );
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(isFavorite),
                  )),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: meal.title,
                child: Image.network(
                  meal.imageUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                'Ingredients',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 14,
              ),
              for (final ingredient in meal.ingredients)
                Text(
                  ingredient,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              const SizedBox(
                height: 24,
              ),
              Text(
                'Steps',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
              for (final step in meal.steps)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    step,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
            ],
          ),
        ));
  }
}
