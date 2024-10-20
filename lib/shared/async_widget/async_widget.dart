import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({super.key, required this.value, required this.data});

  // input async value
  final AsyncValue<T> value;

  // output builder function
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () {
        // Check if the provider has existing data.
        // This is the data the state had before reloading,
        // added through .loading().copyWithPrevious(state);
        if (value.hasValue) {
          return data(value.value as T);
        }
        return const Center(child: CircularProgressIndicator());
      },
      error: (e, _) => Center(
        child: Text(
          e.toString(),
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.red),
        ),
      ),
    );
  }
}
