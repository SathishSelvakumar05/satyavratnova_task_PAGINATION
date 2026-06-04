import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import '../repository/product_repository.dart';
import 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  final ProductRepository _repository;

  FeedCubit({required ProductRepository repository})
      : _repository = repository,
        super(const FeedState());

  Future<void> loadFeed({bool refresh = false}) async {
    if (state.status == FeedStatus.loading) return;

    emit(state.copyWith(
      status: FeedStatus.loading,
      products: refresh ? [] : state.products,
      currentSkip: refresh ? 0 : state.currentSkip,
      hasReachedMax: refresh ? false : state.hasReachedMax,
      errorMessage: null,
    ));

    try {
      final response = await _repository.fetchProducts(skip: 0);
      emit(state.copyWith(
        status: FeedStatus.success,
        products: response.products,
        currentSkip: response.products.length,
        hasReachedMax: response.products.length >= response.total,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FeedStatus.failure,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        products: refresh ? [] : state.products,
      ));
    }
  }

  Future<void> loadMore() async {
    if (state.status == FeedStatus.loadingMore ||
        state.status == FeedStatus.loading ||
        state.hasReachedMax) return;

    emit(state.copyWith(status: FeedStatus.loadingMore));

    try {
      final response =
          await _repository.fetchProducts(skip: state.currentSkip);

      final updatedProducts = List<Product>.from(state.products)
        ..addAll(response.products);

      emit(state.copyWith(
        status: FeedStatus.success,
        products: updatedProducts,
        currentSkip: state.currentSkip + response.products.length,
        hasReachedMax: updatedProducts.length >= response.total,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FeedStatus.success,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}
