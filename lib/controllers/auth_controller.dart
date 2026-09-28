import '../models/staff_model.dart';

/// Pure login rules. No Flutter state here — AuthProvider calls this.
/// There is no backend in this assignment, so a single demo account is used.
class AuthController {
  AuthController._();

  static const demoEmail = 'nailatabina@staff.co.id';
  static const demoPassword = 'warehouse123';

  static const demoUser = StaffUser(
    fullName: 'Tabina Naila',
    initials: 'TN',
    role: 'Warehouse Operations Supervisor',
    shiftLeadId: 'Shift Lead #402',
    site: 'Austin - 01',
    email: demoEmail,
    phone: '+62 812-3456-7890',
    badgeId: 'BDG-402-TN',
    emergencyContact: 'Rudi Santoso - +62 813-9876-5432',
    currentShift: 'Alpha (07.00 - 18.00)',
    hardwareLink: 'Zebra TC57 RH #12',
    terminal: 'WH - 04',
  );

  /// Returns null when the credentials are valid, otherwise the error text
  /// to show under the password field.
  static String? validate(String email, String password) {
    if (email.trim().isEmpty || password.isEmpty) {
      return 'Please enter your email and password';
    }
    final ok =
        email.trim().toLowerCase() == demoEmail && password == demoPassword;
    return ok ? null : 'Invalid Employee ID or Password';
  }
}
