import 'package:blackout_launcher/screens/home_screen/providers/show_result_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/search_query_provider.dart';

class CustomSearchBar extends HookConsumerWidget {
  final FocusNode focusNode;

  const CustomSearchBar({
    Key? key,
    required this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final queryProvider = ref.read(searchQueryProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ref.read(showResultsProvider)
              ? Theme.of(context).colorScheme.surface
              : Colors.transparent,
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
            prefixIcon: const Icon(Icons.search),
            suffixIcon: InkWell(
              onTap: () => Navigator.pushNamed(context, '/settings_screen'),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.menu, size: 20),
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
