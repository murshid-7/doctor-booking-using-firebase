import 'package:flutter/material.dart';
import 'package:grocery_online_shop/controller/admin_provider.dart';
import 'package:grocery_online_shop/controller/appointment_provider.dart';
import 'package:grocery_online_shop/model/appointment_model.dart';
import 'package:grocery_online_shop/model/doctor_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppointmentProvider>(context, listen: false).getAllAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blue[50], 
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2), 
        title: const Text(
          'Appointment Summary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildFilterButton('All'),
                const SizedBox(width: 12),
                _buildFilterButton('Today'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<AppointmentProvider>(
                builder: (context, appointmentProvider, child) {
                  if (appointmentProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<AppointmentModel> appointments = _filterAppointments(appointmentProvider.allAppointmentList);

                  if (appointments.isEmpty) {
                    return const Center(
                      child: Text(
                        'No appointments found',
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index];
                      return FutureBuilder<DoctorModel?>(
                        future: Provider.of<DoctorProvider>(context, listen: false).getDoctorById(appointment.docId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return const Center(child: Text('Failed to load doctor details'));
                          }

                          final doctor = snapshot.data;

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.width * 0.02),
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(size.width * 0.04),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dr. ${doctor?.fullName ?? 'Unknown'}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1976D2),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Date: ${appointment.date}',
                                    style: TextStyle(fontSize: 14, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Time: ${appointment.time}',
                                    style: TextStyle(fontSize: 14, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Text(
                                        'Status: ',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(appointment.status),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          appointment.status ?? 'Pending',
                                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    bool isSelected = _selectedFilter == label;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black, 
        backgroundColor: isSelected ? const Color(0xFF1976D2) : Colors.grey[300],
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }

  List<AppointmentModel> _filterAppointments(List<AppointmentModel> appointments) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (_selectedFilter == 'Today') {
      return appointments.where((appointment) => appointment.date == today).toList();
    }
    return appointments;
  }

  Color _getStatusColor(String? status) {
    if (status == 'Approved' || status == 'Completed') {
      return Colors.green;
    } else if (status == 'Cancelled') {
      return Colors.red;
    } else if (status == 'Pending' || status == 'Accepted') {
      return Colors.orange;
    }
    return Colors.grey;
  }
}
