import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/table_model.dart';
import 'firebase_service.dart';

class TableService {
  static Future<List<TableModel>> getTables(String restaurantId) async {
    try {
      final querySnapshot = await FirebaseService.tables
          .where('restaurantId', isEqualTo: restaurantId)
          .get();

      final tables = querySnapshot.docs
          .map((doc) => TableModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      
      // Ordenação local por número da mesa
      tables.sort((a, b) => a.number.compareTo(b.number));
      return tables;
    } catch (e) {
      throw Exception('Erro ao carregar mesas: $e');
    }
  }

  static Stream<List<TableModel>> getTablesStream(String restaurantId) {
    return FirebaseService.tables
        .where('restaurantId', isEqualTo: restaurantId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TableModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList()
            ..sort((a, b) => a.number.compareTo(b.number))); // Ordenação local
  }

  static Future<void> createTable(TableModel table) async {
    try {
      await FirebaseService.tables.doc(table.id).set(table.toMap());
    } catch (e) {
      throw Exception('Erro ao criar mesa: $e');
    }
  }

  static Future<void> updateTable(TableModel table) async {
    try {
      await FirebaseService.tables.doc(table.id).update(table.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar mesa: $e');
    }
  }

  static Future<void> updateTableTotal(String tableId, double newTotal) async {
    try {
      await FirebaseService.tables.doc(tableId).update({
        'currentTotal': newTotal,
        'isOccupied': newTotal > 0,
        'lastOrderTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao atualizar total da mesa: $e');
    }
  }

  static Future<void> resetTable(String tableId) async {
    try {
      await FirebaseService.tables.doc(tableId).update({
        'currentTotal': 0.0,
        'isOccupied': false,
        'lastOrderTime': null,
      });
    } catch (e) {
      throw Exception('Erro ao resetar mesa: $e');
    }
  }

  static Future<void> deleteTable(String tableId) async {
    try {
      await FirebaseService.tables.doc(tableId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar mesa: $e');
    }
  }

  static Future<TableModel?> getTable(String tableId) async {
    try {
      final doc = await FirebaseService.tables.doc(tableId).get();
      if (doc.exists) {
        return TableModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar mesa: $e');
    }
  }
}