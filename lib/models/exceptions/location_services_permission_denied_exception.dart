class LocationServicesPermissionDeniedException implements Exception {
  const LocationServicesPermissionDeniedException();

  @override
  String toString() => 'Пермисиите за локација се одбиени.';
}