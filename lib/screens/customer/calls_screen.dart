import 'package:flutter/material.dart';

class CallScreen extends StatelessWidget {
  final String name;

  const CallScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Calls'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(
                'assets/images/${name.replaceAll(' ', '_').toLowerCase()}.jpg',
              ),
              onBackgroundImageError: (_, __) {},
              child: Image.asset(
                'assets/images/${name.replaceAll(' ', '_').toLowerCase()}.jpg',
                errorBuilder: (context, error, stackTrace) {
                  return Text(name[0], style: const TextStyle(fontSize: 48));
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            name,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            '05:32:15',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 48.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CallButton(
                  icon: Icons.call_end,
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CallButton(
                  icon: Icons.videocam_off,
                  color: Colors.grey,
                  onPressed: () {},
                ),
                CallButton(
                  icon: Icons.volume_up,
                  color: Colors.green,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CallButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const CallButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
