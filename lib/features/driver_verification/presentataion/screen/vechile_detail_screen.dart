import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:star_drive/core/constant/app_colors.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/vechile_picture_screen.dart';

class VechileDetailScreen extends StatefulWidget {
  const VechileDetailScreen({super.key});

  @override
  State<VechileDetailScreen> createState() => _VechileDetailScreenState();
}

class _VechileDetailScreenState extends State<VechileDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  final _vehicleNumberController = TextEditingController();
  final _modelController = TextEditingController();
  final _colorController = TextEditingController();
  final _seatingCapacityController = TextEditingController();

  String? _selectedType = 'Car';

  // Future vehicle types can be added here.
  final List<String> _vehicleTypes = [
    'Car',
    // 'Bike',
    // 'SUV',
    // 'Van',
    // 'Bus',
    // 'Truck',
  ];

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    _seatingCapacityController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({required String hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
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

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization: TextCapitalization.sentences,
          decoration: _inputDecoration(hint: hint, icon: icon),
          validator:
              validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Vehicle Details',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Add your vehicle',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter your vehicle information and upload '
                    'the required pictures.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.all(18),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(16),
                    //   border: Border.all(color: borderColor),
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(
                          label: 'Vehicle Number',
                          hint: 'e.g. ABC-123',
                          controller: _vehicleNumberController,
                          icon: Icons.pin_outlined,
                        ),
                        const SizedBox(height: 20),

                        _buildLabel('Vehicle Type'),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedType,
                          isExpanded: true,
                          decoration: _inputDecoration(
                            hint: 'Select vehicle type',
                            icon: Icons.directions_car_outlined,
                          ),
                          items: _vehicleTypes.map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select vehicle type';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          label: 'Vehicle Model',
                          hint: 'e.g. Corolla',
                          controller: _modelController,
                          icon: Icons.directions_car_filled_outlined,
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          label: 'Vehicle Color',
                          hint: 'e.g. Blue',
                          controller: _colorController,
                          icon: Icons.palette_outlined,
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          label: 'Seating Capacity',
                          hint: 'e.g. 4',
                          controller: _seatingCapacityController,
                          icon: Icons.event_seat_outlined,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            final capacity = int.tryParse(value ?? '');
                            if (capacity == null || capacity < 1) {
                              return 'Enter a valid seating capacity';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton(
  onPressed: () {
    // Step 1: Validate all fields first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Step 2: Convert seating capacity to int
    final int capacity = int.parse(
      _seatingCapacityController.text.trim(),
    );

    // Step 3: Navigate to vehicle picture screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VechilePictureScreen(
          vechileNumber: _vehicleNumberController.text.trim(),
          vechileType: _selectedType!,
          vechileModel: _modelController.text.trim(),
          vechileColor: _colorController.text.trim(),
          seatingCapacity: capacity,
        ),
      ),
    );
  },
  child: const Text('Next'),
),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
