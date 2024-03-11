import 'package:flutter/material.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            CircleAvatar(
              radius: 90,
              backgroundImage: const NetworkImage(
                  'https://via.placeholder.com/150'), // Replace with your image URL
              backgroundColor: Colors.deepPurple
                  .shade100, // Custom color for CircleAvatar background
            ),
            const SizedBox(height: 10),
            TextButton(onPressed: () {
              //Image Picker
            }, child: const Text('Change Profile Avatar')),
            _buildTextField(context, 'Email', _emailController),
            _buildTextField(context, 'Name', _nameController),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        //Update Profile
                      },
                      child:  const Text('Update Profile',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal))),
                ),
              
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: label,
            ),
          ),
        ),
      ),
    );
  }
}
