import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/table_model.dart';

class TableCard extends StatelessWidget {
  final TableModel table;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TableCard({
    super.key,
    required this.table,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOccupied = table.isOccupied;
    
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOccupied ? theme.colorScheme.error : theme.colorScheme.primary,
              width: 2,
            ),
            color: isOccupied 
                ? theme.colorScheme.errorContainer
                : theme.colorScheme.primaryContainer,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.table_restaurant,
                  size: 32,
                  color: isOccupied 
                      ? theme.colorScheme.onErrorContainer
                      : theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 8),
                Text(
                  'Mesa ${table.number}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isOccupied 
                        ? theme.colorScheme.onErrorContainer
                        : theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isOccupied ? 'OCUPADA' : 'LIVRE',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isOccupied 
                        ? theme.colorScheme.onErrorContainer
                        : theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                if (isOccupied) ...[
                  const SizedBox(height: 8),
                  Text(
                    'R\$ ${table.currentTotal.toStringAsFixed(2)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                  if (table.lastOrderTime != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('HH:mm').format(table.lastOrderTime!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}