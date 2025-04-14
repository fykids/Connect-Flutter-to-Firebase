import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_1/screen/chat_screen.dart';
import 'package:flutter_firebase_1/screen/controller/home_controller.dart';
import 'package:flutter_firebase_1/services/auth_services.dart';
import 'package:flutter_firebase_1/screen/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  String? chatId;

  @override
  void initState() {
    super.initState();
    initChat();
  }

  void initChat() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final chatController = ChatController();
      final fetchedChatId = await chatController.getOrCreateChatId(user.uid);
      setState(() {
        chatId = fetchedChatId;
      });
    } else {
      // Handle user not logged in
      chatId = null;
    }
  }

  List<Widget> get _widgetOptions => [
    const HomePageContent(),
    ChatScreen(chatId: chatId),
    const SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chat'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  // ignore: prefer_final_fields
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final AuthServices _authServices = AuthServices();
    final user = _authServices.getCurrentUser();
    final String? displayFromUser = user?.displayName;
    final String? photoUrlFromUser = user?.photoUrl;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            minimum: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(photoUrlFromUser ?? ''),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      displayFromUser ?? 'User',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SafeArea(
            minimum: EdgeInsets.only(left: 10, right: 10),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Card(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Welcome to the Home Page!',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SafeArea(
            minimum: EdgeInsets.only(left: 10, right: 10),
            child: Text('Rekomendasi', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 8),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    5,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 150,
                        height: 200,
                        color: Colors.amber,
                        child: Center(
                          child: Text(
                            'Rekomendasi $index',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'More content can go here.',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 8),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              10,
              (index) => ListTile(
                title: Text('List Item $index'),
                subtitle: const Text('Subtitle'),
                leading: const Icon(Icons.list),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
