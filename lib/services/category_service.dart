import '../models/category_model.dart';
import 'firebase_service.dart';

class CategoryService {
  static Future<List<CategoryModel>> getCategories(String restaurantId) async {
    try {
      final querySnapshot = await FirebaseService.categories
          .where('restaurantId', isEqualTo: restaurantId)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      final categories = querySnapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            
            // Se o campo 'id' estiver vazio, usar o DocID
            if (data['id'] == null || data['id'] == '') {
              data['id'] = doc.id;
            }
            
            return CategoryModel.fromMap(data);
          })
          .toList();

      return categories;
    } catch (e) {
      throw Exception('Erro ao carregar categorias: $e');
    }
  }

  static Stream<List<CategoryModel>> getCategoriesStream(String restaurantId) {
    return FirebaseService.categories
        .where('restaurantId', isEqualTo: restaurantId)
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  static Future<void> createCategory(CategoryModel category) async {
    try {
      await FirebaseService.categories.doc(category.id).set(category.toMap());
    } catch (e) {
      throw Exception('Erro ao criar categoria: $e');
    }
  }

  static Future<void> updateCategory(CategoryModel category) async {
    try {
      await FirebaseService.categories.doc(category.id).update(category.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar categoria: $e');
    }
  }

  static Future<void> deleteCategory(String categoryId) async {
    try {
      await FirebaseService.categories.doc(categoryId).update({
        'isActive': false,
      });
    } catch (e) {
      throw Exception('Erro ao deletar categoria: $e');
    }
  }

  static Future<CategoryModel?> getCategory(String categoryId) async {
    try {
      final doc = await FirebaseService.categories.doc(categoryId).get();
      if (doc.exists) {
        return CategoryModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar categoria: $e');
    }
  }
}