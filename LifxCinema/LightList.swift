//
//  LightList.swift
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


struct LightList: View {
    
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

struct LightList_Previews: PreviewProvider {
    static var previews: some View {
        LightList()
          .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    }
}
