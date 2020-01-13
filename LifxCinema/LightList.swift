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

    
    // Functions
    private func removeLight(at offsets: IndexSet) {
        for index in offsets {
            let light = lightDevice[index]
            managedObjectContext.delete(light)
            
            do{
                try managedObjectContext.save()
            } catch{
                print("Something wrong")
            }
        }
    }
    
    //Add Light button
    var addLightButton: some View {
        HStack {
            Button(action: {
                self.showingAddLight.toggle()
            }) {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .accessibility(label: Text("Add Light"))
            }
        Button(action: {
        }) {
            Image(systemName: "arrow.clockwise.circle")
                .imageScale(.large)
                .accessibility(label: Text("Reload Data"))
        }
        }
    }
    
    // Body
    var body: some View {
        NavigationView{
            List {
                ForEach(lightDevice){ light in
                    NavigationLink(
                        destination: LightDetail(lightDevice: light)
                            .environment(\.managedObjectContext, self.managedObjectContext)
                    ) {
                        LightRow(lightDevice: light)
                    }
                }.onDelete(perform: removeLight)
            }
            .navigationBarTitle(Text("Lights"))
            .navigationBarItems(
                leading: EditButton(),
                trailing: addLightButton)
            .sheet(isPresented: $showingAddLight) {
                AddLight().environment(\.managedObjectContext, self.managedObjectContext)
            }
        }.onAppear{
            let interfaces = Interface.allInterfaces()
            print(interfaces.count)
            print(interfaces[1].address)
        }
    }
}

struct LightList_Previews: PreviewProvider {
    static var previews: some View {
        LightList()
          .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    }
}
