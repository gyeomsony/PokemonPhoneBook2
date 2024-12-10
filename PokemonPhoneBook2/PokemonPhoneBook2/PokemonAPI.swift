//
//  PokemonAPI.swift
//  PokemonPhoneBook2
//
//  Created by 손겸 on 12/10/24.
//

import UIKit

// 포켓몬 데이터 모델
struct PokemonResult: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
}

struct Sprites: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// 제네릭으로 데이터를 가져오는 fetchData 함수
func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
    let session = URLSession(configuration: .default)
    session.dataTask(with: URLRequest(url: url)) { data, response, error in
        guard let data = data, error == nil else {
            print("데이터 로드 실패")
            completion(nil)
            return
        }
        
        let successRange = 200..<300
        if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(decodedData)
            } catch {
                print("JSON 디코딩 실패: \(error)")
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }.resume()
}

// 포켓몬 이미지 데이터를 가져오는 함수
func fetchRandomPokemonImage(completion: @escaping (UIImage?) -> Void) {
    let randomID = Int.random(in: 1...1000)
    let urlString = "https://pokeapi.co/api/v2/pokemon/\(randomID)"
    
    guard let url = URL(string: urlString) else {
        print("잘못된 URL")
        completion(nil)
        return
    }
    
    fetchData(url: url) { (pokemonResponse: PokemonResult?) in
        // pokemonResponse가 nil인 경우 리턴
        guard let response = pokemonResponse else {
            completion(nil)
            return
        }
        
        guard let imageUrl = URL(string: response.sprites.frontDefault) else {
            completion(nil)
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageUrl), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
