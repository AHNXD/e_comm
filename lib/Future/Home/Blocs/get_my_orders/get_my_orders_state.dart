part of 'get_my_orders_bloc.dart';

enum GetMyOrdersStatus { loading, success, error }

class GetMyOrdersState extends Equatable {
  final GetMyOrdersStatus status;
  final List<OrderInformationData> my_orders;
  final bool hasReachedMax;
  final String errorMsg;
  final int currentPage;
  final int totalPages;

  const GetMyOrdersState({
    this.status = GetMyOrdersStatus.loading,
    this.hasReachedMax = false,
    this.my_orders = const [],
    this.errorMsg = '',
    this.currentPage = 1,
    this.totalPages = 1,
  });

  GetMyOrdersState copyWith({
    GetMyOrdersStatus? status,
    List<OrderInformationData>? my_orders,
    bool? hasReachedMax,
    String? errorMsg,
    int? currentPage,
    int? totalPages,
  }) {
    return GetMyOrdersState(
      status: status ?? this.status,
      my_orders: my_orders ?? this.my_orders,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMsg: errorMsg ?? this.errorMsg,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object> get props => [
        status,
        my_orders,
        hasReachedMax,
        errorMsg,
        currentPage,
        totalPages
      ];
}
