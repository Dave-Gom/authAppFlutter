import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/domain/repositories/products_repository.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

final productProvider = StateNotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>((ref, productId) {
  final productsRepository = ref.watch(productsRepositoryProvider);

  return ProductNotifier(
      productId: productId, productsRepository: productsRepository);
});

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductsRepository productsRepository;

  ProductNotifier({required this.productsRepository, required String productId})
      : super(ProductState(id: productId)) {
    loadProduct();
  }

  Product _newEmptyProduct() {
    return Product(
      id: 'new',
      title: '',
      price: 0,
      description: '',
      slug: '',
      stock: 0,
      sizes: ['s'],
      gender: 'men',
      tags: [],
      images: [],
    );
  }

  Future<void> loadProduct() async {
    try {
      if (state.id == 'new') {
        state = state.copyWith(
            isLoading: false, id: 'new', product: _newEmptyProduct());
        return;
      }
      final product = await productsRepository.getProductById(state.id);

      state = state.copyWith(
        product: product,
        isLoading: false,
      );
    } catch (e) {}
  }
}

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState(
      {required this.id,
      this.product,
      this.isLoading = true,
      this.isSaving = false});

  ProductState copyWith(
          {String? id, Product? product, bool? isLoading, bool? isSaving}) =>
      ProductState(
          id: id ?? this.id,
          product: product ?? this.product,
          isLoading: isLoading ?? this.isLoading,
          isSaving: isSaving ?? this.isSaving);
}
