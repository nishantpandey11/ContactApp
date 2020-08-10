import 'package:equatable/equatable.dart';

abstract class ContactEvent extends Equatable {}

class FetchContactEvent extends ContactEvent {
  @override
  List<Object> get props => null;
}
