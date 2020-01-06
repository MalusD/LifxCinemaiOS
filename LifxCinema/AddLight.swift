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
    @State private var text: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image("Lifx")
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            HStack(alignment: .center) {
                Text("Start new project by adding new lights")
                    .font(.subheadline)
            }
            VStack {
                HStack(alignment: .center) {
                    TextField("Enter Light IP here...", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                Button(action: {
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
