import 'package:flutter/material.dart';
import 'package:kingz_cut_mobile/screens/calls_screen.dart';
import 'package:kingz_cut_mobile/screens/chat_screen.dart';

class CustomerMessagingPage extends StatefulWidget {
  const CustomerMessagingPage({super.key});

  @override
  State<CustomerMessagingPage> createState() => _CustomerMessagingPageState();
}

class _CustomerMessagingPageState extends State<CustomerMessagingPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [const MessagesTab(), const CallsTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedIndex == 0 ? 'Messages' : 'Calls',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color:
                                _selectedIndex == 0
                                    ? Colors.white
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              'Messages',
                              style: TextStyle(
                                color:
                                    _selectedIndex == 0
                                        ? Colors.black
                                        : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color:
                                _selectedIndex == 1
                                    ? Colors.white
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              'Calls',
                              style: TextStyle(
                                color:
                                    _selectedIndex == 1
                                        ? Colors.black
                                        : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: _pages[_selectedIndex]),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search chat',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: [
              MessageListItem(
                name: 'Jeremy Agyei',
                message: 'Great. Thank you boss',
                time: '11:15pm',
                isOnline: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const ChatScreen(
                            name: 'Jeremy Agyei',
                            isOnline: true,
                          ),
                    ),
                  );
                },
              ),
              MessageListItem(
                name: 'Paul Gyimah',
                message: 'Can I come around for a haircut',
                time: '11:15pm',
                isOnline: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const ChatScreen(
                            name: 'Paul Gyimah',
                            isOnline: true,
                          ),
                    ),
                  );
                },
              ),
              MessageListItem(
                name: 'Jeremy Agyei',
                message: 'Can I come around for a haircut',
                time: '11:15pm',
                isOnline: true,
                hasNewMessages: true,
                newMessageCount: 2,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const ChatScreen(
                            name: 'Jeremy Agyei',
                            isOnline: true,
                          ),
                    ),
                  );
                },
              ),
              MessageListItem(
                name: 'Jeremy Agyei',
                message: 'Can I come around for a haircut',
                time: '11:15pm',
                isOnline: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const ChatScreen(
                            name: 'Jeremy Agyei',
                            isOnline: true,
                          ),
                    ),
                  );
                },
              ),
              MessageListItem(
                name: 'Paul Gyimah',
                message: 'Can I come around for a haircut',
                time: '11:15pm',
                isOnline: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const ChatScreen(
                            name: 'Paul Gyimah',
                            isOnline: true,
                          ),
                    ),
                  );
                },
              ),
              MessageListItem(
                name: 'Paul Gyimah',
                message: 'Can I come around for a haircut',
                time: '11:15pm',
                isOnline: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const ChatScreen(
                            name: 'Paul Gyimah',
                            isOnline: true,
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CallsTab extends StatelessWidget {
  const CallsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search user',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: [
              CallListItem(
                name: 'Paul Gyimah',
                dateTime: 'Yesterday, 11:15 pm',
                status: CallStatus.missed,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const CallScreen(name: 'Paul Gyimah'),
                    ),
                  );
                },
              ),
              CallListItem(
                name: 'Jeremy Agyei',
                dateTime: '5/02/2025, 2:30pm',
                status: CallStatus.received,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const CallScreen(name: 'Jeremy Agyei'),
                    ),
                  );
                },
              ),
              CallListItem(
                name: 'Paul Gyimah',
                dateTime: '5/02/2025, 2:30pm',
                status: CallStatus.missed,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const CallScreen(name: 'Paul Gyimah'),
                    ),
                  );
                },
              ),
              CallListItem(
                name: 'Jeremy Agyei',
                dateTime: '5/02/2025, 2:30pm',
                status: CallStatus.received,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const CallScreen(name: 'Jeremy Agyei'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum CallStatus { received, missed }

class MessageListItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final bool isOnline;
  final bool hasNewMessages;
  final int newMessageCount;
  final VoidCallback onTap;

  const MessageListItem({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.isOnline,
    this.hasNewMessages = false,
    this.newMessageCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(
                    'assets/images/${name.replaceAll(' ', '_').toLowerCase()}.jpg',
                  ),
                  onBackgroundImageError: (_, __) {},
                  child: Image.asset(
                    'assets/images/${name.replaceAll(' ', '_').toLowerCase()}.jpg',
                    errorBuilder: (context, error, stackTrace) {
                      return Text(name[0]);
                    },
                  ),
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 4),
                if (hasNewMessages)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      newMessageCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const Icon(Icons.done_all, size: 16, color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CallListItem extends StatelessWidget {
  final String name;
  final String dateTime;
  final CallStatus status;
  final VoidCallback onTap;

  const CallListItem({
    super.key,
    required this.name,
    required this.dateTime,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(
                'assets/images/${name.replaceAll(' ', '_').toLowerCase()}.jpg',
              ),
              onBackgroundImageError: (_, __) {},
              child: Image.asset(
                'assets/images/${name.replaceAll(' ', '_').toLowerCase()}.jpg',
                errorBuilder: (context, error, stackTrace) {
                  return Text(name[0]);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        dateTime,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status == CallStatus.missed ? 'Missed' : 'Received',
                        style: TextStyle(
                          color:
                              status == CallStatus.missed
                                  ? Colors.red
                                  : Colors.green,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.call, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
