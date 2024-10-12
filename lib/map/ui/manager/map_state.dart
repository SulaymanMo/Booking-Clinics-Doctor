part of 'map_cubit.dart';

@immutable
sealed class MapState {}

final class MapInitial extends MapState {}

final class MapSuccess extends MapState {}

final class MapLoading extends MapState {}

final class MarkerClicked extends MapState {
  final DoctorModel model;
  MarkerClicked(this.model);
}

final class MapFailure extends MapState {
  final String error;
  MapFailure(this.error);
}
