import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jiffy/jiffy.dart' as jiffy;
import 'package:kingz_cut_mobile/models/appointment.dart';
// import 'appointment.dart';
import 'package:kingz_cut_mobile/enums/appointment_status.dart';

abstract class AppointmentRepository {
  Future<Either<String, List<Appointment>>> getAppointments({
    String? customerId,
    String? staffId,
    AppointmentStatus? status,
  });

  Future<Either<String, Appointment>> createAppointment(
    Appointment appointment,
  );

  Future<Either<String, void>> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  );

  Future<Either<String, void>> updateAppointment(Appointment appointment);

  Future<Either<String, void>> deleteAppointment(String appointmentId);

  Stream<List<Appointment>> watchAppointments({
    String? customerId,
    String? staffId,
  });
}

class FirebaseAppointmentRepository implements AppointmentRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'appointments';

  FirebaseAppointmentRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<String, List<Appointment>>> getAppointments({
    String? customerId,
    String? staffId,
    AppointmentStatus? status,
  }) async {
    try {
      Query query = _firestore.collection(_collection);

      if (customerId != null) {
        query = query.where('customerId', isEqualTo: customerId);
      }
      if (staffId != null) {
        query = query.where('staffId', isEqualTo: staffId);
      }
      if (status != null) {
        query = query.where('status', isEqualTo: status.name);
      }

      query = query.orderBy('startTime', descending: true);

      final snapshot = await query.get();
      final appointments =
          snapshot.docs
              .map(
                (doc) => Appointment.fromJson({
                  ...doc.data() as Map<String, dynamic>,
                  'id': doc.id,
                }),
              )
              .toList();

      return right(appointments);
    } catch (e) {
      return left('Failed to fetch appointments: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Appointment>> createAppointment(
    Appointment appointment,
  ) async {
    try {
      final now = DateTime.now();
      final appointmentData = appointment.copyWith(
        createdAt: now,
        updatedAt: now,
      );

      final appointmentExistsForToday =
          (await _firestore
                  .collection(_collection)
                  .where('customerId', isEqualTo: appointment.customerId)
                  .where(
                    'startTime',
                    isGreaterThanOrEqualTo:
                        jiffy.Jiffy.parseFromDateTime(
                          appointment.startTime,
                        ).startOf(jiffy.Unit.day).dateTime.toIso8601String(),
                  )
                  .where(
                    'endTime',
                    isLessThanOrEqualTo:
                        jiffy.Jiffy.parseFromDateTime(
                          appointment.startTime,
                        ).endOf(jiffy.Unit.day).dateTime.toIso8601String(),
                  )
                  .where('status', isEqualTo: AppointmentStatus.pending.name)
                  .limit(1)
                  .get())
              .docs
              .isNotEmpty;

      if (appointmentExistsForToday) {
        return left('You already have an appointment for the selected day.');
      }

      if (appointment.paymentReference != null) {
        await _firestore
            .collection(_collection)
            .doc(appointment.paymentReference)
            .set(appointmentData.toJson());
        final createdAppointment = appointmentData.copyWith(
          id: appointment.paymentReference,
        );
        return right(createdAppointment);
      } else {
        final docRef = await _firestore
            .collection(_collection)
            .add(appointmentData.toJson());
        final createdAppointment = appointmentData.copyWith(id: docRef.id);
        return right(createdAppointment);
      }
    } catch (e) {
      return left('Failed to create appointment: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  ) async {
    try {
      await _firestore.collection(_collection).doc(appointmentId).update({
        'status': status.name,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return right(null);
    } catch (e) {
      return left('Failed to update appointment status: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> updateAppointment(
    Appointment appointment,
  ) async {
    try {
      if (appointment.id == null) {
        return left('Appointment ID is required for update');
      }

      final updateData =
          appointment.copyWith(updatedAt: DateTime.now()).toJson();

      // Remove id from the data to update
      updateData.remove('id');

      await _firestore
          .collection(_collection)
          .doc(appointment.id)
          .update(updateData);

      return right(null);
    } catch (e) {
      return left('Failed to update appointment: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> deleteAppointment(String appointmentId) async {
    try {
      await _firestore.collection(_collection).doc(appointmentId).delete();
      return right(null);
    } catch (e) {
      return left('Failed to delete appointment: ${e.toString()}');
    }
  }

  @override
  Stream<List<Appointment>> watchAppointments({
    String? customerId,
    String? staffId,
  }) {
    Query query = _firestore.collection(_collection);

    if (customerId != null) {
      query = query.where('customerId', isEqualTo: customerId);
    }
    if (staffId != null) {
      query = query.where('staffId', isEqualTo: staffId);
    }

    query = query.orderBy('startTime', descending: true);

    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) => Appointment.fromJson({
                  ...doc.data() as Map<String, dynamic>,
                  'id': doc.id,
                }),
              )
              .toList(),
    );
  }
}
