/// Data model for the logged-in warehouse staff. Data only, no logic.
class StaffUser {
  final String fullName;
  final String initials;
  final String role;
  final String shiftLeadId; // e.g. "Shift Lead #402"
  final String site; // e.g. "Austin - 01"
  final String email;
  final String phone;
  final String badgeId;
  final String emergencyContact;
  final String currentShift;
  final String hardwareLink;
  final String terminal; // e.g. "WH - 04"

  const StaffUser({
    required this.fullName,
    required this.initials,
    required this.role,
    required this.shiftLeadId,
    required this.site,
    required this.email,
    required this.phone,
    required this.badgeId,
    required this.emergencyContact,
    required this.currentShift,
    required this.hardwareLink,
    required this.terminal,
  });
}
