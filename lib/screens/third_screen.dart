import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../providers/user_provider.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  final UserService _userService = UserService();
  final List<User> _users = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _isError = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (refresh) {
        _users.clear();
        _currentPage = 1;
      }
    });

    try {
      final result = await _userService.getUsers(
        page: _currentPage,
        perPage: 10,
      );

      setState(() {
        _users.addAll(result['users'] as List<User>);
        _totalPages = result['total_pages'];
        _isError = false;
      });
    } catch (e) {
      setState(() {
        _isError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoading &&
        _currentPage < _totalPages) {
      _currentPage++;
      _loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Third Screen',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_users.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_users.isEmpty && _isError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load users'),
            ElevatedButton(
              onPressed: () => _loadUsers(refresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_users.isEmpty) {
      return const Center(
        child: Text('No users found'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadUsers(refresh: true),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          controller: _scrollController,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _users.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _users.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
          
              final user = _users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.imageUrl),
                ),
                title: Text(user.fullName),
                subtitle: Text(user.email),
                onTap: () {
                  context.read<UserProvider>().setSelectedUsername(user.fullName);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}