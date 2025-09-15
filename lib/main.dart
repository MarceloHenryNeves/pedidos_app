import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/table_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'screens/menu_screen.dart';
import 'screens/tablet_setup_screen.dart';
import 'config/tablet_config.dart';
import 'models/table_model.dart';
import 'theme/app_theme.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase inicializado
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TableProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Restaurant App',
        theme: AppTheme.lightTheme,
        home: const TabletMenuScreen(),
      ),
    );
  }
}

class TabletMenuScreen extends StatefulWidget {
  const TabletMenuScreen({super.key});

  @override
  State<TabletMenuScreen> createState() => _TabletMenuScreenState();
}

class _TabletMenuScreenState extends State<TabletMenuScreen> {
  TableModel? _tabletTable;
  bool _isLoading = true;
  bool _isConfigured = false;

  @override
  void initState() {
    super.initState();
    _checkConfiguration();
  }

  Future<void> _checkConfiguration() async {
    final isConfigured = await TabletConfig.isConfigured();
    
    if (isConfigured) {
      final tableNumber = await TabletConfig.getTableNumber();
      if (tableNumber != null) {
        await _createOrFindTable(tableNumber);
      }
    }

    setState(() {
      _isConfigured = isConfigured;
      _isLoading = false;
    });
  }

  Future<void> _createOrFindTable(int tableNumber) async {
    try {
      final tableProvider = context.read<TableProvider>();
      
      print('TabletMenuScreen: Carregando mesas...');
      await tableProvider.loadTables();
      
      // Tentar encontrar mesa existente com o número configurado
      final existingTables = tableProvider.tables.where(
        (table) => table.number == tableNumber,
      ).toList();
      
      if (existingTables.isNotEmpty) {
        // Mesa encontrada, usar mesa existente
        _tabletTable = existingTables.first;
        print('TabletMenuScreen: Mesa encontrada: ${_tabletTable!.number} (ID: ${_tabletTable!.id})');
        tableProvider.selectTable(_tabletTable!);
      } else {
        // Mesa não encontrada, criar nova
        print('TabletMenuScreen: Criando nova mesa: $tableNumber');
        await tableProvider.createTable(tableNumber);
        
        // Recarregar mesas e encontrar a recém-criada
        await tableProvider.loadTables();
        final newTables = tableProvider.tables.where(
          (table) => table.number == tableNumber,
        ).toList();
        
        if (newTables.isNotEmpty) {
          _tabletTable = newTables.first;
          print('TabletMenuScreen: Nova mesa criada: ${_tabletTable!.number} (ID: ${_tabletTable!.id})');
          tableProvider.selectTable(_tabletTable!);
        } else {
          throw Exception('Não foi possível criar/encontrar a mesa $tableNumber');
        }
      }
    } catch (e) {
      print('TabletMenuScreen: Erro ao inicializar mesa: $e');
      // Em caso de erro, criar mesa temporária para não quebrar o app
      _tabletTable = TableModel(
        id: 'temp-${const Uuid().v4()}',
        number: tableNumber,
        restaurantId: TabletConfig.restaurantId,
      );
    }
  }

  void _onSetupComplete() {
    _checkConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isConfigured || _tabletTable == null) {
      return TabletSetupScreen(onSetupComplete: _onSetupComplete);
    }

    return MenuScreen(table: _tabletTable!);
  }
}
