import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/AppColors.dart';

class ShippingAddress extends StatefulWidget {
  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController =
      TextEditingController(); // House/Road/Block
  final TextEditingController _zipController = TextEditingController();

  String? _selectedDivision;
  String? _selectedDistrict;

  final List<String> _divisions = [
    "Dhaka",
    "Chittagong",
    "Rajshahi",
    "Khulna",
    "Barisal",
    "Sylhet",
    "Rangpur",
    "Mymensingh",
  ];

  final Map<String, List<String>> _districts = {
    "Dhaka": ["Dhaka", "Gazipur", "Narayanganj", "Tangail", "Faridpur"],
    "Chittagong": ["Chittagong", "Cox's Bazar", "Comilla", "Feni", "Noakhali"],
    "Rajshahi": ["Rajshahi", "Bogra", "Pabna", "Naogaon"],
    "Khulna": ["Khulna", "Jessore", "Satkhira", "Kushtia"],
    "Barisal": ["Barisal", "Bhola", "Patuakhali"],
    "Sylhet": ["Sylhet", "Sunamganj", "Habiganj", "Moulvibazar"],
    "Rangpur": ["Rangpur", "Dinajpur", "Kurigram"],
    "Mymensingh": ["Mymensingh", "Jamalpur", "Sherpur", "Netrokona"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Shipping Address",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Full Name", _nameController, Icons.person),
              SizedBox(height: 15.h),
              _buildTextField(
                "Phone Number",
                _phoneController,
                Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 15.h),

              // Division Dropdown
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDivision,
                    hint: Row(
                      children: [
                        Icon(Icons.map, color: AppColors.deep_orange),
                        SizedBox(width: 10),
                        Text("Select Division"),
                      ],
                    ),
                    isExpanded: true,
                    items: _divisions.map((String division) {
                      return DropdownMenuItem<String>(
                        value: division,
                        child: Text(division),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDivision = newValue;
                        _selectedDistrict = null; // Reset district
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15.h),

              // District Dropdown
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDistrict,
                    hint: Row(
                      children: [
                        Icon(Icons.location_city, color: AppColors.deep_orange),
                        SizedBox(width: 10),
                        Text("Select District"),
                      ],
                    ),
                    isExpanded: true,
                    items: _selectedDivision == null
                        ? []
                        : _districts[_selectedDivision]!.map((String district) {
                            return DropdownMenuItem<String>(
                              value: district,
                              child: Text(district),
                            );
                          }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDistrict = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15.h),

              _buildTextField(
                "Address (House/Road/Area)",
                _addressController,
                Icons.home,
              ),
              SizedBox(height: 15.h),
              _buildTextField(
                "Zip Code",
                _zipController,
                Icons.pin_drop,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _selectedDivision != null &&
                        _selectedDistrict != null) {
                      String fullAddress =
                          "${_addressController.text}, $_selectedDistrict, $_selectedDivision - ${_zipController.text}";
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Address saved successfully!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context, fullAddress);
                    } else if (_selectedDivision == null ||
                        _selectedDistrict == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please select Division and District"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Save Address",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deep_orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.deep_orange),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
