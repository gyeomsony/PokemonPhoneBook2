//
//  CoreDataManager.swift
//  PokemonPhoneBook2
//
//  Created by 손겸 on 12/10/24.
//


import CoreData
import UIKit

class CoreDataManager {
    
    // 싱글톤 패턴으로 전체에서 접근 가능하게 함
    static let shared = CoreDataManager()
    
    private init() {} // 외부에서 인스턴스를 생성하지 못하게 함
    
    // 코어 데이터 컨텍스트
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // 코어 데이터 저장
    func saveContext() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
                print("Core Data 저장 성공")
            } catch {
                print("Core Data 저장 실패: \(error)")
            }
        }
    }
    
    // 연락처 추가
    func addContact(name: String, phoneNumber: String, profileImage: Data?) -> Contact {
        let newContact = Contact(context: context)
        newContact.name = name
        newContact.phoneNumber = phoneNumber
        newContact.profileImage = profileImage
        
        saveContext()
        return newContact
    }
    
    // 연락처 불러오기
    func fetchContacts() -> [Contact] {
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("연락처 불러오기 실패: \(error)")
            return []
        }
    }
    
    // 연락처 수정
    func updateContact(contact: Contact, name: String, phoneNumber: String, profileImage: Data?) {
        contact.name = name
        contact.phoneNumber = phoneNumber
        contact.profileImage = profileImage
        
        saveContext()
    }
    
    // 연락처 삭제
    func deleteContact(contact: Contact) {
        context.delete(contact)
        saveContext()
    }
}
