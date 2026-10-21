import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:star_drive/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_phone_field.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_text_field.dart';

class ProfileSettingScreen extends StatefulWidget {
  final String userName;
  const ProfileSettingScreen({super.key , required this.userName});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();

  File? _pickedImage;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() {
      _pickedImage = File(picked.path);
    });
  }
  @override

  void initState(){
    super.initState();
    nameController.text = widget.userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile Setting", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,)),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                SizedBox(height: 20),

                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: Color(0xFFE0E0E0),
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!)
                            : null,
                        child: _pickedImage == null
                            ? Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.black54,
                              )
                            : null,
                      ),

                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: InkWell(
                          onTap: pickImage,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                CustomTextField(
                  controller: nameController,
                  hintText: "Enter Your Name",
                  labelText: "Enter Name ",
                  icon: Icons.person,
                ),

                SizedBox(height: 14),

                CustomTextField(
                  controller: mailController,
                  hintText: "Enter Your Email",
                  labelText: "Enter Email",
                  icon: Icons.email,
                ),

                SizedBox(height: 14),
                CustomPhoneField(controller: phoneController),

                SizedBox(height: 80),
                AuthButton(text: 'Save', isLoading: false, onPressed: () {
                  
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget customTextField({
//   required String hintText,
//   required IconData icon,
//   TextInputType keyboardType = TextInputType.text,
// }) {
//   return TextField(
//     keyboardType: keyboardType,
//     decoration: InputDecoration(
//       hintText: hintText,
//       hintStyle: TextStyle(fontSize: 14),
//       prefixIcon: Icon(icon),
//       border: const OutlineInputBorder(),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//     ),
//   );
// }
