import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/feed_cubit.dart';
import '../bloc/feed_state.dart';
import '../widgets/product_card.dart';
import '../widgets/shimmer_card.dart';
import '../widgets/error_view.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _scrollController = ScrollController();
  static const _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    context.read<FeedCubit>().loadFeed();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxExtent = _scrollController.position.maxScrollExtent;
    final currentExtent = _scrollController.offset;
    if (maxExtent - currentExtent <= _scrollThreshold) {
      context.read<FeedCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [_buildAppBar()],
        body: BlocConsumer<FeedCubit, FeedState>(
          listener: (context, state) {
            if (state.status == FeedStatus.success &&
                state.errorMessage != null &&
                state.products.isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    action: SnackBarAction(
                      label: 'Retry',
                      onPressed: () => context.read<FeedCubit>().loadMore(),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red.shade600,
                  ),
                );
            }
          },
          builder: (context, state) {
            if (state.status == FeedStatus.failure &&
                state.products.isEmpty) {
              return ErrorView(
                message: state.errorMessage ?? 'Unknown error occurred.',
                onRetry: () => context.read<FeedCubit>().loadFeed(),
              );
            }

            if (state.status == FeedStatus.loading &&
                state.products.isEmpty) {
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<FeedCubit>().loadFeed(refresh: true),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsRow(context, 0, 0),
                      const ShimmerList(itemCount: 6),
                    ],
                  ),
                ),
              );
            }

            final products = state.products;

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<FeedCubit>().loadFeed(refresh: true),
              displacement: 20,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildStatsRow(context, products.length,
                        state.hasReachedMax ? products.length : null),
                  ),

                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ProductCard(
                          product: products[index]),
                      childCount: products.length,
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: _buildBottomWidget(state),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: const Text(
          '🛍️ Product Feed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.tertiary,
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () => context.read<FeedCubit>().loadFeed(refresh: true),
          tooltip: 'Refresh feed',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildStatsRow(
      BuildContext context, int loaded, int? total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          const Icon(Icons.grid_view_rounded, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Text(
            total != null
                ? 'Showing $loaded of $total products'
                : loaded > 0
                    ? '$loaded products loaded'
                    : 'Loading products…',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomWidget(FeedState state) {
    if (state.status == FeedStatus.loadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Loading more…',
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
      );
    }

    if (state.hasReachedMax && state.products.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Colors.green, size: 28),
              const SizedBox(height: 6),
              Text(
                "You've seen all ${state.products.length} products!",
                style:
                    const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox(height: 24);
  }
}
