import 'package:flutter/material.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _ImageViewer(images: product.images),
          Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final List<String> images;
  const _ImageViewer({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/no-image.jpg',
          fit: BoxFit.fitHeight,
          height: 250,
        ),
      );
    }

    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FadeInImage(
          fit: BoxFit.cover,
          image: NetworkImage(images.first),
          placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
        ));
  }
}
