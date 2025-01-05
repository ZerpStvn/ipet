import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipet/client/controller/notifchek.dart';
import 'package:ipet/client/pages/service/emailservice.dart';

class Bookinguser extends StatefulWidget {
  final String hotelclinicid; // The Firestore document ID (clinic/hotel ID)
  final String hotelclinicemail;
  const Bookinguser(
      {Key? key, required this.hotelclinicid, required this.hotelclinicemail})
      : super(key: key);

  @override
  State<Bookinguser> createState() => _BookinguserState();
}

class _BookinguserState extends State<Bookinguser> {
  // Firestore / Firebase references
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _emailservice = EmailService();
  // Data from Firestore
  bool _isLoading = false;
  List<String> _dogTypes = [];
  List<Map<String, dynamic>> _roomDetails = [];

  // Booking form: date selection
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _daysController = TextEditingController();

  // Booking form: room selection
  String? _selectedRoomSize;
  int? _selectedRoomCapacity;

  // Multiple dogs: each item => { "type": string, "count": int, "weight": double }
  List<Map<String, dynamic>> _dogs = [];

  // For the "Fully Booked" check
  bool _allRoomsFull = false;

  @override
  void initState() {
    super.initState();
    _fetchVetData();
  }

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

  // --------------------- FETCH DATA ---------------------
  /// Fetch the Vet/Hotel data (dogTypes, roomDetails) from Firestore
  Future<void> _fetchVetData() async {
    setState(() => _isLoading = true);
    try {
      final doc = await _firestore
          .collection('pet_services')
          .doc(widget.hotelclinicid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        final dogTypesData = data['dogTypes'] ?? [];
        final roomDetailsData = data['roomDetails'] ?? [];

        setState(() {
          _dogTypes = List<String>.from(dogTypesData);
          _roomDetails = List<Map<String, dynamic>>.from(roomDetailsData);
        });
      }
    } catch (e) {
      debugPrint("Error fetching vet data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching data: $e")),
      );
    }
    setState(() => _isLoading = false);
  }

  // --------------------- DATE SELECTION ---------------------
  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _pickEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick a start date first.")),
      );
      return;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate!.add(const Duration(days: 1)),
      firstDate: _startDate!,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  void _calculateEndDateFromDays() {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick a start date first.")),
      );
      return;
    }
    final days = int.tryParse(_daysController.text);
    if (days == null || days < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid number of days.")),
      );
      return;
    }
    setState(() {
      _endDate = _startDate!.add(Duration(days: days));
    });
  }

  // --------------------- DOGS ---------------------
  Future<void> _addDogDialog() async {
    String? selectedType;
    final countController = TextEditingController();
    final weightController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add a Dog"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dog type dropdown
              if (_dogTypes.isNotEmpty)
                DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Select Dog Type"),
                  value: selectedType,
                  items: _dogTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (val) {
                    selectedType = val;
                  },
                ),

              const SizedBox(height: 8),
              TextField(
                controller: countController,
                decoration: const InputDecoration(
                  labelText: "Number of dogs of this type",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(
                  labelText: "Single dog's weight (optional)",
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (selectedType == null || selectedType!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Select a dog type.")),
                  );
                  return;
                }
                final count = int.tryParse(countController.text) ?? 0;
                final weight = double.tryParse(weightController.text) ?? 0.0;
                if (count < 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter a valid dog count.")),
                  );
                  return;
                }

                setState(() {
                  _dogs.add({
                    "type": selectedType,
                    "count": count,
                    "weight": weight,
                  });
                });

                Navigator.pop(ctx);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // --------------------- 1 BOOKING / USER CHECK ---------------------
  /// Only check for 'status': 'active'
  /// If there's an active booking, user cannot book again
  Future<bool> _userAlreadyHasBooking(String userID) async {
    final snapshot = await _firestore
        .collection('bookings')
        .where('hotelclinicid', isEqualTo: widget.hotelclinicid)
        .where('userID', isEqualTo: userID)
        .where('status', isEqualTo: 'active') // Checking only active bookings
        .get();

    return snapshot.docs.isNotEmpty;
  }

  // --------------------- CHECK ALL ROOMS ---------------------
  /// Returns `true` if at least one room can accommodate the user's dogs for
  /// the selected date range. Otherwise, returns `false`.
  Future<bool> _checkAllRoomsAvailability(int newDogsCount) async {
    if (_startDate == null || _endDate == null) {
      // Cannot check yet if no date
      return false;
    }
    if (_roomDetails.isEmpty) return false;

    for (var room in _roomDetails) {
      final cap = room['capacity'] ?? 0;
      if (cap is int && cap >= newDogsCount) {
        // There's at least one room with enough capacity
        return true;
      }
    }
    return false;
  }

  // --------------------- BOOKING FLOW ---------------------
  Future<void> _onBookButtonPressed() async {
    // Basic validations
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select start and end dates.")),
      );
      return;
    }
    if (_dogs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Add at least one dog.")),
      );
      return;
    }

    final user = _auth.currentUser;
    final userID = user != null ? user.uid : 'Anonymous';

    // 1 booking per user check (only if status is 'active')
    final alreadyBooked = await _userAlreadyHasBooking(userID);
    if (alreadyBooked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You already have an active booking.")),
      );
      return;
    }

    // Sum dogs
    int newDogsCount = 0;
    for (var dog in _dogs) {
      newDogsCount += dog['count'] as int;
    }

    // Check if there's any room that can handle the user’s total dog count
    final canBookInSomeRoom = await _checkAllRoomsAvailability(newDogsCount);

    if (!canBookInSomeRoom) {
      setState(() {
        _allRoomsFull = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("All rooms are fully booked or too small.")),
      );
      return;
    }

    _saveBooking(userID);
  }

  final curruser = FirebaseAuth.instance.currentUser;

  /// Actually saves the booking to Firestore
  Future<void> _saveBooking(String userID) async {
    setState(() => _isLoading = true);

    try {
      final bookingData = {
        'hotelclinicid': widget.hotelclinicid,
        'userID': userID,
        'startDate': Timestamp.fromDate(_startDate!),
        'endDate': Timestamp.fromDate(_endDate!),
        'dogs': _dogs,
        'createdAt': Timestamp.now(),
        'status': 'active', // Marking new booking as active
      };

      // If user picks a room, store it
      if (_selectedRoomSize != null && _selectedRoomCapacity != null) {
        bookingData['room'] = {
          'size': _selectedRoomSize,
          'capacity': _selectedRoomCapacity,
        };
      }

      await _firestore.collection('bookings').add(bookingData);
      await sendnotification(curruser!.uid, "Booking created ", "Booking");
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking created successfully!")),
      );
      await _emailservice.sendMailVerified(
          recipientEmail: widget.hotelclinicemail,
          message:
              "We got a new Booking plesse check our website for more details - https://petgoveterinary.web.app/ ",
          subject: "Pergo - New Booking Arrive");
      Navigator.pop(context);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving booking: $e")),
      );
    }
  }

  // --------------------- UI HELPERS ---------------------
  String _formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  // --------------------- WIDGET TREE ---------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clinic / Hotel Booking"),
        backgroundColor: const Color(0xFF78AEA8),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBookingForm(context),
    );
  }

  Widget _buildBookingForm(BuildContext context) {
    return Container(
      color: const Color(0xFFF3F3F3), // Subtle background
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDatePickersCard(),
            const SizedBox(height: 16),
            _buildRoomsCard(),
            const SizedBox(height: 16),
            _buildDogsCard(),
            const SizedBox(height: 16),
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickersCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Dates",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Start date
            Row(
              children: [
                Expanded(
                  child: Text(
                    _startDate == null
                        ? "Start Date: (not selected)"
                        : "Start Date: ${_formatDate(_startDate!)}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF78AEA8),
                  ),
                  onPressed: _pickStartDate,
                  child: const Text("Pick Start"),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // End date
            Row(
              children: [
                Expanded(
                  child: Text(
                    _endDate == null
                        ? "End Date: (not selected)"
                        : "End Date: ${_formatDate(_endDate!)}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF78AEA8),
                  ),
                  onPressed: _pickEndDate,
                  child: const Text("Pick End"),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // or # of days
            const Text("Or select number of days from Start:"),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _daysController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Enter # of days",
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF78AEA8),
                  ),
                  onPressed: _calculateEndDateFromDays,
                  child: const Text("Compute End"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomsCard() {
    if (_roomDetails.isEmpty) {
      return const SizedBox();
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Room Selection (Optional)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "If you want to pick a specific room, select it here. Otherwise, we'll pick one for you.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedRoomSize,
              hint: const Text("Select a Room"),
              items: _roomDetails.map((room) {
                final size = room['size'].toString();
                final cap = room['capacity'].toString();
                return DropdownMenuItem<String>(
                  value: size,
                  child: Text("$size (capacity: $cap)"),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedRoomSize = val;
                  final matchedRoom = _roomDetails.firstWhere(
                    (r) => r['size'].toString() == val,
                    orElse: () => {'capacity': 0},
                  );
                  _selectedRoomCapacity = matchedRoom['capacity'];
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDogsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Pets",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_dogs.isEmpty)
              const Text(
                "No Pets added yet. Click 'Add Dog' to include them.",
                style: TextStyle(color: Colors.grey),
              ),
            ..._dogs.map((dog) {
              return Card(
                color: const Color(0xFFE6F2F2),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(
                    "Type: ${dog['type']},  "
                    "Count: ${dog['count']},  "
                    "Weight: ${dog['weight']}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _dogs.remove(dog);
                      });
                    },
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF78AEA8),
                ),
                onPressed: _addDogDialog,
                icon: const Icon(Icons.add),
                label: const Text("Add Pets"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    // If we determined all rooms are full, show red "Fully Booked" button
    if (_allRoomsFull) {
      return Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          onPressed: null, // Disabled
          child: const Text(
            "Fully Booked",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    // Otherwise, show the normal "Book Now" button
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF78AEA8),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        onPressed: _onBookButtonPressed,
        child: const Text(
          "Book Now",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
