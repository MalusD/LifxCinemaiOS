//
//  LightRow.swift
//  LifxCinema
//
//  Created by Jean-Sébastien POÜS on 06/01/2020.
//  Copyright © 2020 Jean-Sébastien POÜS. All rights reserved.
//

import SwiftUI
import CoreData
import Network
import LIFXClient
import PromiseKit

struct LightRow: View {
    
    var lightDevice : LightDevice
    
    @State private var label: String = "Label"
    @State private var power: Bool = false
    
    private func getState(){
        LIFXClient.getLight(address: lightDevice.adresse!).done{
            state in
            self.label = state.state.label
            if state.state.power == 65535{
                self.power = true
            } else {
                self.power = false
            }
            
        }
    }
    
    var body: some View {
        HStack {
            if self.power{
            Image(systemName: "lightbulb")
                .imageScale(.large)
                .foregroundColor(.yellow)
                .padding(.trailing, 4)
            } else {
                Image(systemName: "lightbulb.slash")
                    .imageScale(.large)
                    .foregroundColor(.primary)
                    .padding(.trailing, 4)
            }
                Text(label)
                    .font(.headline)
            Spacer()
            if label == "Label"{
                Text("Not connected")
                    .font(.footnote)
                    .italic()
            } else {
                Text("\(lightDevice.adresse ?? "No lights")")
                    .font(.footnote)
                    .italic()
            }
             
        }
        .padding()
        .onAppear{
            self.getState()
        }
       
    }
}

struct LightRow_Previews: PreviewProvider {
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let lightDevice = LightDevice(context: context)
        lightDevice.adresse = "192.168.1.42"
        
        return LightRow(lightDevice: lightDevice)
    }
}
