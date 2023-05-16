import 'package:expenses2/widgets/chart/chart.dart';
import 'package:expenses2/widgets/expenses_list/expenses_list.dart';
import 'package:expenses2/models/expense.dart';
import 'package:expenses2/widgets/expenses_list/new_expens.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _regiteredExpenses = [
    Expense(
        title: "Fluttre Course ",
        amount: 26.5,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Cinema ",
        amount: 15.12,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: ((ctx) => NewExpense(
            onAddExpense: _addExpense,
          )),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _regiteredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _regiteredExpenses.indexOf(expense);
    setState(() {
      _regiteredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Expense deleted'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _regiteredExpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('No expense is found try adding some'),
    );

    if (_regiteredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _regiteredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Expense Tracker'), actions: [
        IconButton(
            onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
      ]),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _regiteredExpenses),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _regiteredExpenses)),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
