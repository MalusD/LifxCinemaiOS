//
//  AddLight.swift
//  LifxCinema
//
//  Created by Jean-Sébastien POÜS on 06/01/2020.
//  Copyright © 2020 Jean-Sébastien POÜS. All rights reserved.
//

import SwiftUI
import CoreData

struct AddLight: View {
    
    // CoreData Environment
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: LightDevice.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \LightDevice.adresse, ascending: true)
        ]
    ) var lightDevice: FetchedResults<LightDevice>
    
    // Property use by the View
    @State private var textField: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
        VStack {
            Button(action: {
                let iP = LightDevice(context: self.managedObjectContext)
                iP.adresse = self.textField
                do {
                    try self.managedObjectContext.save()
                } catch {
                    // handle the Core Data error
                    print("Something wrong")
                }
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Text("Send")
                        .bold()
                    Image(systemName: "paperplane")
                        .imageScale(.medium)
                        .font(Font.headline.weight(.medium))
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 30)
        VStack {
            Form{
                Section(
                    header: Text("Add light").font(.title).bold(),
                    footer: Text("Please enter device IP adress")
                ){
                    
                    TextField("192.168.1.4", text: $textField){
                        UIApplication.shared.endEditing()
                    }
                        .font(.subheadline)
                    .keyboardType(.numbersAndPunctuation)
                }
                Section(footer: Text("Coming soon : Lights discovery broadcast...").italic()){
                    EmptyView()
                }
            }
        }
        }
    }
}

struct AddLight_Previews: PreviewProvider {
    static var previews: some View {
        AddLight()
            .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) 
    }
}

/*Button(action: {
    let iP = LightDevice(context: self.managedObjectContext)
    iP.adresse = self.text
    do {
        try self.managedObjectContext.save()
    } catch {
        // handle the Core Data error
        print("Something wrong")
    }
    self.presentationMode.wrappedValue.dismiss()
}) {
    Text("Send")
}*/
