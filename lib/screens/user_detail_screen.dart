import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetailScreen extends StatefulWidget {
  final User user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Post> posts = [];
  List<Todo> todos = [];
  bool isLoadingPosts = true;
  bool isLoadingTodos = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    // Fetch Posts
    try {
      final postsResponse = await http.get(
          Uri.parse('https://dummyjson.com/posts/user/${widget.user.id}')
      );
      if (postsResponse.statusCode == 200) {
        final postsData = json.decode(postsResponse.body);
        setState(() {
          posts = (postsData['posts'] as List)
              .map((post) => Post.fromJson(post))
              .toList();
          isLoadingPosts = false;
        });
      }
    } catch (e) {
      setState(() => isLoadingPosts = false);
    }

    // Fetch Todos
    try {
      final todosResponse = await http.get(
          Uri.parse('https://dummyjson.com/todos/user/${widget.user.id}')
      );
      if (todosResponse.statusCode == 200) {
        final todosData = json.decode(todosResponse.body);
        setState(() {
          todos = (todosData['todos'] as List)
              .map((todo) => Todo.fromJson(todo))
              .toList();
          isLoadingTodos = false;
        });
      }
    } catch (e) {
      setState(() => isLoadingTodos = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.firstName} ${widget.user.lastName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Your existing share functionality
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Info', icon: Icon(Icons.person)),
            Tab(text: 'Posts', icon: Icon(Icons.article)),
            Tab(text: 'Todos', icon: Icon(Icons.check_box)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInfoTab(),
          _buildPostsTab(),
          _buildTodosTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostScreen(
                userId: widget.user.id,
                onPostCreated: (post) {
                  setState(() {
                    posts.insert(0, post);
                  });
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // User Avatar and Basic Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.user.image ?? ''),
                  child: widget.user.image == null
                      ? Text(
                    '${widget.user.firstName[0]}${widget.user.lastName[0]}',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  '${widget.user.firstName} ${widget.user.lastName}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '@${widget.user.username}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Contact Information
          _buildInfoCard(
            icon: Icons.email,
            title: 'Email',
            value: widget.user.email ?? '',
            onCopy: () => _copyToClipboard(widget.user.email ?? ''),
          ),

          _buildInfoCard(
            icon: Icons.phone,
            title: 'Phone',
            value: widget.user.phone ?? '',
            onCopy: () => _copyToClipboard(widget.user.phone ?? ''),
          ),

          _buildInfoCard(
            icon: Icons.web,
            title: 'Website',
            value: 'www.${widget.user.username}.com',
            onCopy: () => _copyToClipboard('www.${widget.user.username}.com'),
          ),

          // Additional Info
          _buildInfoCard(
            icon: Icons.cake,
            title: 'Age',
            value: '${widget.user.age} years old',
          ),

          _buildInfoCard(
            icon: Icons.location_on,
            title: 'Address',
            value: '${widget.user.address?.city ?? ''}, ${widget.user.address?.state ?? ''}',
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    if (isLoadingPosts) {
      return const Center(child: CircularProgressIndicator());
    }

    if (posts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No posts yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.body,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.thumb_up_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${post.reactions?.likes ?? 0}'),
                    const SizedBox(width: 16),
                    Icon(Icons.thumb_down_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${post.reactions?.dislikes ?? 0}'),
                    const Spacer(),
                    Text(
                      '${post.views ?? 0} views',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTodosTab() {
    if (isLoadingTodos) {
      return const Center(child: CircularProgressIndicator());
    }

    if (todos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_box_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No todos yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              todo.completed ? Icons.check_box : Icons.check_box_outline_blank,
              color: todo.completed ? Colors.green : Colors.grey,
            ),
            title: Text(
              todo.todo,
              style: TextStyle(
                decoration: todo.completed ? TextDecoration.lineThrough : null,
                color: todo.completed ? Colors.grey : null,
              ),
            ),
            onTap: () {
              setState(() {
                todo.completed = !todo.completed;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onCopy,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (onCopy != null)
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
                onPressed: onCopy,
              ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    // Your existing copy functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied: $text')),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// Model classes
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String? email;
  final String? phone;
  final String? image;
  final int? age;
  final Address? address;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.email,
    this.phone,
    this.image,
    this.age,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      age: json['age'],
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
    );
  }
}

class Address {
  final String? city;
  final String? state;

  Address({this.city, this.state});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'],
      state: json['state'],
    );
  }
}

class Post {
  final int id;
  final String title;
  final String body;
  final int userId;
  final List<String>? tags;
  final Reactions? reactions;
  final int? views;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    this.tags,
    this.reactions,
    this.views,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      reactions: json['reactions'] != null ? Reactions.fromJson(json['reactions']) : null,
      views: json['views'],
    );
  }
}

class Reactions {
  final int likes;
  final int dislikes;

  Reactions({required this.likes, required this.dislikes});

  factory Reactions.fromJson(Map<String, dynamic> json) {
    return Reactions(
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
    );
  }
}

class Todo {
  final int id;
  final String todo;
  bool completed;
  final int userId;

  Todo({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      todo: json['todo'],
      completed: json['completed'],
      userId: json['userId'],
    );
  }
}

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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _createPost,
            child: const Text('POST', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _bodyController,
                  decoration: const InputDecoration(
                    labelText: 'What\'s on your mind?',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter post content';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createPost() {
    if (_formKey.currentState!.validate()) {
      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch, // Generate unique ID
        title: _titleController.text,
        body: _bodyController.text,
        userId: widget.userId,
        reactions: Reactions(likes: 0, dislikes: 0),
        views: 0,
      );

      widget.onPostCreated(post);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}