import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ipet/client/pages/service/emailservice.dart';

class BookingDetails extends StatefulWidget {
  final String hotelclinicid;
  final String hotelclinicidemail;

  const BookingDetails({
    Key? key,
    required this.hotelclinicid,
    required this.hotelclinicidemail,
  }) : super(key: key);

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  bool _isLoading = false;
  DocumentSnapshot? _bookingDoc;

  @override
  void initState() {
    super.initState();
    _fetchBookingDetails();
    debugPrint("email ${widget.hotelclinicidemail}");
  }

  /// Fetch the active booking doc from Firestore
  Future<void> _fetchBookingDetails() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('hotelclinicid', isEqualTo: widget.hotelclinicid)
          .where('userID', isEqualTo: user.uid)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _bookingDoc = snapshot.docs.first;
      }
    } catch (e) {
      debugPrint("Error fetching booking details: $e");
    }
    setState(() => _isLoading = false);
  }

  final _emailservice = EmailService();

  /// Cancel the booking by updating Firestore doc to 'cancelled'
  Future<void> _cancelBooking() async {
    if (_bookingDoc == null) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(_bookingDoc!.id)
          .update({
        'status': 'cancelled',
        'cancelledAt': Timestamp.now(),
      });
      await _emailservice.sendMailVerified(
          recipientEmail: widget.hotelclinicidemail,
          message:
              "BookID ${_bookingDoc!.id} : user Cancelled booking - https://petgoveterinary.web.app/ ",
          subject: "PetGo Cancelled Booking");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking cancelled successfully.")),
      );

      // Refresh the booking data
      _bookingDoc = null;
      await _fetchBookingDetails();
    } catch (e) {
      debugPrint("Error cancelling booking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cancelling booking: $e")),
      );
    }
    setState(() => _isLoading = false);
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('MM/dd/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Details"),
        backgroundColor: const Color(0xFF78AEA8),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_bookingDoc == null) {
      return const Center(
        child: Text(
          "No active booking found.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    final data = _bookingDoc!.data() as Map<String, dynamic>;
    final startDate = data['startDate'] as Timestamp?;
    final endDate = data['endDate'] as Timestamp?;
    final status = data['status'] ?? 'unknown';
    final List<dynamic> dogs = data['dogs'] ?? [];
    final room = data['room'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Booking Status: $status",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (startDate != null)
                Text("Start Date: ${_formatDate(startDate)}"),
              if (endDate != null) Text("End Date:   ${_formatDate(endDate)}"),
              const Divider(height: 24, thickness: 1),

              // Room details (if stored)
              if (room != null) ...[
                Text(
                  "Room: ${room['size']}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text("Capacity: ${room['capacity']}"),
                const Divider(height: 24, thickness: 1),
              ],

              // Dogs
              const Text(
                "Dogs:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              if (dogs.isEmpty)
                const Text("No dogs found in this booking.")
              else
                ...dogs.map((dog) {
                  final type = dog['type'] ?? 'Unknown';
                  final count = dog['count'] ?? 0;
                  final weight = dog['weight'] ?? 0.0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "Type: $type, Count: $count, Weight: $weight",
                    ),
                  );
                }).toList(),

              const SizedBox(height: 24),
              if (status == 'active')
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    onPressed: _cancelBooking,
                    child: const Text(
                      "Cancel Booking",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              else
                Center(
                  child: Text(
                    "This booking is $status.",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
