import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/list_view_model.dart';

class ListViewProvider extends ChangeNotifier {
  List<ListViewModel> _users = [];
  List<ListViewModel> _filteredUsers = [];
  bool _isLoading = false;
  final TextEditingController searchController = TextEditingController();

  List<ListViewModel> get users => _users;
  List<ListViewModel> get filteredUsers => _filteredUsers;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
      if (response.statusCode == 200) {
        _users = listViewModelFromJson(response.body);
        _filteredUsers = _users; // Show all users initially
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      _filteredUsers = _users;
    } else {
      _filteredUsers = _users
          .where((user) =>
              user.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    filterUsers(""); 
  }
}
