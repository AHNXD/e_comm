part of 'post_orders_cubit.dart';

@immutable
sealed class PostOrdersState {}

final class PostOrdersInitial extends PostOrdersState {}

final class PostOrdersLoadingState extends PostOrdersState {}

final class PostOrdersErrorState extends PostOrdersState {
  final String msg;
  PostOrdersErrorState(this.msg);
}

final class PostOrdersSuccessfulState extends PostOrdersState {}
