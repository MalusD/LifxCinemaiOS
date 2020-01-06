//
//  ContentView.swift
//  LifxCinema
//
//  Created by Jean-Sébastien POÜS on 06/01/2020.
//  Copyright © 2020 Jean-Sébastien POÜS. All rights reserved.
//

import SwiftUI
import CoreData
import LIFXClient
import PromiseKit
import Network


struct ContentView: View {
    
    // CoreData Environment
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: LightDevice.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \LightDevice.adresse, ascending: true)
        ]
    ) var lightDevice: FetchedResults<LightDevice>
    
    // Property use by the View
    @State var showingAddLight = false
    
    // Body
    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    self.showingAddLight.toggle()
                }) {
                    HStack {
                        Spacer()
                        Text("Add Light")
                    }
                    .padding(.horizontal)
                }.sheet(isPresented: $showingAddLight){
                    AddLight().environment(\.managedObjectContext, self.managedObjectContext)
                }
            }
            List {
                ForEach(lightDevice){ light in
                    LightRow(lightDevice: light)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
          .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)    }
}
