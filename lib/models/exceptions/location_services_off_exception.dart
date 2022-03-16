class LocationServicesOffException implements Exception {
  const LocationServicesOffException();

  @override
  String toString() => 'Локациските сервиси се исклучени.';
}