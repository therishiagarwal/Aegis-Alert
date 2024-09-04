import 'package:flutter/material.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  DateTime? _selectedDate;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isOTPSent = false;

  // Method to send OTP
  void _getOTP() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
    } else {
      // Simulate OTP sending process
      setState(() {
        _isOTPSent = true; // Set to true to enable the OTP field
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP sent to ${_phoneController.text}')),
      );
      // Add your actual OTP sending logic here
    }
  }

  // Method to display a date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Dummy method to simulate OTP verification
  void _verifyOTP() {
    // Add your OTP verification logic here
    if (_otpController.text == "123456") { // Replace with actual verification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Verified!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _getOTP,
                child: const Text('Get OTP'),
              ),
              if (_isOTPSent) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _otpController,
                  decoration: const InputDecoration(labelText: 'OTP'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the OTP';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _verifyOTP,
                  child: const Text('Verify OTP'),
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: ['Male', 'Female', 'Other']
                    .map((label) => DropdownMenuItem(
                  value: label,
                  child: Text(label),
                ))
                    .toList(),
                hint: const Text('Gender'),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                controller: TextEditingController(
                  text: _selectedDate != null
                      ? "${_selectedDate!.toLocal()}".split(' ')[0]
                      : '',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your date of birth';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process the data
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
