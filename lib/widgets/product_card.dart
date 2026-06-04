// lib/widgets/product_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final discountedPrice =
        product.price * (1 - product.discountPercentage / 100);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero image ──────────────────────────────────────
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: CachedNetworkImage(
              imageUrl: product.thumbnail,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                height: 200,
                color: Colors.grey.shade200,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                height: 200,
                color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image,
                    size: 48, color: Colors.grey),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Category + rating row ─────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CategoryChip(label: product.category),
                    _RatingBadge(rating: product.rating),
                  ],
                ),
                const SizedBox(height: 8),

                // ── Title ─────────────────────────────────────
                Text(
                  product.title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // ── Brand ─────────────────────────────────────
                Text(
                  'by ${product.brand}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),

                // ── Description ───────────────────────────────
                Text(
                  product.description,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey.shade700, height: 1.4),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),

                // ── Price + CTA row ───────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${discountedPrice.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        if (product.discountPercentage > 0)
                          Row(
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '-${product.discountPercentage.toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.shopping_cart_outlined, size: 16),
                      label: const Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Stock indicator ───────────────────────────
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.inventory_2_outlined,
                        size: 14,
                        color: product.stock > 0
                            ? Colors.green.shade600
                            : Colors.red.shade600),
                    const SizedBox(width: 4),
                    Text(
                      product.stock > 0
                          ? '${product.stock} in stock'
                          : 'Out of stock',
                      style: TextStyle(
                        fontSize: 12,
                        color: product.stock > 0
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;
  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
