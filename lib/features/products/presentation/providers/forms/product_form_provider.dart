import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/constants/environment/environment.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  final createUpdateCallback =
      ref.watch(productsProvider.notifier).createOrUpdateProduct;
  return ProductFormNotifier(
      product: product, onSubmitCallback: createUpdateCallback);
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<bool> Function(Map<String, dynamic> productLike)?
      onSubmitCallback;

  ProductFormNotifier({this.onSubmitCallback, required Product product})
      : super(ProductFormState(
          id: product.id,
          title: Title.dirty(product.title),
          inStock: Stock.dirty(product.stock),
          slug: Slug.dirty(product.slug),
          price: Price.dirty(product.price),
          description: product.description,
          gender: product.gender,
          images: product.images,
          isFormValid: true,
          sizes: product.sizes,
          tags: product.tags.join(', '),
        ));

  Future<bool> onFormSubmit() async {
    _touchEverything();

    if (onSubmitCallback == null) return false;

    final productLike = {
      'id': state.id == 'new' ? null : state.id,
      'slug': state.slug.value,
      'price': state.price.value,
      'title': state.title.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'stock': state.inStock.value,
      'description': state.description,
      'tags': state.tags.split(','),
      'images': state.images
          .map((image) =>
              image.replaceAll('${Environment.apiUrl}/files/product/', ''))
          .toList(),
    };

    print(productLike);

    try {
      return onSubmitCallback!(productLike);
    } catch (e) {
      return false;
    }
  }

  void _touchEverything() {
    state = state.copyWith(
      title: Title.dirty(state.title.value),
      inStock: Stock.dirty(state.inStock.value),
      slug: Slug.dirty(state.slug.value),
      price: Price.dirty(state.price.value),
    );
  }

  void updateProductImage(String path) {
    state = state.copyWith(images: [...state.images, path]);
  }

  void onTitleChanged(String value) {
    state = state.copyWith(
        title: Title.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value)
        ]));
  }

  void onSlugChange(String value) {
    state = state.copyWith(
        slug: Slug.dirty(value),
        isFormValid: Formz.validate([
          Slug.dirty(value),
          Title.dirty(state.title.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value)
        ]));
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
        price: Price.dirty(value),
        isFormValid: Formz.validate([
          Price.dirty(value),
          Slug.dirty(state.slug.value),
          Title.dirty(state.title.value),
          Stock.dirty(state.inStock.value)
        ]));
  }

  void onStockChanged(int value) {
    state = state.copyWith(
        inStock: Stock.dirty(value),
        isFormValid: Formz.validate([
          Stock.dirty(value),
          Slug.dirty(state.slug.value),
          Title.dirty(state.title.value),
          Price.dirty(state.price.value)
        ]));
  }

  void onSizeChanged(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onGenderChange(String gender) {
    state = state.copyWith(gender: gender);
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(tags: tags);
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(description: description);
  }
}

class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Slug slug;
  final Price price;
  final Title title;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState(
      {this.isFormValid = false,
      this.id,
      this.slug = const Slug.dirty(''),
      this.title = const Title.dirty(''),
      this.price = const Price.dirty(0),
      this.sizes = const [],
      this.gender = 'men',
      this.inStock = const Stock.dirty(0),
      this.description = '',
      this.tags = '',
      this.images = const []});

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Slug? slug,
    Price? price,
    Title? title,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      ProductFormState(
          description: description ?? this.description,
          gender: gender ?? this.gender,
          id: id ?? this.id,
          images: images ?? this.images,
          inStock: inStock ?? this.inStock,
          isFormValid: isFormValid ?? this.isFormValid,
          price: price ?? this.price,
          sizes: sizes ?? this.sizes,
          slug: slug ?? this.slug,
          tags: tags ?? this.tags,
          title: title ?? this.title);
}
