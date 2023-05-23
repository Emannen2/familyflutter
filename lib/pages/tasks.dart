import 'package:flutter/material.dart';
import 'package:familyapp/widgets/card.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDDBD1),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    // boxShadow: const [
                    //   BoxShadow(
                    //     color: Colors.grey,
                    //     blurRadius: 1,
                    //     offset: Offset(
                    //       5,
                    //       0,
                    //     ),
                    //   ),
                    // ],
                  ),
                  child: Row(
                    children: [
                      const Spacer(),
                      Column(
                        children: const [
                          SizedBox(height: 15),
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1682847724222-207d5e8e0b97?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80'),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Mom',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: const [
                          SizedBox(height: 15),
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                                'https://plus.unsplash.com/premium_photo-1682587554080-c0d64fb18f9e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80'),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Dad',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              const CustomCard(
                title: 'Take out the trash',
                points: '100',
                subtitle:
                    'Task subtitle, yes this is where the magic happens you\'re going to take out the trash without complaining today son.',
                image: 'https://picsum.photos/200',
              ),
              const CustomCard(
                title: 'Take out the trash',
                points: '50',
                subtitle:
                    'Task subtitle, yes this is where the magic happens you\'re going to take out the trash without complaining today son.',
                image: 'https://picsum.photos/300',
              ),
              const CustomCard(
                title: 'Take out the trash',
                points: '150',
                subtitle:
                    'Task subtitle, yes this is where the magic happens you\'re going to take out the trash without complaining today son.',
                image: 'https://picsum.photos/400',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
