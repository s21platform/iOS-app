//
//  CacheManager.swift
//  space21
//
//  Created by Марина on 24.10.2024.
//

import UIKit

class ImageCacheManager {
    
    // Создаем синглтон для удобного доступа
    static let shared = ImageCacheManager()
    
    // Кэш для изображений
    private let imageCache = NSCache<NSString, UIImage>()
    
    // Приватный инициализатор, чтобы предотвратить создание других экземпляров
    private init() {}
    
    /// Метод для загрузки изображения по URL и кэширования его
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Если изображение уже есть в кэше, сразу возвращаем его
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            print("Image loaded from cache: \(urlString)")
            completion(cachedImage)
            return
        }
        
        // Проверяем корректность URL
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion(nil)
            return
        }
        
        // Загружаем изображение из сети
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to decode image")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Кэшируем изображение
            self.imageCache.setObject(image, forKey: urlString as NSString)
            print("Image cached: \(urlString)")
            
            // Возвращаем изображение через completion
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        task.resume() // Начинаем загрузку
    }
    
    /// Метод для очистки кэша (по необходимости)
    func clearCache() {
        imageCache.removeAllObjects()
        print("Image cache cleared")
    }
}
