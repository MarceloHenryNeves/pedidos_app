import 'package:flutter/material.dart';
import '../models/table_model.dart';
import '../services/table_service.dart';
import 'package:uuid/uuid.dart';

class TableProvider with ChangeNotifier {
  List<TableModel> _tables = [];
  TableModel? _selectedTable;
  bool _loading = false;
  String? _error;
  final String _restaurantId = 'default_restaurant';

  List<TableModel> get tables => _tables;
  TableModel? get selectedTable => _selectedTable;
  bool get loading => _loading;
  String? get error => _error;
  String get restaurantId => _restaurantId;

  Future<void> loadTables() async {
    _setLoading(true);
    _setError(null);
    
    try {
      _tables = await TableService.getTables(_restaurantId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void selectTable(TableModel table) {
    _selectedTable = table;
    notifyListeners();
  }

  void clearSelection() {
    _selectedTable = null;
    notifyListeners();
  }

  Future<void> createTable(int number) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final table = TableModel(
        id: const Uuid().v4(),
        number: number,
        restaurantId: _restaurantId,
      );
      
      await TableService.createTable(table);
      await loadTables();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTableTotal(String tableId, double newTotal) async {
    try {
      await TableService.updateTableTotal(tableId, newTotal);
      
      final index = _tables.indexWhere((table) => table.id == tableId);
      if (index != -1) {
        _tables[index] = _tables[index].copyWith(
          currentTotal: newTotal,
          isOccupied: newTotal > 0,
          lastOrderTime: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> resetTable(String tableId) async {
    _setLoading(true);
    _setError(null);
    
    try {
      await TableService.resetTable(tableId);
      
      final index = _tables.indexWhere((table) => table.id == tableId);
      if (index != -1) {
        _tables[index] = _tables[index].copyWith(
          currentTotal: 0.0,
          isOccupied: false,
          lastOrderTime: null,
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTable(String tableId) async {
    _setLoading(true);
    _setError(null);
    
    try {
      await TableService.deleteTable(tableId);
      _tables.removeWhere((table) => table.id == tableId);
      
      if (_selectedTable?.id == tableId) {
        _selectedTable = null;
      }
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    if (value != null) {
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}