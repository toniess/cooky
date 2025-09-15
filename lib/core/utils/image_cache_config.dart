import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Конфигурация кеширования изображений
class ImageCacheConfig {
  static const int _maxCacheSize = 100; // MB
  static const int _maxCacheObjects = 200;

  /// Инициализация настроек кеша изображений
  static void initialize() {
    // Настройка кеша для CachedNetworkImage
    PaintingBinding.instance.imageCache.maximumSize = _maxCacheObjects;
    PaintingBinding.instance.imageCache.maximumSizeBytes =
        _maxCacheSize * 1024 * 1024;
  }

  /// Получить стандартные настройки для CachedNetworkImage
  static CachedNetworkImageProvider getCachedImageProvider(String imageUrl) {
    return CachedNetworkImageProvider(imageUrl, cacheKey: imageUrl);
  }

  /// Очистить кеш изображений
  static Future<void> clearCache() async {
    await CachedNetworkImage.evictFromCache('');
    PaintingBinding.instance.imageCache.clear();
  }

  /// Очистить кеш для конкретного изображения
  static Future<void> clearImageCache(String imageUrl) async {
    await CachedNetworkImage.evictFromCache(imageUrl);
  }

  /// Получить размер кеша в байтах
  static int get cacheSizeBytes =>
      PaintingBinding.instance.imageCache.currentSizeBytes;

  /// Получить количество объектов в кеше
  static int get cacheObjectCount =>
      PaintingBinding.instance.imageCache.currentSize;
}
