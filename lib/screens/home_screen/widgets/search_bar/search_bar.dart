import 'package:blackout_launcher/screens/home_screen/providers/show_result_provider.dart';
import 'package:blackout_launcher/shared/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/search_query_provider.dart';

class CustomSearchBar extends HookConsumerWidget {
  final FocusNode focusNode;
  final TextEditingController controller;

  const CustomSearchBar({
    Key? key,
    required this.focusNode,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queryProvider = ref.read(searchQueryProvider);
    final settings = ref.watch(userSettingProvider);
    final showResults = ref.read(showResultsProvider);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(showResults
              ? settings.focusedSearchBarOpacity
              : settings.unfocusedSearchBarOpacity),
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          textCapitalization: TextCapitalization.sentences,
          focusNode: focusNode,
          controller: controller,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            prefixIcon: Icon(Icons.search,
                color: !showResults && settings.hideIconsFromUnfocusedSearchBar
                    ? Colors.transparent
                    : null),
            suffixIcon: InkWell(
              onTap: () => Navigator.pushNamed(context, '/settings_screen'),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.menu,
                    size: 20,
                    color:
                        !showResults && settings.hideIconsFromUnfocusedSearchBar
                            ? Colors.transparent
                            : null),
              ),
            ),
            suffix: InkWell(
              onTap: () {
                controller.clear();
                queryProvider.clearQuery();
                focusNode.unfocus();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.cancel, size: 20),
              ),
            ),
            border: InputBorder.none,
          ),
          onTap: () {
            ref.read(showResultsProvider.notifier).state = true;
          },
          onChanged: (value) {
            queryProvider.setQuery(value);
          },
          onTapOutside: (_) {
            focusNode.unfocus();
          },
        ),
      ),
    );
  }
}
