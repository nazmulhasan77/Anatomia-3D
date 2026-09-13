import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../services/anatomy_data_service.dart';
import '../../widgets/glass_card.dart';

enum SearchFilter { all, organs, functions, diseases }

class SearchItem {
  final String title;
  final String category;
  final String organId;
  final String type; // 'organ', 'function', 'disease', 'system'
  final IconData icon;
  final Color color;

  const SearchItem({
    required this.title,
    required this.category,
    required this.organId,
    required this.type,
    required this.icon,
    required this.color,
  });
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  SearchFilter _selectedFilter = SearchFilter.all;
  String _query = '';
  List<SearchItem> _allItems = [];

  @override
  void initState() {
    super.initState();
    _buildSearchIndex();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim();
      });
    });
  }

  void _buildSearchIndex() {
    final list = <SearchItem>[];

    // Add organs
    for (final organ in AnatomyDataService.organs) {
      list.add(SearchItem(
        title: organ.name,
        category: 'Organ • ${organ.category}',
        organId: organ.id,
        type: 'organ',
        icon: Icons.bubble_chart_rounded,
        color: AppColors.secondaryCyan,
      ));

      list.add(SearchItem(
        title: '${organ.name} Function',
        category: 'Function (${organ.name})',
        organId: organ.id,
        type: 'function',
        icon: Icons.autorenew_rounded,
        color: const Color(0xFFFF9100),
      ));

      for (final d in organ.diseases) {
        list.add(SearchItem(
          title: d,
          category: 'Disease • ${organ.name}',
          organId: organ.id,
          type: 'disease',
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFFF5252),
        ));
      }
    }

    // Add Body systems
    for (final sys in AnatomyDataService.bodySystems) {
      list.add(SearchItem(
        title: sys.name,
        category: 'Body System • ${sys.organs.length} Organs',
        organId: sys.organs.first,
        type: 'system',
        icon: Icons.accessibility_new_rounded,
        color: Color(sys.primaryColorHex),
      ));
    }

    _allItems = list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SearchItem> get _filteredResults {
    var list = _allItems;

    // Filter by type
    if (_selectedFilter == SearchFilter.organs) {
      list = list.where((item) => item.type == 'organ').toList();
    } else if (_selectedFilter == SearchFilter.functions) {
      list = list.where((item) => item.type == 'function').toList();
    } else if (_selectedFilter == SearchFilter.diseases) {
      list = list.where((item) => item.type == 'disease').toList();
    }

    // Filter by text query
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((item) {
        return item.title.toLowerCase().contains(q) ||
            item.category.toLowerCase().contains(q);
      }).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final results = _filteredResults;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Search Bar Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search organs, functions, diseases...',
                          hintStyle: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 14),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.secondaryCyan),
                          suffixIcon: _query.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.cancel_rounded, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.secondaryCyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Category Filter Chips (All, Organs, Functions, Diseases)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  _buildFilterChip('All', SearchFilter.all),
                  const SizedBox(width: 8),
                  _buildFilterChip('Organs', SearchFilter.organs),
                  const SizedBox(width: 8),
                  _buildFilterChip('Functions', SearchFilter.functions),
                  const SizedBox(width: 8),
                  _buildFilterChip('Diseases', SearchFilter.diseases),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 3. Search Results List
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: isDark ? Colors.white24 : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No anatomical matching results for "$_query"',
                            style: TextStyle(
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: results.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = results[index];
                        return GlassCard(
                          onTap: () {
                            if (item.type == 'disease') {
                              context.push('/disease/${item.organId}');
                            } else {
                              context.push('/organ/${item.organId}');
                            }
                          },
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: item.color.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: item.color.withOpacity(0.35)),
                                ),
                                child: Icon(item.icon, color: item.color, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.category,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? AppColors.textSecondaryDark
                                            : AppColors.textSecondaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: AppColors.secondaryCyan,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, SearchFilter filter) {
    final isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.white10,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.secondaryCyan : Colors.white24,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}
