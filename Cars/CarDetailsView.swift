//
//  CarDetailsView.swift
//  Cars
//
//  Created by emeric on 11/02/2022.
//

import SwiftUI
 
struct carDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var presentEditMovieSheet = false
     
    var car: Car
     
    private func editButton(action: @escaping () -> Void) -> some View {
      Button(action: { action() }) {
        Text("Edit")
      }
    }
     
    var body: some View {
      Form {
        Section(header: Text("Car")) {
          Text(car.name)
          Text(car.marque)
             
        }
      }
      .navigationBarTitle(car.name)
      .navigationBarItems(trailing: editButton {
        self.presentEditMovieSheet.toggle()
      })
      .onAppear() {
        print("CarDetailsView.onAppear() for \(self.car.name)")
      }
      .onDisappear() {
        print("CarDetailsView.onDisappear()")
      }
      .sheet(isPresented: self.$presentEditMovieSheet) {
        CarEditView(viewModel: CarViewModel(car: car), mode: .edit) { result in
          if case .success(let action) = result, action == .delete {
            self.presentationMode.wrappedValue.dismiss()
          }
        }
      }
    }
     
  }
 
struct CarDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let car = Car(name: "name car", marque: "this is a sample description")
        return
          NavigationView {
            carDetailsView(car: car)
          }
    }
}
