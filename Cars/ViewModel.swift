//
//  ViewModel.swift
//  Cars
//
//  Created by emeric on 10/02/2022.
//

import Foundation
import Combine
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class ViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var cars = [Car]()
    @Published var modified = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var listener: ListenerRegistration?
    var subscription: AnyCancellable?
    
    init() {
        subscription = $user.sink(receiveValue: { [weak self] user in
            self?.setListener(user: user)
        })
    }
        
}


// Firebase management
extension ViewModel {
    func login(mail: String, password: String) {
        Task {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: mail, password: password)
                errorMessage = .none
                user = authResult.user
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            errorMessage = .none
            user = .none
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func snapshotListener(querySnapshot: QuerySnapshot?, error: Error?) {
        if let error = error {
            errorMessage = error.localizedDescription
        }
        
        if let documents = querySnapshot?.documents {
            print("Documents: \(documents)")
            do {
                cars = try documents.compactMap({ document in
                    let car = try document.data(as: Car.self)
                    return car
               })
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func setListener(user: User?) {
        if let existingListener = listener {
            existingListener.remove()
            print("Existing listener removed")
            listener = .none
            cars = []
        }

        if let user = user {
            let collection = Firestore.firestore().collection("cars")
            listener = collection.addSnapshotListener { [weak self] (querySnapshot, error) in
                self?.snapshotListener(querySnapshot: querySnapshot, error: error)
            }
            print("Listener added for \(user.uid)")
        }
    }
    
    func removeCars(atOffsets indexSet: IndexSet) {
        let cars = indexSet.lazy.map { self.cars[$0] }
        cars.forEach { car in
          if let documentId = car.id {
              Firestore.firestore().collection("cars").document(documentId).delete { error in
              if let error = error {
                print("Unable to remove document: \(error.localizedDescription)")
              }
            }
          }
        }
      }
}

