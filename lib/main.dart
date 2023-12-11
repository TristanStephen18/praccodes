import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class Expense {
  String id;
  String description;
  double amount;
  DateTime date;

  Expense({required this.id, required this.description, required this.amount, required this.date});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Expense> expenses = [];
  int _uniqueId = 1;

  void _addExpense(String description, String amount, DateTime date) {
    // Validate if the same entry already exists
    if (expenses.any((expense) => expense.description == description)) {
      _showSnackbar(context, 'An entry with the same description already exists.');
      return;
    }

    // Validate if the amount contains only digits
    if (double.tryParse(amount) == null) {
      _showSnackbar(context, 'Amount should only contain numbers.');
      return;
    }

    double parsedAmount = double.parse(amount);
    String id = '$_uniqueId'; // Unique ID for each entry
    _uniqueId++;
    expenses.add(Expense(id: id, description: description, amount: parsedAmount, date: date));
    Navigator.of(context).pop(); // Dismiss the modal
    setState(() {}); // Update the UI
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showAddExpenseModal() async {
    TextEditingController descriptionController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    DateTime currentDate = DateTime.now();

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Expense',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              SizedBox(height: 16.0),
              Text('Date: ${DateFormat.yMd().format(currentDate)}'),
              ElevatedButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: currentDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null) {
                    currentDate = selectedDate;
                  }
                },
                child: Text('Select Date'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _addExpense(
                    descriptionController.text,
                    amountController.text,
                    currentDate,
                  );
                },
                child: Text('Enter'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToExpensesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpensesScreen(expenses: expenses),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddExpenseModal,
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _navigateToExpensesScreen,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          Expense expense = expenses[index];
          return ListTile(
            title: Text(expense.description),
            subtitle: Text(
              '${expense.amount.toString()} - ${DateFormat.yMd().format(expense.date)}',
            ),
          );
        },
      ),
    );
  }
}

class ExpensesScreen extends StatelessWidget {
  final List<Expense> expenses;

  ExpensesScreen({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Expenses'),
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          Expense expense = expenses[index];
          return ListTile(
            title: Text(expense.description.toUpperCase()),
            subtitle: Text(
              '${expense.amount.toString()} - ${DateFormat.yMd().format(expense.date)}',
            ),
          );
        },
      ),
    );
  }
}
