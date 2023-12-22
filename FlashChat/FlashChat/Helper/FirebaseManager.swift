//
//  FirebaseManager.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023..
//

import Foundation
import Firebase
import FirebaseAuth

final class FirebaseManager {
    static let shared = FirebaseManager()
    private let database: Firebase.Firestore
    
    private enum FSConstants {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
    
    private var login: String? {
        get { UserDefaults.standard.string(forKey: "login") }
        set { UserDefaults.standard.setValue(newValue, forKey: "login")}
    }
    
    private var password: String? {
        get { UserDefaults.standard.string(forKey: "password") }
        set { UserDefaults.standard.setValue(newValue, forKey: "password")}
    }
    
    var currentUserEmail: String? {
        Auth.auth().currentUser?.email
    }
    
    private init() {
        FirebaseApp.configure()
        database = Firestore.firestore()
    }
    
    public func auth(login: String, password: String, completion: @escaping (Result<Bool,Error>) -> Void) {
        Auth.auth().signIn(
            withEmail: login,
            password: password) { [weak self] result, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    self?.login = login
                    self?.password = password
                    completion(.success(true))
                }
            }
    }
    
    public func register(login: String, password: String, completion: @escaping (Result<Bool,Error>) -> Void) {
        Auth.auth().createUser(withEmail: login, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self?.login = login
                self?.password = password
                completion(.success(true))
            }
        }
    }
    
    public func signOut(completion: @escaping (Result<Bool,Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "login")
            UserDefaults.standard.removeObject(forKey: "password")
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    public func sendMessage(_ message: MessageModel, completion: @escaping (Result<Bool,Error>) -> Void) {
        database.collection(FSConstants.collectionName).addDocument(data: [
            FSConstants.senderField: message.sender,
            FSConstants.bodyField: message.body,
            FSConstants.dateField: Date().timeIntervalSince1970,
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    public func fetchMessages(completion: @escaping (Result<[MessageModel],Error>) -> Void) {
        database.collection(FSConstants.collectionName).addSnapshotListener { [weak self] snapshot, error in
            guard let self = self, let login = self.login else { return }
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(snapshot!.documents.sorted(by: {
                    guard let date1 = $0[FSConstants.dateField] as? Double,
                          let date2 = $1[FSConstants.dateField] as? Double
                    else { return true }
                    return date1 < date2
                }).compactMap {
                    guard let sender = $0[FSConstants.senderField] as? String,
                          let body = $0[FSConstants.bodyField] as? String
                    else { return nil }
                    return MessageModel(
                        sender: sender,
                        body: body,
                        type: sender == login ? .outcome : .income)
                }))
            }
        }
    }
}
