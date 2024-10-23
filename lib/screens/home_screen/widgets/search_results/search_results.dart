import 'package:blackout_launcher/shared/async_widget/async_widget.dart';
import 'package:blackout_launcher/shared/providers/apps_provider.dart';
import 'package:blackout_launcher/shared/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:installed_apps/app_info.dart';

import '../../../../shared/providers/hidden_apps_provider.dart';
import '../../providers/search_query_provider.dart';
import '../app_launcher/app_launcher.dart';

class SearchResults extends ConsumerWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('searchResult built');
    final hiddenApps = ref.watch(hiddenAppsProvider).hiddenApps;
    final query = ref.watch(searchQueryProvider).query;

    return AsyncValueWidget<List<AppInfo>>(
        value: ref.read(appListProvider),
        data: (allApps) {
          final apps = allApps
              .where((app) => !hiddenApps.contains(app.packageName))
              .toList();

          // Using a column because more types of results would be added.
          // Also the child normally took entire space which wasn't good.
          // With this it now takes only necessary space.
          return Column(
            children: [
              _buildMathResult(context, query),
              const SizedBox(height: 8),
              Flexible(child: _buildResultApps(context, ref, apps)),
            ],
          );
        });
  }

  Widget _buildMathResult(BuildContext context, String query) {
    final double? mathResult = StringCalculator.calculate(query);
    if (mathResult != null) {
      return DecoratedBox(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(25)),
          child: SizedBox(
            height: 60,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '= ${mathResult.toString()}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )),
            ),
          ));
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildResultApps(
      BuildContext context, WidgetRef ref, List<AppInfo> apps) {
    final settings = ref.read(userSettingProvider);
    final query = ref.read(searchQueryProvider).query;

    final List<AppInfo> filteredApps = apps
        .where((app) => app.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return DecoratedBox(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: filteredApps.isEmpty
            ? const SizedBox(
                height: 45,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("No apps found!"),
                    )),
              )
            : GridView.count(
                crossAxisCount: settings.numberOfColumns.toInt(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 16,
                children: [
                  for (var app in filteredApps)
                    AppLauncher(
                      app: app,
                      launcherType: LauncherType.iconAndText,
                      iconSize: settings.iconSize,
                    ),
                ],
              ),
      ),
    );
  }
}

class StringCalculator {
  static double? calculate(String expression) {
    try {
      // Remove all spaces from the expression
      expression = expression.replaceAll(' ', '');

      // Replace 'x' or 'X' with '*' for multiplication
      expression = expression.toLowerCase().replaceAll('x', '*');

      // If expression is empty or contains invalid characters, return null
      if (expression.isEmpty || !_isValidExpression(expression)) {
        return null;
      }

      // Split the expression into tokens
      List<String> tokens = _tokenize(expression);

      // Convert infix notation to postfix (Reverse Polish Notation)
      List<String> postfix = _infixToPostfix(tokens);

      // Evaluate the postfix expression
      return _evaluatePostfix(postfix);
    } catch (e) {
      return null;
    }
  }

  // Check if the expression is valid and contains at least one complete mathematical operation
  static bool _isValidExpression(String expression) {
    // Check for valid characters first
    if (!RegExp(r'^[0-9+\-*/.()\s]+$').hasMatch(expression)) {
      return false;
    }

    // Check if it contains at least one operator
    bool hasOperator = RegExp(r'[+\-*/]').hasMatch(expression);
    if (!hasOperator) {
      return false;
    }

    // Check for invalid operator patterns
    if (RegExp(r'[+\-*/]{2,}').hasMatch(expression)) {
      // Multiple operators in sequence
      return false;
    }

    if (RegExp(r'^[+\-*/]').hasMatch(expression)) {
      // Starts with operator
      return false;
    }

    if (RegExp(r'[+\-*/]$').hasMatch(expression)) {
      // Ends with operator
      return false;
    }

    // Check for balanced parentheses and valid content inside them
    int parenthesesCount = 0;
    for (int i = 0; i < expression.length; i++) {
      if (expression[i] == '(') {
        parenthesesCount++;
        // Check if there's nothing or just an operator after opening parenthesis
        if (i + 1 >= expression.length ||
            RegExp(r'[+\-*/]').hasMatch(expression[i + 1])) {
          return false;
        }
      } else if (expression[i] == ')') {
        parenthesesCount--;
        if (parenthesesCount < 0) {
          return false;
        }
        // Check if there was a number before closing parenthesis
        if (i > 0 && !RegExp(r'[0-9)]').hasMatch(expression[i - 1])) {
          return false;
        }
      }
    }

    // Check for unbalanced parentheses
    if (parenthesesCount != 0) {
      return false;
    }

    // Ensure there's at least one number on either side of each operator
    List<String> parts = expression.split(RegExp(r'[+\-*/]'));
    for (String part in parts) {
      if (part.isEmpty) {
        return false;
      }
      // Check if each part (after removing parentheses) can be parsed as a number
      String cleanPart = part.replaceAll(RegExp(r'[()]'), '');
      if (cleanPart.isEmpty || double.tryParse(cleanPart) == null) {
        return false;
      }
    }

    return true;
  }

  // Split expression into tokens
  static List<String> _tokenize(String expression) {
    List<String> tokens = [];
    String currentNumber = '';

    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];

      if (RegExp(r'[0-9.]').hasMatch(char)) {
        currentNumber += char;
      } else {
        if (currentNumber.isNotEmpty) {
          tokens.add(currentNumber);
          currentNumber = '';
        }
        tokens.add(char);
      }
    }

    if (currentNumber.isNotEmpty) {
      tokens.add(currentNumber);
    }

    return tokens;
  }

  // Convert infix notation to postfix notation
  static List<String> _infixToPostfix(List<String> tokens) {
    List<String> output = [];
    List<String> operators = [];

    Map<String, int> precedence = {
      '+': 1,
      '-': 1,
      '*': 2,
      '/': 2,
    };

    for (String token in tokens) {
      if (RegExp(r'^[0-9.]+$').hasMatch(token)) {
        output.add(token);
      } else if (token == '(') {
        operators.add(token);
      } else if (token == ')') {
        while (operators.isNotEmpty && operators.last != '(') {
          output.add(operators.removeLast());
        }
        if (operators.isNotEmpty && operators.last == '(') {
          operators.removeLast();
        }
      } else if (precedence.containsKey(token)) {
        while (operators.isNotEmpty &&
            operators.last != '(' &&
            precedence[operators.last]! >= precedence[token]!) {
          output.add(operators.removeLast());
        }
        operators.add(token);
      }
    }

    while (operators.isNotEmpty) {
      output.add(operators.removeLast());
    }

    return output;
  }

  // Evaluate postfix expression
  static double? _evaluatePostfix(List<String> postfix) {
    List<double> stack = [];

    for (String token in postfix) {
      if (RegExp(r'^[0-9.]+$').hasMatch(token)) {
        stack.add(double.parse(token));
      } else {
        if (stack.length < 2) return null;

        double b = stack.removeLast();
        double a = stack.removeLast();

        switch (token) {
          case '+':
            stack.add(a + b);
            break;
          case '-':
            stack.add(a - b);
            break;
          case '*':
            stack.add(a * b);
            break;
          case '/':
            if (b == 0) return null; // Handle division by zero
            stack.add(a / b);
            break;
        }
      }
    }

    return stack.length == 1 ? stack.first : null;
  }
}
