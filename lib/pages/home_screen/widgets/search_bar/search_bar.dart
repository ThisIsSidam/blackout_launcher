import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../router/app_router.dart';
import '../../providers/search_query_provider.dart';

class CustomSearchBar extends HookConsumerWidget {
  final FocusNode focusNode;
  final bool isFocused;

  const CustomSearchBar({
    Key? key,
    required this.focusNode,
    required this.isFocused,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final queryProvider = ref.read(searchQueryProvider);

    // Use effect for cleanup (similar to dispose)
    useEffect(() {
      return () => controller.dispose();
    }, [controller]);

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isFocused ? Colors.white10 : Colors.transparent,
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
              onTap: () => context.go(AppRoute.settings.path),
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
          onChanged: (value) {
            queryProvider.setQuery(value);
          },
          onTapOutside: (_) {
            // We don't clear queryProvider here because the user may want to
            // click on an app, clearing would remove search results.
            controller.clear();
            focusNode.unfocus();
          },
        ),
      ),
    );
  }
}
