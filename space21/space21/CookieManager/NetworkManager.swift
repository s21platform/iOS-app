//
//  CookieManager.swift
//  space21
//
//  Created by Марина on 21.10.2024.
//

import UIKit

class NetworkManager {
    
    // Создаем синглтон
    static let shared = NetworkManager()
    
    // Приватный инициализатор, чтобы предотвратить создание других экземпляров
    private init() {}
    
    // Ключ для хранения JWT в UserDefaults
    private let jwtKey = "jwtToken"
    
    func loginRequest(username: String, password: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "https://api.space-21.ru/auth/login") else {
            print("Invalid URL")
            return
        }
        
        // Настройка URL запроса
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Устанавливаем заголовки
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Тело запроса: передаем username и password
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        
        // Преобразуем тело запроса в JSON-данные
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            completion(.failure(error))
            return
        }
        
        // Создаем сессию
        let session = URLSession.shared
        
        // Отправляем запрос
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                // Если ошибка, возвращаем её через completion
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            // Логируем статус-код ответа
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode != 200 {
                    // Логируем headers и тело ответа в случае неуспешного запроса
                    print("Response Headers: \(httpResponse.allHeaderFields)")
                    
                    if let responseData = data, let responseString = String(data: responseData, encoding: .utf8) {
                        print("Response Body: \(responseString)")
                    }
                    
                    let statusError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                    DispatchQueue.main.async {
                        completion(.failure(statusError))
                    }
                    return
                }
                
                // Логируем заголовки
                print("Response Headers: \(httpResponse.allHeaderFields)")
                
                // Сохраняем куки, если они есть
                if let url = response?.url {
                    self.saveCookies(for: url, from: httpResponse)
                }
                
                // Проверяем заголовок Set-Cookie на наличие JWT
                if let setCookieHeader = httpResponse.allHeaderFields["Set-Cookie"] as? String {
                    print("Set-Cookie Header: \(setCookieHeader)")
                    
                    if let jwt = self.extractJWT(from: setCookieHeader) {
                        self.saveJWT(jwt)
                        print("Extracted JWT Token: \(jwt)")
                    } else {
                        print("JWT not found in Set-Cookie")
                    }
                } else {
                    print("Set-Cookie header not found")
                }
            }
            
            // Если данные успешно получены, возвращаем их через completion
            if let data = data {
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            }
        }
        
        task.resume() // Запускаем запрос
    }
    
    func getProfile(username: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
            // Базовый URL
            guard var urlComponents = URLComponents(string: "https://api.space-21.ru/api/profile") else {
                print("Invalid URL")
                return
            }
            
            // Добавляем параметр username в URL
            urlComponents.queryItems = [
                URLQueryItem(name: "username", value: username)
            ]
            
            // Проверяем, что URL корректно собран
            guard let url = urlComponents.url else {
                print("Invalid URL after adding parameters")
                return
            }
            
            // Настройка URL запроса
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Получаем все куки, которые были сохранены ранее
            let cookieStorage = HTTPCookieStorage.shared
            if let cookies = cookieStorage.cookies(for: url) {
                let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
                request.allHTTPHeaderFields = cookieHeader // Добавляем куки в заголовок
                print("Added cookies to request: \(cookieHeader)")
            }
            
            // Создаем сессию
            let session = URLSession.shared
            
            // Отправляем запрос
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    // Если ошибка, возвращаем её через completion
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                // Логируем статус-код ответа
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Response Code: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode != 200 {
                        // Логируем headers и тело ответа в случае неуспешного запроса
                        print("Response Headers: \(httpResponse.allHeaderFields)")
                        
                        if let responseData = data, let responseString = String(data: responseData, encoding: .utf8) {
                            print("Response Body: \(responseString)")
                        }
                        
                        let statusError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                        DispatchQueue.main.async {
                            completion(.failure(statusError))
                        }
                        return
                    }
                }
                
                // Если данные успешно получены, возвращаем их через completion
                if let data = data {
                    do {
                        // Парсим данные в структуру UserProfile
                        let userProfile = try JSONDecoder().decode(UserProfile.self, from: data)
                        
                        // Передаем распарсенные данные через completion
                        DispatchQueue.main.async {
                            completion(.success(userProfile))
                        }
                    } catch {
                        // Если возникла ошибка парсинга
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }
            
            task.resume() // Запускаем запрос
        }
    
    
    // Функция для извлечения JWT из Cookie
    private func extractJWT(from cookie: String) -> String? {
        print("Parsing Set-Cookie: \(cookie)")
        let components = cookie.components(separatedBy: ";")
        for component in components {
            if component.trimmingCharacters(in: .whitespaces).hasPrefix("S21SPACE_AUTH_TOKEN=") {
                let jwt = component.replacingOccurrences(of: "S21SPACE_AUTH_TOKEN=", with: "").trimmingCharacters(in: .whitespaces)
                print("Found JWT: \(jwt)")
                return jwt
            }
        }
        return nil
    }
    
    // Сохраняем JWT локально
    private func saveJWT(_ token: String) {
        UserDefaults.standard.set(token, forKey: jwtKey)
        UserDefaults.standard.synchronize()
    }
    
    // Получаем сохраненный JWT
    func getJWT() -> String? {
        return UserDefaults.standard.string(forKey: jwtKey)
    }
    
    // Удаляем JWT из UserDefaults (например, при выходе пользователя)
    func clearJWT() {
        UserDefaults.standard.removeObject(forKey: jwtKey)
        UserDefaults.standard.synchronize()
    }
    
    // Сохраняем все куки, полученные от сервера
    private func saveCookies(for url: URL, from httpResponse: HTTPURLResponse) {
        if let headers = httpResponse.allHeaderFields as? [String: String]
           {
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
            for cookie in cookies {
                print("Saving Cookie: \(cookie)")
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
    }
}
