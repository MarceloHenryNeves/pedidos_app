import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/table_provider.dart';
import '../models/table_model.dart';
import 'menu_screen.dart';
import '../widgets/table_card.dart';

class TableSelectionScreen extends StatefulWidget {
  const TableSelectionScreen({super.key});

  @override
  State<TableSelectionScreen> createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends State<TableSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TableProvider>().loadTables();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Mesa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTableDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<TableProvider>().loadTables(),
          ),
        ],
      ),
      body: Consumer<TableProvider>(
        builder: (context, tableProvider, child) {
          if (tableProvider.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (tableProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar mesas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tableProvider.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      tableProvider.clearError();
                      tableProvider.loadTables();
                    },
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          if (tableProvider.tables.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.table_restaurant,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma mesa cadastrada',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toque no botão + para adicionar uma mesa',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _showAddTableDialog(context),
                    child: const Text('Adicionar Mesa'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: tableProvider.tables.length,
              itemBuilder: (context, index) {
                final table = tableProvider.tables[index];
                return TableCard(
                  table: table,
                  onTap: () => _selectTable(context, table),
                  onLongPress: () => _showTableOptions(context, table),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _selectTable(BuildContext context, TableModel table) {
    context.read<TableProvider>().selectTable(table);
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MenuScreen(table: table),
      ),
    );
  }

  void _showAddTableDialog(BuildContext context) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Mesa'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Número da mesa',
            hintText: 'Digite o número da mesa',
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final number = int.tryParse(controller.text);
              if (number != null && number > 0) {
                context.read<TableProvider>().createTable(number);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor, digite um número válido'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _showTableOptions(BuildContext context, TableModel table) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Abrir Cardápio'),
            onTap: () {
              Navigator.of(context).pop();
              _selectTable(context, table);
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Processar Pagamento'),
            enabled: table.isOccupied,
            onTap: table.isOccupied
                ? () {
                    Navigator.of(context).pop();
                    _showPaymentDialog(context, table);
                  }
                : null,
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Limpar Mesa'),
            enabled: table.isOccupied,
            onTap: table.isOccupied
                ? () {
                    Navigator.of(context).pop();
                    _showResetTableDialog(context, table);
                  }
                : null,
          ),
          ListTile(
            leading: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Excluir Mesa',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () {
              Navigator.of(context).pop();
              _showDeleteTableDialog(context, table);
            },
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, TableModel table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pagamento Mesa ${table.number}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total: R\$ ${table.currentTotal.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text('Confirmar pagamento?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TableProvider>().resetTable(table.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pagamento da Mesa ${table.number} processado!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirmar Pagamento'),
          ),
        ],
      ),
    );
  }

  void _showResetTableDialog(BuildContext context, TableModel table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar Mesa ${table.number}'),
        content: const Text('Tem certeza que deseja limpar esta mesa? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TableProvider>().resetTable(table.id);
              Navigator.of(context).pop();
            },
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteTableDialog(BuildContext context, TableModel table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir Mesa ${table.number}'),
        content: const Text('Tem certeza que deseja excluir esta mesa? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () {
              context.read<TableProvider>().deleteTable(table.id);
              Navigator.of(context).pop();
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}