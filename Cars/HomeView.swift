//
//  HomeView.swift
//  Tuesday
//
//  Created by Etienne Vautherin on 08/02/2022.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @EnvironmentObject var model: ViewModel
    @State var presentAddCarSheet = false
    
    private func CarRowView(car: Car) -> some View {
       NavigationLink(destination: carDetailsView(car: car)) {
         VStack(alignment: .leading) {
           Text(car.marque)
                 .font(.headline)
           Text(car.marque)
                 .font(.subheadline)
         }
       }
    }
    
    var body: some View {
        VStack{
            if let user = model.user{
                VStack {
                    Text("Hello, \(user.email ?? "")")
                    NavigationView {
                            List {
                              ForEach (model.cars) { car in
                                CarRowView(car: car)
                              }
                              .onDelete() { indexSet in
                                model.removeCars(atOffsets: indexSet)
                              }
                            }
                            .navigationBarTitle("Car")
                            .navigationBarItems(trailing: AddBookButton() {
                                self.presentAddCarSheet.toggle()
                              })
                            .sheet(isPresented: self.$presentAddCarSheet) {
                              CarEditView()
                            }
                             
                          }
                }
                
            } else {
                LoginView()
            }
            
            if let errorMessage = model.errorMessage{
                Text(errorMessage)
                    .padding()
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

struct AddBookButton: View {
  var action: () -> Void
  var body: some View {
    Button(action: { self.action() }) {
      Image(systemName: "plus")
    }
  }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
