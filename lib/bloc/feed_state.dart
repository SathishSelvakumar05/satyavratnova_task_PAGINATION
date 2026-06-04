import 'package:equatable/equatable.dart';
import '../models/product.dart';

enum FeedStatus { initial, loading, success, failure, loadingMore }

class FeedState extends Equatable {
  final FeedStatus status;
  final List<Product> products;
  final String? errorMessage;
  final bool hasReachedMax;
  final int currentSkip;

  const FeedState({
    this.status = FeedStatus.initial,
    this.products = const [],
    this.errorMessage,
    this.hasReachedMax = false,
    this.currentSkip = 0,
  });

  FeedState copyWith({
    FeedStatus? status,
    List<Product>? products,
    String? errorMessage,
    bool? hasReachedMax,
    int? currentSkip,
  }) {
    return FeedState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentSkip: currentSkip ?? this.currentSkip,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        errorMessage,
        hasReachedMax,
        currentSkip,
      ];
}
