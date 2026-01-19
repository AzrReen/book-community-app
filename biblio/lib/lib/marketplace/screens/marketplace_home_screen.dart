import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ Import Provider
import '../../providers/auth_provider.dart'; // ✅ Import AuthProvider
import '/models/book_model.dart';
import '/services/marketplace_service.dart';
import 'add_book_screen.dart';
import 'book_detail_screen.dart';

class MarketplaceHomeScreen extends StatefulWidget {
  @override
  _MarketplaceHomeScreenState createState() => _MarketplaceHomeScreenState();
}

class _MarketplaceHomeScreenState extends State<MarketplaceHomeScreen> {
  final MarketplaceService _service = MarketplaceService();
  String _searchQuery = '';
  String _filterCategory = 'All';

  // 🎨 Custom Colors
  final Color colorBark = const Color(0xFF41302C);
  final Color colorOatLight = const Color(0xFFEBE2D9); 
  final Color colorSilt = const Color(0xFF685C55);

  @override
  Widget build(BuildContext context) {
    // ✅ Get Current User ID from Provider
    final authProvider = context.watch<AuthProvider>();
    final String? currentUserId = authProvider.currentUser?.userId;

    return Scaffold(
      appBar: AppBar(title: const Text('Biblioo Marketplace')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddBookScreen())),
      ),
      body: Column(
        children: [
          // 🔍 SEARCH & FILTER BAR
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            color: Theme.of(context).scaffoldBackgroundColor, 
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search title...',
                      hintStyle: TextStyle(color: colorSilt.withOpacity(0.7)),
                      prefixIcon: Icon(Icons.search, color: colorBark),
                      filled: true,
                      fillColor: colorOatLight, 
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30), 
                        borderSide: BorderSide.none, 
                      ),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                ),
                const SizedBox(width: 12),
                
                // 🌪️ FILTER ICON
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _filterCategory,
                      icon: Icon(Icons.filter_list, color: colorBark),
                      style: TextStyle(color: colorBark, fontWeight: FontWeight.bold),
                      dropdownColor: Colors.white,
                      items: ['All', 'Fiction', 'Textbook', 'Sci-Fi', 'Religious', 'Other']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => _filterCategory = val!),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 📚 BOOK GRID
          Expanded(
            child: StreamBuilder<List<Book>>(
              stream: _service.getBooks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) 
                  return Center(child: CircularProgressIndicator(color: colorBark));
                if (snapshot.hasError) 
                  return Center(child: Text('Error loading books', style: TextStyle(color: colorSilt)));
                
                final books = snapshot.data!.where((book) {
                  final matchesSearch = book.title.toLowerCase().contains(_searchQuery.toLowerCase());
                  final matchesCategory = _filterCategory == 'All' || book.category == _filterCategory;
                  return matchesSearch && matchesCategory;
                }).toList();

                if (books.isEmpty) 
                  return Center(child: Text('No books found', style: TextStyle(color: colorSilt, fontSize: 16)));

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
                        childAspectRatio: 0.70, 
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        
                        // ✅ CHECK OWNERSHIP: Does this book belong to me?
                        final bool isMyBook = (currentUserId != null && book.sellerId == currentUserId);

                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (_) => BookDetailScreen(book: book))
                          ),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🖼️ IMAGE
                                Expanded(
                                  child: Image.network(
                                    book.imageUrl, 
                                    width: double.infinity, 
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, _, __) => Container(
                                      color: colorOatLight,
                                      child: Icon(Icons.broken_image, color: colorSilt),
                                    ),
                                  ),
                                ),
                                
                                // 📝 TEXT DETAILS
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book.title, 
                                        maxLines: 1, 
                                        overflow: TextOverflow.ellipsis, 
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800, 
                                          fontSize: 15,
                                          color: colorBark
                                        )
                                      ),
                                      const SizedBox(height: 8),
                                      
                                      // 🏷️ PRICE & EDIT ROW
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: colorOatLight,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'RM ${book.price.toStringAsFixed(2)}', 
                                              style: TextStyle(
                                                color: colorBark, 
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12
                                              )
                                            ),
                                          ),
                                          
                                          // ✅ ONLY SHOW EDIT BUTTON IF OWNER
                                          if (isMyBook) 
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context, 
                                                  MaterialPageRoute(builder: (_) => AddBookScreen(bookToEdit: book))
                                                );
                                              },
                                              child: Icon(Icons.edit, size: 20, color: colorBark),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}