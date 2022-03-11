import 'package:squick/models/sort.dart';

class Pageable {
  Sort sort;
  int pageNumber;
  int pageSize;
  int offset;
  bool paged;
  bool unpaged;

  Pageable({
    required this.sort,
    required this.pageNumber,
    required this.pageSize,
    required this.offset,
    required this.paged,
    required this.unpaged
  });
}