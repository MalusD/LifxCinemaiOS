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
    
    // Func
    
    
    //Add Light button
    var addLightButton: some View {
        Button(action: {
            self.showingAddLight.toggle()
            self.refreshConnection()
        }) {
            Image(systemName: "plus.circle")
                .imageScale(.large)
                .accessibility(label: Text("Add Light"))
                .padding()
        }
    }
    
    // Body
    var body: some View {
        NavigationView{
            List {
                ForEach(lightDevice){ light in
                    LightRow(lightDevice: light)
                }
            }
            .navigationBarTitle(Text("Lights"))
            .navigationBarItems(trailing: addLightButton)
            .sheet(isPresented: $showingAddLight) {
                AddLight().environment(\.managedObjectContext, self.managedObjectContext)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
          .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    }
}
