import 'package:cooky/core/utils/image_cache_config.dart';
import 'package:flutter/material.dart';

/// Виджет для отображения информации о кеше изображений
/// Используется для отладки и мониторинга
class CacheInfoWidget extends StatefulWidget {
  const CacheInfoWidget({super.key});

  @override
  State<CacheInfoWidget> createState() => _CacheInfoWidgetState();
}

class _CacheInfoWidgetState extends State<CacheInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Информация о кеше изображений',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Объектов в кеше: ${ImageCacheConfig.cacheObjectCount}'),
            Text(
              'Размер кеша: ${_formatBytes(ImageCacheConfig.cacheSizeBytes)}',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await ImageCacheConfig.clearCache();
                    setState(() {});
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Кеш очищен')),
                      );
                    }
                  },
                  child: const Text('Очистить кеш'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('Обновить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
