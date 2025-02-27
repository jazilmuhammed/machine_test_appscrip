import 'package:flutter/material.dart';
import 'package:mission_test/shimmer/list_view_shimmer.dart';
import 'package:provider/provider.dart';
import '../provider/list_view_provider.dart';
import '../models/list_view_model.dart';

class ListViewScreen extends StatefulWidget {
  const ListViewScreen({super.key});

  @override
  State<ListViewScreen> createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<ListViewProvider>(context, listen: false).fetchUsers();
    });
  }

  void _showUserDetails(BuildContext context, ListViewModel user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name ?? "No Name",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Username: ${user.username ?? ""}"),
                Text("Email: ${user.email ?? ""}"),
                Text("Phone: ${user.phone ?? ""}"),
                Text("Website: ${user.website ?? ""}"),
                const SizedBox(height: 8),
                Text("Company: ${user.company?.name ?? ""}"),
                const SizedBox(height: 8),
                Text(
                    "Address: ${user.address?.street ?? ""}, ${user.address?.city ?? ""}"),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("User List"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Consumer<ListViewProvider>(
              builder: (context, provider, _) {
                return TextFormField(
                  controller: provider.searchController,
                  decoration: InputDecoration(
                    hintText: "Search by name...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: provider.searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: provider.clearSearch,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: provider.filterUsers,
                );
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<ListViewProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return userListShimmer();
                      },
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => provider.fetchUsers(),
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: provider.filteredUsers.length,
                      itemBuilder: (context, index) {
                        var user = provider.filteredUsers[index];
                        return GestureDetector(
                          onTap: () => _showUserDetails(context, user),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.black12.withOpacity(0.03),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              child: Row(
                                children: [
                                  Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90),
                                      border: Border.all(width: 0.5),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(user.name ?? "No Name",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(user.email ?? "No Email"),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
