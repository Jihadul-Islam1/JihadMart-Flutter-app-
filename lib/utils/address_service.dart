class AddressService {
  static final List<Map<String, dynamic>> _addresses = [];
  static int? _defaultAddressIndex;

  static List<Map<String, dynamic>> getAddresses() {
    return _addresses;
  }

  static Map<String, dynamic>? getDefaultAddress() {
    if (_defaultAddressIndex != null &&
        _defaultAddressIndex! < _addresses.length) {
      return _addresses[_defaultAddressIndex!];
    }
    if (_addresses.isNotEmpty) {
      return _addresses[0];
    }
    return null;
  }

  static int? getDefaultAddressIndex() {
    return _defaultAddressIndex;
  }

  static void addAddress({
    required String name,
    required String phone,
    required String address,
    required String city,
    required String area,
    required String postalCode,
    required String label, // Home, Office, Other
    bool setAsDefault = false,
  }) {
    Map<String, dynamic> newAddress = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "name": name,
      "phone": phone,
      "address": address,
      "city": city,
      "area": area,
      "postalCode": postalCode,
      "label": label,
      "createdAt": DateTime.now(),
    };

    _addresses.add(newAddress);

    if (setAsDefault || _addresses.length == 1) {
      _defaultAddressIndex = _addresses.length - 1;
    }
  }

  static void updateAddress(
    int index, {
    String? name,
    String? phone,
    String? address,
    String? city,
    String? area,
    String? postalCode,
    String? label,
  }) {
    if (index >= 0 && index < _addresses.length) {
      if (name != null) _addresses[index]["name"] = name;
      if (phone != null) _addresses[index]["phone"] = phone;
      if (address != null) _addresses[index]["address"] = address;
      if (city != null) _addresses[index]["city"] = city;
      if (area != null) _addresses[index]["area"] = area;
      if (postalCode != null) _addresses[index]["postalCode"] = postalCode;
      if (label != null) _addresses[index]["label"] = label;
    }
  }

  static void deleteAddress(int index) {
    if (index >= 0 && index < _addresses.length) {
      _addresses.removeAt(index);

      // Update default index
      if (_defaultAddressIndex == index) {
        _defaultAddressIndex = _addresses.isNotEmpty ? 0 : null;
      } else if (_defaultAddressIndex != null &&
          _defaultAddressIndex! > index) {
        _defaultAddressIndex = _defaultAddressIndex! - 1;
      }
    }
  }

  static void setDefaultAddress(int index) {
    if (index >= 0 && index < _addresses.length) {
      _defaultAddressIndex = index;
    }
  }

  static String getFormattedAddress(Map<String, dynamic> address) {
    return "${address['address']}, ${address['area']}, ${address['city']} - ${address['postalCode']}";
  }

  static String getLabelIcon(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return '🏠';
      case 'office':
        return '🏢';
      default:
        return '📍';
    }
  }

  // Add demo addresses
  static void addDemoAddresses() {
    if (_addresses.isEmpty) {
      addAddress(
        name: "Jihad Islam",
        phone: "01712345678",
        address: "House 45, Road 12, Block C",
        city: "Dhaka",
        area: "Dhanmondi",
        postalCode: "1205",
        label: "Home",
        setAsDefault: true,
      );

      addAddress(
        name: "Jihad Islam",
        phone: "01712345678",
        address: "Office 502, Tower 3",
        city: "Dhaka",
        area: "Gulshan",
        postalCode: "1212",
        label: "Office",
      );
    }
  }
}
