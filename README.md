# PokemonPhoneBook

PokemonPhoneBook는 사용자가 포켓몬 캐릭터의 정보를 기반으로 연락처를 관리할 수 있도록 만들어진 iOS 앱입니다. 이 앱은 Core Data를 활용하여 로컬 저장소에 연락처 정보를 저장하며, Alamofire를 사용하여 외부 API에서 포켓몬 데이터를 가져왔습니다.

---

### 커밋 메시지 규칙

- ✨ **feat**: 새로운 기능 추가  
- 🐝 **fix**: 버그 수정  
- 📝 **docs**: 문서 수정  
- 💄 **style**: 코드 포맷팅, 세미콜론 누락, 코드 변경이 없는 경우  
- ♻️ **refactor**: 코드 리팩토링  
- ✅ **test**: 테스트 코드, 리팩토링 테스트 코드 추가  
- 🎨 **chore**: 빌드 업무 수정, 패키지 매니저 수정  



-------

## 주요 기능

### 1. 연락처 추가 및 수정
- **연락처 추가**: 이름, 전화번호, 그리고 프로필 이미지를 입력하여 새로운 연락처를 추가할 수 있습니다.
- **연락처 수정**: 기존 연락처를 선택하면 수정 모드로 들어가 이름, 번호, 이미지를 변경할 수 있습니다.

### 2. 연락처 삭제
- 사용자는 기존 연락처를 삭제하여 리스트에서 제거할 수 있습니다.

### 3. 랜덤 포켓몬 이미지 가져오기
- 외부 API(PokeAPI)를 활용하여 무작위 포켓몬 데이터를 가져옵니다.
- 포켓몬 이미지는 연락처의 프로필 사진으로 사용할 수 있습니다.

### 4. Core Data 기반 데이터 관리
- 연락처의 이름, 전화번호, 그리고 프로필 이미지를 Core Data에 저장하여 앱을 재실행해도 데이터가 유지됩니다.

---

## 기술 스택

### 1. **언어**
- Swift

### 2. **아키텍처**
- MVC (Model-View-Controller)

### 3. **라이브러리**
- **Alamofire**: 외부 API 호출 및 JSON 데이터 디코딩.
- **SnapKit**: 오토레이아웃 구성.

### 4. **외부 API**
- **PokeAPI**: 포켓몬 정보를 제공하는 RESTful API를 사용하여 랜덤 이미지를 가져옵니다.

---

## 코드 구조

### 1. **Core Data 관리**
`CoreDataManager`는 Core Data 관련 작업(데이터 추가, 수정, 삭제, 가져오기)을 캡슐화하여 제공합니다.

#### 주요 메서드:
- `addContact(name: String, phoneNumber: String, profileImage: Data?)`: 연락처 추가.
- `updateContact(contact: Contact, name: String, phoneNumber: String, profileImage: Data?)`: 연락처 수정.
- `deleteContact(contact: Contact)`: 연락처 삭제.
- `fetchContacts() -> [Contact]`: 저장된 연락처 가져오기.

### 2. **API 호출**
Alamofire를 사용하여 PokeAPI에서 랜덤 포켓몬 데이터를 가져옵니다.

#### 주요 메서드:
```swift
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
            
            // 이미지 데이터 요청
            AF.request(imageUrl).responseData { imageResponse in
                switch imageResponse.result {
                case .success(let data):
                    completion(UIImage(data: data))
                case .failure:
                    completion(nil)
                }
            }
        case .failure:
            completion(nil)
        }
    }
}
```

### 3. **UI 구성**
- **TableView**: 연락처 리스트를 표시.
- **Custom Cell**: 프로필 이미지, 이름, 전화번호를 포함하는 셀.
- **Detail View**: 연락처 추가/수정 화면.

---

## 참고 자료
- [PokeAPI 공식 문서](https://pokeapi.co/)
- [Alamofire GitHub](https://github.com/Alamofire/Alamofire)
- [SnapKit GitHub](https://github.com/SnapKit/SnapKit)

---

