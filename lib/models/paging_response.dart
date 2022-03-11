import 'package:squick/models/pageable.dart';
import 'package:squick/models/sort.dart';

class PagingResponse {
  List<dynamic> content;
  Pageable pageable;
  bool last;
  int totalElements;
  int totalPages;
  bool first;
  Sort sort;
  int size;
  int number;
  int numberOfElements;
  bool empty;

  PagingResponse({
    required this.content,
    required this.pageable,
    required this.last,
    required this.totalElements,
    required this.totalPages,
    required this.first,
    required this.sort,
    required this.size,
    required this.number,
    required this.numberOfElements,
    required this.empty
  });
}