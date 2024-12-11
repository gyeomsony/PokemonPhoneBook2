//
//  PokemonAPI.swift
//  PokemonPhoneBook2
//
//  Created by 손겸 on 12/10/24.
//

import UIKit
import Alamofire

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

// 포켓몬 이미지 데이터를 가져오는 함수
func fetchRandomPokemonImage(completion: @escaping (UIImage?) -> Void) {
    let randomID = Int.random(in: 1...1000)
    let urlString = "https://pokeapi.co/api/v2/pokemon/\(randomID)"
    
    AF.request(urlString).responseDecodable(of: PokemonResult.self) { response in
        switch response.result {
        case .success(let pokemonResponse):
            guard let imageUrl = URL(string: pokemonResponse.sprites.frontDefault) else {
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
        case .failure(let error):
            print("Request failed with error: \(error.localizedDescription)")
            completion(nil)
        }
    }
}
    
