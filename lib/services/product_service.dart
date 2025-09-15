import '../models/product_model.dart';
import 'firebase_service.dart';

class ProductService {
  static Future<List<ProductModel>> getProducts(String restaurantId) async {
    try {
      final querySnapshot = await FirebaseService.products
          .where('restaurantId', isEqualTo: restaurantId)
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;  // Adiciona o ID do documento
            return ProductModel.fromMap(data);
          })
          .toList();
    } catch (e) {
      throw Exception('Erro ao carregar produtos: $e');
    }
  }

  static Future<List<ProductModel>> getProductsByCategory(
      String restaurantId, String categoryId) async {
    try {
      final querySnapshot = await FirebaseService.products
          .where('restaurantId', isEqualTo: restaurantId)
          .where('categoryId', isEqualTo: categoryId)
          .get();

      final allProducts = querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;  // Adiciona o ID do documento
            return ProductModel.fromMap(data);
          })
          .toList();

      // Filtrar isActive localmente para evitar índice composto
      final activeProducts = allProducts.where((product) => product.isActive).toList();
      
      return activeProducts;
    } catch (e) {
      throw Exception('Erro ao carregar produtos da categoria: $e');
    }
  }

  static Stream<List<ProductModel>> getProductsStream(String restaurantId) {
    return FirebaseService.products
        .where('restaurantId', isEqualTo: restaurantId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;  // Adiciona o ID do documento
              return ProductModel.fromMap(data);
            })
            .toList());
  }

  static Stream<List<ProductModel>> getProductsByCategoryStream(
      String restaurantId, String categoryId) {
    return FirebaseService.products
        .where('restaurantId', isEqualTo: restaurantId)
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;  // Adiciona o ID do documento
              return ProductModel.fromMap(data);
            })
            .where((product) => product.isActive) // Filtro local
            .toList());
  }

  static Future<void> createProduct(ProductModel product) async {
    try {
      await FirebaseService.products.doc(product.id).set(product.toMap());
    } catch (e) {
      throw Exception('Erro ao criar produto: $e');
    }
  }

  static Future<void> updateProduct(ProductModel product) async {
    try {
      await FirebaseService.products.doc(product.id).update(product.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar produto: $e');
    }
  }

  static Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseService.products.doc(productId).update({
        'isActive': false,
      });
    } catch (e) {
      throw Exception('Erro ao deletar produto: $e');
    }
  }

  static Future<ProductModel?> getProduct(String productId) async {
    try {
      final doc = await FirebaseService.products.doc(productId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;  // Adiciona o ID do documento
        return ProductModel.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar produto: $e');
    }
  }
}