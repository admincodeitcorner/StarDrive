import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:star_drive/core/constant/app_colors.dart';
import 'package:star_drive/features/dashboard/presentation/screens/home.screen.dart';
import 'package:star_drive/features/driver_verification/domain/entities/document_file.dart';
import 'package:star_drive/features/driver_verification/domain/entities/vechile_detail_submission.dart';
import 'package:star_drive/features/driver_verification/presentataion/bloc/vechile_details_bloc/vechile_details_bloc_bloc.dart';

// ignore: must_be_immutable
class VechilePictureScreen extends StatefulWidget {
  VechilePictureScreen({
    super.key,
    required this.vechileNumber,
    required this.vechileType,
    required this.vechileModel,
    required this.vechileColor,
    required this.seatingCapacity,
  });
  String vechileNumber;
  String vechileType;
  String vechileModel;
  String vechileColor;
  int seatingCapacity;

  @override
  State<VechilePictureScreen> createState() => _VechilePictureScreenState();
}

class _VechilePictureScreenState extends State<VechilePictureScreen> {
  File? _vehiclePic;
  File? _vehicleFrontImage;
  File? _vehicleBackImage;
  File? _vehicleCardFrontImage;
  File? _vehicleCardBackImage;
  Future<void> _handlePickImage(ValueChanged<File> onSelected) async {
    final file = await pickDocumentImage(context);

    if (!mounted || file == null) return;

    setState(() {
      onSelected(file);
    });
  }

  void _submitForm() {
    // Check that all three images are selected.
    if (_vehiclePic == null ||
        _vehicleFrontImage == null ||
        _vehicleBackImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload all three vehicle pictures.'),
        ),
      );
      return;
    }

    final submission = VehicleDetailsSubmission(
      vehicleNumber: widget.vechileNumber,
      type: widget.vechileType,
      model: widget.vechileModel,
      color: widget.vechileColor,
      seatingCapacity: widget.seatingCapacity,

      vehiclePic: DocumentFile(
        path: _vehiclePic!.path,
        fileName: _vehiclePic!.path.split(Platform.pathSeparator).last,
      ),

      vehicleFrontPic: DocumentFile(
        path: _vehicleFrontImage!.path,
        fileName: _vehicleFrontImage!.path.split(Platform.pathSeparator).last,
      ),

      vehicleBackPic: DocumentFile(
        path: _vehicleBackImage!.path,
        fileName: _vehicleBackImage!.path.split(Platform.pathSeparator).last,
      ),
      vehicleCardFrontPic: DocumentFile(path: _vehicleCardFrontImage!.path,
      fileName: _vehicleCardFrontImage!.path.split(Platform.pathSeparator).last),
      vehicleCardBackPic: DocumentFile(path: _vehicleCardBackImage!.path,
      fileName: _vehicleCardBackImage!.path.split(Platform.pathSeparator).last), 
    );

    // Dispatch event to the existing BLoC.
    context.read<VehicleDetailsBloc>().add(SubmitVechileDetails(submission));
  }

  Widget _buildImagePicker(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required File? imageName,
    required ValueChanged<File> onImageSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(title),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _handlePickImage(onImageSelected),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFBF8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary),
            ),
            child: Row(
              children: [
                if (imageName != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      imageName,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Icon(icon, color: AppColors.primary, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        imageName == null ? subtitle : 'Photo selected',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  imageName == null
                      ? Icons.cloud_upload_outlined
                      : Icons.check_circle,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String label, {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textLabel,
            ),
          ),
          if (required) const Text(' *', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VehicleDetailsBloc, VechileDetailsBlocState>(
      listener: (context, state) {
        if (state is VechileDetailsBlocSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        }

        if (state is VechileDetailsBlocFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('Vechile Photo'), centerTitle: false),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Vehicle Photos',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Upload clear pictures of your vehicle.',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 18),
            
                _buildImagePicker(
                  context,
                  title: 'Vehicle Picture',
                  subtitle: 'Upload the main vehicle photo',
                  icon: Icons.directions_car_outlined,
                  imageName: _vehiclePic,
                  onImageSelected: (file) => _vehiclePic = file,
                ),
            
                _buildImagePicker(
                  context,
                  title: 'Front Picture',
                  subtitle: 'Upload the front view',
                  icon: Icons.camera_alt_outlined,
                  imageName: _vehicleFrontImage,
                  onImageSelected: (file) => _vehicleFrontImage = file,
                ),
            
                _buildImagePicker(
                  context,
                  title: 'Back Picture',
                  subtitle: 'Upload the rear view',
                  icon: Icons.photo_camera_back_outlined,
                  imageName: _vehicleBackImage,
                  onImageSelected: (file) => _vehicleBackImage = file,
                ),
                _buildImagePicker(
                  context,
                  title: 'Back Picture',
                  subtitle: 'Upload the rear view',
                  icon: Icons.photo_camera_back_outlined,
                  imageName: _vehicleCardFrontImage,
                  onImageSelected: (file) => _vehicleCardFrontImage = file,
                ),
                _buildImagePicker(
                  context,
                  title: 'Back Picture',
                  subtitle: 'Upload the rear view',
                  icon: Icons.photo_camera_back_outlined,
                  imageName: _vehicleCardBackImage,
                  onImageSelected: (file) => _vehicleCardBackImage = file,
                ),
                const SizedBox(height: 30),
            
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<File?> pickDocumentImage(BuildContext context) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Photo Source',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(
                  Icons.photo_camera_outlined,
                  color: AppColors.primary,
                ),
              ),
              title: const Text(
                'Take a photo',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Capture using device camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.primary,
                ),
              ),
              title: const Text(
                'Choose from gallery',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Select an image from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    ),
  );

  if (source == null) return null;

  try {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
    );
    return picked == null ? null : File(picked.path);
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          content: Text(
            'Could not access camera or gallery. Please check permissions.',
          ),
        ),
      );
    }
    return null;
  }
}
