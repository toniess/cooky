import 'package:cooky/core/models/area.dart';
import 'package:cooky/core/models/category.dart';
import 'package:cooky/core/models/ingredient.dart';
import 'package:cooky/core/services/meal_db/abstract_meal_db_service.dart';
import 'package:cooky/features/search/bloc/search_state.dart';
import 'package:cooky/main.dart';
import 'package:cooky/theme/colors.dart';
import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  final SearchFilters initialFilters;
  final Function(SearchFilters) onFiltersChanged;

  const FiltersScreen({
    super.key,
    required this.initialFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  late SearchFilters _currentFilters;
  final AbstractMealDbService _mealDbService = getIt
      .get<AbstractMealDbService>();

  List<Category> _categories = [];
  List<Area> _areas = [];
  List<Ingredient> _ingredients = [];
  List<Ingredient> _filteredIngredients = [];
  bool _isLoading = true;
  final TextEditingController _ingredientSearchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentFilters = widget.initialFilters;
    _ingredientSearchController.addListener(_filterIngredients);
    _loadFilterData();
  }

  @override
  void dispose() {
    _ingredientSearchController.dispose();
    super.dispose();
  }

  Future<void> _loadFilterData() async {
    try {
      final results = await Future.wait([
        _mealDbService.getCategories(),
        _mealDbService.getAreas(),
        _mealDbService.getIngredients(),
      ]);

      setState(() {
        _categories = results[0] as List<Category>;
        _areas = results[1] as List<Area>;
        _ingredients = results[2] as List<Ingredient>;
        _filteredIngredients = _ingredients;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading filters: $e')));
      }
    }
  }

  void _updateFilters(SearchFilters newFilters) {
    setState(() {
      _currentFilters = newFilters;
    });
    widget.onFiltersChanged(newFilters);
  }

  void _clearAllFilters() {
    _updateFilters(const SearchFilters());
  }

  void _filterIngredients() {
    final query = _ingredientSearchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredIngredients = _ingredients;
      } else {
        _filteredIngredients = _ingredients
            .where(
              (ingredient) => ingredient.name.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Filters'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.neutralGrayDark,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _currentFilters.hasActiveFilters
                ? _clearAllFilters
                : null,
            child: Text(
              'Clear',
              style: TextStyle(
                color: _currentFilters.hasActiveFilters
                    ? AppColors.accentBrown
                    : AppColors.neutralGrayMedium,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Filter
                  _buildSectionTitle(
                    'Categories (${_currentFilters.selectedCategories.length})',
                  ),
                  const SizedBox(height: 8),
                  _buildCategoryFilter(),
                  const SizedBox(height: 24),

                  // Area Filter
                  _buildSectionTitle(
                    'Cuisines (${_currentFilters.selectedAreas.length})',
                  ),
                  const SizedBox(height: 8),
                  _buildAreaFilter(),
                  const SizedBox(height: 24),

                  // Ingredients Filter
                  _buildSectionTitle('Ingredients'),
                  const SizedBox(height: 8),
                  _buildIngredientsFilter(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.neutralGrayDark,
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories
          .map(
            (category) => _buildFilterChip(
              label: category.name,
              isSelected: _currentFilters.selectedCategories.contains(
                category.name,
              ),
              onSelected: () {
                final newCategories = List<String>.from(
                  _currentFilters.selectedCategories,
                );
                if (newCategories.contains(category.name)) {
                  newCategories.remove(category.name);
                } else {
                  newCategories.add(category.name);
                }
                _updateFilters(
                  _currentFilters.copyWith(selectedCategories: newCategories),
                );
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildAreaFilter() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _areas
          .map(
            (area) => _buildFilterChip(
              label: area.name,
              isSelected: _currentFilters.selectedAreas.contains(area.name),
              onSelected: () {
                final newAreas = List<String>.from(
                  _currentFilters.selectedAreas,
                );
                if (newAreas.contains(area.name)) {
                  newAreas.remove(area.name);
                } else {
                  newAreas.add(area.name);
                }
                _updateFilters(
                  _currentFilters.copyWith(selectedAreas: newAreas),
                );
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildIngredientsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select ingredients (${_currentFilters.selectedIngredients.length})',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.neutralGrayMedium),
        ),
        const SizedBox(height: 8),
        // Search field for ingredients
        TextField(
          controller: _ingredientSearchController,
          decoration: InputDecoration(
            hintText: 'Search ingredients...',
            hintStyle: TextStyle(color: AppColors.neutralGrayMedium),
            prefixIcon: Icon(Icons.search, color: AppColors.neutralGrayDark),
            suffixIcon: _ingredientSearchController.text.trim().isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: AppColors.neutralGrayDark),
                    onPressed: () {
                      _ingredientSearchController.clear();
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.neutralGrayLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.neutralGrayLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.accentBrown),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutralGrayLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _filteredIngredients.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: AppColors.neutralGrayMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No ingredients found',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.neutralGrayMedium,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredIngredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = _filteredIngredients[index];
                    final isSelected = _currentFilters.selectedIngredients
                        .contains(ingredient.name);

                    return ListTile(
                      dense: true,
                      title: Text(
                        ingredient.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.accentBrown
                              : AppColors.neutralGrayDark,
                        ),
                      ),
                      leading: Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          final newIngredients = List<String>.from(
                            _currentFilters.selectedIngredients,
                          );
                          if (value == true) {
                            newIngredients.add(ingredient.name);
                          } else {
                            newIngredients.remove(ingredient.name);
                          }
                          _updateFilters(
                            _currentFilters.copyWith(
                              selectedIngredients: newIngredients,
                            ),
                          );
                        },
                        activeColor: AppColors.accentBrown,
                      ),
                      onTap: () {
                        final newIngredients = List<String>.from(
                          _currentFilters.selectedIngredients,
                        );
                        if (isSelected) {
                          newIngredients.remove(ingredient.name);
                        } else {
                          newIngredients.add(ingredient.name);
                        }
                        _updateFilters(
                          _currentFilters.copyWith(
                            selectedIngredients: newIngredients,
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.accentBrown.withValues(alpha: 0.2),
      checkmarkColor: AppColors.accentBrown,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.accentBrown : AppColors.neutralGrayDark,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
