import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'dart:typed_data'; // Required for Uint8List
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';
import '../services/marketplace_service.dart';

class AddBookScreen extends StatefulWidget {
  final Book? bookToEdit; // Added for editing
  AddBookScreen({this.bookToEdit});

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final MarketplaceService _service = MarketplaceService();
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String _selectedCategory = 'Fiction';
  String _selectedCondition = 'New';
  
  XFile? _imageFile; // Use XFile instead of File
  Uint8List? _webImageBytes; // Stores bytes for web preview
  bool _isLoading = false;

  final List<String> _categories = ['Fiction', 'Textbook', 'Sci-Fi', 'Religious', 'Other'];
  final List<String> _conditions = ['New', 'Like New', 'Good', 'Used'];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageFile = pickedFile;
          _webImageBytes = bytes;
        });
      } else {
        setState(() => _imageFile = pickedFile);
      }
    }
  }

  void _submitBook() async {
    if (_formKey.currentState!.validate()) {
      // Logic Check: If adding new book, image is required. If editing, it's optional.
      if (widget.bookToEdit == null && _imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please upload an image')));
        return;
      }

      setState(() => _isLoading = true);
      
      try {
        final user = FirebaseAuth.instance.currentUser;
        String sellerId = user?.uid ?? "TEST_USER_ID";

        Book bookData = Book(
          id: widget.bookToEdit?.id ?? '', // Use old ID if editing
          title: _titleController.text,
          author: _authorController.text,
          price: double.parse(_priceController.text),
          category: _selectedCategory,
          condition: _selectedCondition,
          imageUrl: widget.bookToEdit?.imageUrl ?? '', // Keep old image if no new one picked
          sellerId: widget.bookToEdit?.sellerId ?? sellerId,
          createdAt: widget.bookToEdit?.createdAt ?? Timestamp.now(),
          description: _descController.text,
        );

        if (widget.bookToEdit != null) {
          // Update existing book
          await _service.updateBook(widget.bookToEdit!.id, bookData, _imageFile);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Book Updated Successfully!')));
        } else {
          // Add new book
          await _service.addBook(bookData, _imageFile!);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Book Listed Successfully!')));
        }
        
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // fill the controllers if we are in Edit Mode
    if (widget.bookToEdit != null) {
      _titleController.text = widget.bookToEdit!.title;
      _authorController.text = widget.bookToEdit!.author;
      _priceController.text = widget.bookToEdit!.price.toString();
      _descController.text = widget.bookToEdit!.description;
      _selectedCategory = widget.bookToEdit!.category;
      _selectedCondition = widget.bookToEdit!.condition;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.bookToEdit != null ? 'Edit Book' : 'Sell a Book')),
      body: _isLoading 
          ? Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: _imageFile != null 
                            ? (kIsWeb 
                                ? Image.memory(_webImageBytes!, fit: BoxFit.cover)
                                : Image.file(File(_imageFile!.path), fit: BoxFit.cover))
                            : (widget.bookToEdit != null && widget.bookToEdit!.imageUrl.isNotEmpty
                                ? Image.network(widget.bookToEdit!.imageUrl, fit: BoxFit.cover)
                                : Icon(Icons.add_a_photo, size: 50, color: Colors.grey)),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Book Title', border: OutlineInputBorder()),
                      validator: (val) => val!.isEmpty ? 'Enter title' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _authorController,
                      decoration: InputDecoration(labelText: 'Author', border: OutlineInputBorder()),
                      validator: (val) => val!.isEmpty ? 'Enter author' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(labelText: 'Price (RM)', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (val) => val!.isEmpty ? 'Enter price' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _descController,
                      maxLines: 3, 
                      decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                      validator: (val) => val!.isEmpty ? 'Enter a description' : null,
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField(
                      value: _selectedCategory,
                      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => _selectedCategory = val.toString()),
                      decoration: InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField(
                      value: _selectedCondition,
                      items: _conditions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => _selectedCondition = val.toString()),
                      decoration: InputDecoration(labelText: 'Condition', border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitBook,
                        child: Text(widget.bookToEdit != null ? 'Update Book' : 'List Book'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}