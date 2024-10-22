part of 'maintenance_cubit.dart';

@immutable
sealed class MaintenanceState {}

final class MaintenanceInitial extends MaintenanceState {}

final class MaintenanceLoading extends MaintenanceState {}

final class MaintenanceSuccess extends MaintenanceState {
  final String msg;

  MaintenanceSuccess({required this.msg});
}

final class MaintenanceError extends MaintenanceState {
  final String error;

  MaintenanceError({required this.error});
}
