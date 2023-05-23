import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ParentShop extends StatefulWidget {
  const ParentShop({Key? key}) : super(key: key);

  @override
  State<ParentShop> createState() => _ParentShopState();
}

class _ParentShopState extends State<ParentShop> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  TextEditingController _descriptionController = TextEditingController();
  String? _selectedOption;

  Future uploadFile() async {
    // Get the current user's ID
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Create a user-specific folder in Firebase Storage
    final path = 'users/$userId/files/${pickedFile!.name}';

    // Get the file object from the picked file path
    final file = File(pickedFile!.path!);

    // Upload the file to the user-specific folder
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download-Link: $urlDownload');

    // Create a user-specific folder in Firebase Storage for the file's data
    final dataPath = 'users/$userId/files/${pickedFile!.name}/data';
    final dataRef = FirebaseStorage.instance.ref().child(dataPath);

    // Save the file's data to the user-specific folder
    await dataRef
        .child('description.txt')
        .putString(_descriptionController.text);
    await dataRef.child('points.txt').putString(_selectedOption!);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            if (pickedFile != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 24, 24.0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(pickedFile!.path!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Image.file(
                          File(pickedFile!.path!),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Enter a description',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      menuMaxHeight: 200,
                      decoration: const InputDecoration(
                        hintText: 'Select an option',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: _selectedOption,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue;
                        });
                      },
                      items: <String>[
                        'Points',
                        '50',
                        '100',
                        '150',
                        '200',
                        '250',
                        '300',
                        '350',
                        '400',
                        '450',
                        '500',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            //             hintStyle: TextStyle(
            //               fontSize: 15,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           items: const [
            //             DropdownMenuItem(
            //               value: 'Option 50',
            //               child: Text('50 Points'),
            //             ),
            //             DropdownMenuItem(
            //               value: 'Option 100',
            //               child: Text('100 Points'),
            //             ),
            //             DropdownMenuItem(
            //               value: 'Option 150',
            //               child: Text('150 Points'),
            //             ),
            //             DropdownMenuItem(
            //               value: 'Option 200',
            //               child: Text('200 Points'),
            //             ),
            //             DropdownMenuItem(
            //               value: 'Option 250',
            //               child: Text('250 Points'),
            //             ),
            //             DropdownMenuItem(
            //               value: 'Option 300',
            //               child: Text('300 Points'),
            //             ),
            //             DropdownMenuItem(
            //               value: 'Option 350',
            //               child: Text('350 Points'),
            //             ),
            //             DropdownMenuItem(
            //               value: 'Option 400',
            //               child: Text('400 Points'),
            //             ),
            //             DropdownMenuItem(
            //               value: 'Option 450',
            //               child: Text('450 Points'),
            //             ),
            //             DropdownMenuItem(
            //               value: 'Option 500',
            //               child: Text('500 Points'),
            //             ),
            //           ],
            //           onChanged: (String? value) {
            //             // handle the selected value
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const Spacer(),
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: selectFile,
                  child: const Text('Select File'),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: () async {
                    await uploadFile();
                  },
                  child: const Text('Upload Task'),
                ),
                const Spacer(),
                buildProgress(),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget buildProgress() {
    if (uploadTask == null) {
      return const SizedBox(height: 50);
    }

    return StreamBuilder<TaskSnapshot>(
      stream: uploadTask!.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          bool isComplete = data.bytesTransferred == data.totalBytes;

          return Visibility(
            visible: !isComplete,
            child: SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.green,
                  ),
                  Center(
                    child: Text(
                      '${(progress * 100).toStringAsFixed(2)} %',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox(height: 50);
        }
      },
    );
  }
}
