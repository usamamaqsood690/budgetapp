import 'package:flutter/foundation.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });
}

class RecentExpenseController extends ChangeNotifier {
  final List<Expense> _recentExpenses = [];

  List<Expense> get recentExpenses =>
      List.unmodifiable(_recentExpenses)
        ..sort((a, b) => b.date.compareTo(a.date));

  void addExpense(Expense expense) {
    _recentExpenses.add(expense);
    notifyListeners();
  }

  void removeExpense(String id) {
    _recentExpenses.removeWhere((expense) => expense.id == id);
    notifyListeners();
  }

  void clearExpenses() {
    _recentExpenses.clear();
    notifyListeners();
  }
}
