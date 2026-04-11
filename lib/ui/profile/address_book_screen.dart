import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/utils/address_service.dart';

class AddressBookScreen extends StatefulWidget {
  final bool isSelecting;

  const AddressBookScreen({super.key, this.isSelecting = false});

  @override
  _AddressBookScreenState createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  @override
  void initState() {
    super.initState();
    AddressService.addDemoAddresses();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> addresses = AddressService.getAddresses();
    int? defaultIndex = AddressService.getDefaultAddressIndex();

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
          widget.isSelecting ? "ঠিকানা বাছুন" : "আমার ঠিকানাসমূহ",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAddressDialog(),
        backgroundColor: AppColors.deepOrange,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          "নতুন ঠিকানা",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off,
                    size: 80.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "কোনো ঠিকানা নেই",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "নতুন ঠিকানা যোগ করুন",
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return _buildAddressCard(
                  addresses[index],
                  index,
                  index == defaultIndex,
                );
              },
            ),
    );
  }

  Widget _buildAddressCard(
    Map<String, dynamic> address,
    int index,
    bool isDefault,
  ) {
    String labelIcon = AddressService.getLabelIcon(address["label"]);

    return GestureDetector(
      onTap: widget.isSelecting
          ? () {
              AddressService.setDefaultAddress(index);
              Navigator.pop(context, address);
            }
          : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: isDefault
              ? Border.all(color: AppColors.deepOrange, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(labelIcon, style: TextStyle(fontSize: 24.sp)),
                SizedBox(width: 10.w),
                Text(
                  address["label"],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isDefault) ...[
                  SizedBox(width: 10.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.deepOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Default",
                      style: TextStyle(
                        color: AppColors.deepOrange,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditAddressDialog(address, index);
                    } else if (value == 'delete') {
                      _deleteAddress(index);
                    } else if (value == 'default') {
                      setState(() {
                        AddressService.setDefaultAddress(index);
                      });
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'default',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 20),
                          SizedBox(width: 10),
                          Text("Default করুন"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 10),
                          Text("এডিট"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 10),
                          Text("ডিলিট", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  icon: Icon(Icons.more_vert, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Text(
              address["name"],
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5.h),
            Text(
              address["phone"],
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            Text(
              AddressService.getFormattedAddress(address),
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAddressDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController(text: "Dhaka");
    final areaController = TextEditingController();
    final postalController = TextEditingController();
    String selectedLabel = "Home";
    bool setAsDefault = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Padding(
            padding: EdgeInsets.all(25.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "নতুন ঠিকানা যোগ করুন",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // Label Selection
                  Text(
                    "ঠিকানার ধরন",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: ["Home", "Office", "Other"].map((label) {
                      bool isSelected = selectedLabel == label;
                      return Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: isSelected,
                          selectedColor: AppColors.deepOrange,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          onSelected: (selected) {
                            setModalState(() {
                              selectedLabel = label;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),

                  _buildTextField(nameController, "পুরো নাম", Icons.person),
                  SizedBox(height: 15.h),
                  _buildTextField(
                    phoneController,
                    "ফোন নম্বর",
                    Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 15.h),
                  _buildTextField(
                    addressController,
                    "সম্পূর্ণ ঠিকানা",
                    Icons.location_on,
                    maxLines: 2,
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          cityController,
                          "শহর",
                          Icons.location_city,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildTextField(
                          areaController,
                          "এলাকা",
                          Icons.map,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  _buildTextField(
                    postalController,
                    "পোস্ট কোড",
                    Icons.local_post_office,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20.h),

                  Row(
                    children: [
                      Checkbox(
                        value: setAsDefault,
                        onChanged: (val) {
                          setModalState(() {
                            setAsDefault = val ?? false;
                          });
                        },
                        activeColor: AppColors.deepOrange,
                      ),
                      Text(
                        "Default ঠিকানা হিসেবে সেট করুন",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),

                  SizedBox(
                    width: double.infinity,
                    height: 55.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isNotEmpty &&
                            phoneController.text.isNotEmpty &&
                            addressController.text.isNotEmpty) {
                          AddressService.addAddress(
                            name: nameController.text,
                            phone: phoneController.text,
                            address: addressController.text,
                            city: cityController.text,
                            area: areaController.text,
                            postalCode: postalController.text,
                            label: selectedLabel,
                            setAsDefault: setAsDefault,
                          );
                          Navigator.pop(context);
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("ঠিকানা যোগ হয়েছে!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        "ঠিকানা সেভ করুন",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.deepOrange),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.deepOrange),
        ),
      ),
    );
  }

  void _showEditAddressDialog(Map<String, dynamic> address, int index) {
    final nameController = TextEditingController(text: address["name"]);
    final phoneController = TextEditingController(text: address["phone"]);
    final addressController = TextEditingController(text: address["address"]);
    final cityController = TextEditingController(text: address["city"]);
    final areaController = TextEditingController(text: address["area"]);
    final postalController = TextEditingController(text: address["postalCode"]);
    String selectedLabel = address["label"];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Padding(
            padding: EdgeInsets.all(25.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "ঠিকানা এডিট করুন",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 25.h),

                  Text(
                    "ঠিকানার ধরন",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: ["Home", "Office", "Other"].map((label) {
                      bool isSelected = selectedLabel == label;
                      return Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: isSelected,
                          selectedColor: AppColors.deepOrange,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          onSelected: (selected) {
                            setModalState(() {
                              selectedLabel = label;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),

                  _buildTextField(nameController, "পুরো নাম", Icons.person),
                  SizedBox(height: 15.h),
                  _buildTextField(
                    phoneController,
                    "ফোন নম্বর",
                    Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 15.h),
                  _buildTextField(
                    addressController,
                    "সম্পূর্ণ ঠিকানা",
                    Icons.location_on,
                    maxLines: 2,
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          cityController,
                          "শহর",
                          Icons.location_city,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildTextField(
                          areaController,
                          "এলাকা",
                          Icons.map,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  _buildTextField(
                    postalController,
                    "পোস্ট কোড",
                    Icons.local_post_office,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 25.h),

                  SizedBox(
                    width: double.infinity,
                    height: 55.h,
                    child: ElevatedButton(
                      onPressed: () {
                        AddressService.updateAddress(
                          index,
                          name: nameController.text,
                          phone: phoneController.text,
                          address: addressController.text,
                          city: cityController.text,
                          area: areaController.text,
                          postalCode: postalController.text,
                          label: selectedLabel,
                        );
                        Navigator.pop(context);
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("ঠিকানা আপডেট হয়েছে!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        "আপডেট করুন",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _deleteAddress(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ঠিকানা ডিলিট করুন"),
        content: Text("আপনি কি নিশ্চিত এই ঠিকানা ডিলিট করতে চান?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("না"),
          ),
          ElevatedButton(
            onPressed: () {
              AddressService.deleteAddress(index);
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("ঠিকানা ডিলিট হয়েছে"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              "হ্যাঁ, ডিলিট করুন",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
