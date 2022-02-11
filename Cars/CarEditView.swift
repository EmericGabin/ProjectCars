//
//  CarEditView.swift
//  Cars
//
//  Created by emeric on 11/02/2022.
//

import SwiftUI
 
enum Mode {
  case new
  case edit
}
 
enum Action {
  case delete
  case done
  case cancel
}
 
struct CarEditView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var presentActionSheet = false
     
    @ObservedObject var viewModel = CarViewModel()
    var mode: Mode = .new
    var completionHandler: ((Result<Action, Error>) -> Void)?
     
     
    var cancelButton: some View {
      Button(action: { self.handleCancelTapped() }) {
        Text("Cancel")
      }
    }
     
    var saveButton: some View {
      Button(action: { self.handleDoneTapped() }) {
        Text(mode == .new ? "Done" : "Save")
      }
      .disabled(!viewModel.modified)
    }
     
    var body: some View {
      NavigationView {
        Form {
          Section(header: Text("Car")) {
            TextField("name", text: $viewModel.car.name)
            TextField("marque", text: $viewModel.car.marque)
          }
           
          if mode == .edit {
            Section {
              Button("Delete car") { self.presentActionSheet.toggle() }
                .foregroundColor(.red)
            }
          }
        }
        .navigationTitle(mode == .new ? "New Car" : viewModel.car.name)
        .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
        .navigationBarItems(
          leading: cancelButton,
          trailing: saveButton
        )
        .actionSheet(isPresented: $presentActionSheet) {
          ActionSheet(title: Text("Are you sure?"),
                      buttons: [
                        .destructive(Text("Delete car"),
                                     action: { self.handleDeleteTapped() }),
                        .cancel()
                      ])
        }
      }
    }
     
    // Action Handlers
     
    func handleCancelTapped() {
      self.dismiss()
    }
     
    func handleDoneTapped() {
      self.viewModel.handleDoneTapped()
      self.dismiss()
    }
     
    func handleDeleteTapped() {
      viewModel.handleDeleteTapped()
      self.dismiss()
      self.completionHandler?(.success(.delete))
    }
     
    func dismiss() {
      self.presentationMode.wrappedValue.dismiss()
    }
  }
 
 
struct MovieEditView_Previews: PreviewProvider {
  static var previews: some View {
    let car = Car(name: "Sample title", marque: "Sample marque")
    let carViewModel = CarViewModel(car: car)
    return CarEditView(viewModel: carViewModel, mode: .edit)
  }
}
