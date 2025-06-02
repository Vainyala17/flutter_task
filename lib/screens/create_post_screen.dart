import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/post.dart';

class CreatePostScreen extends StatefulWidget {
  final int userId;
  final Function(Post) onPostCreated;

  const CreatePostScreen({
    Key? key,
    required this.userId,
    required this.onPostCreated,
  }) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _tagsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPosting = false;

  final List<String> _availableTags = [
    'technology', 'lifestyle', 'travel', 'food', 'fitness',
    'business', 'education', 'entertainment', 'health', 'sports'
  ];
  List<String> _selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isPosting ? null : _createPost,
            child: _isPosting
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Text(
              'POST',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Post Title',
                  hintText: 'Enter an engaging title...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  if (value.trim().length < 3) {
                    return 'Title must be at least 3 characters';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),

              const SizedBox(height: 20),

              // Body Field
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(
                  labelText: 'What\'s on your mind?',
                  hintText: 'Share your thoughts, ideas, or experiences...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: Icon(Icons.edit),
                  ),
                ),
                maxLines: 8,
                minLines: 6,
                textAlignVertical: TextAlignVertical.top,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter post content';
                  }
                  if (value.trim().length < 10) {
                    return 'Content must be at least 10 characters';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: 20),

              // Tags Section
              Text(
                'Tags',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Selected Tags
              if (_selectedTags.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _selectedTags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          _selectedTags.remove(tag);
                        });
                      },
                      backgroundColor: Colors.blue.shade50,
                      side: BorderSide(color: Colors.blue.shade200),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],

              // Available Tags
              Text(
                'Popular Tags:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _availableTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected && !_selectedTags.contains(tag)) {
                          _selectedTags.add(tag);
                        } else if (!selected) {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: Colors.blue.shade50,
                    checkmarkColor: Colors.blue.shade700,
                    side: BorderSide(
                      color: isSelected ? Colors.blue.shade200 : Colors.grey.shade300,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Custom Tag Input
              TextFormField(
                controller: _tagsController,
                decoration: InputDecoration(
                  labelText: 'Add Custom Tag',
                  hintText: 'Type a custom tag and press Enter',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.tag),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addCustomTag,
                  ),
                ),
                onFieldSubmitted: (_) => _addCustomTag(),
                textCapitalization: TextCapitalization.none,
              ),

              const SizedBox(height: 30),

              // Preview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.preview, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Preview',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_titleController.text.isNotEmpty) ...[
                      Text(
                        _titleController.text,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (_bodyController.text.isNotEmpty) ...[
                      Text(
                        _bodyController.text,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (_selectedTags.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        children: _selectedTags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '#$tag',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addCustomTag() {
    final tag = _tagsController.text.trim().toLowerCase();
    if (tag.isNotEmpty && !_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.add(tag);
        _tagsController.clear();
      });
    }
  }

  void _createPost() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isPosting = true);

      try {
        // Simulate API call delay
        await Future.delayed(const Duration(seconds: 1));

        final post = Post(
          id: DateTime.now().millisecondsSinceEpoch,
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
          userId: widget.userId,
          tags: _selectedTags.isNotEmpty ? _selectedTags : [], // Changed from null to empty list
          reactions: Reactions(likes: 0, dislikes: 0),
          views: 0,
        );

        widget.onPostCreated(post);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating post: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isPosting = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
}