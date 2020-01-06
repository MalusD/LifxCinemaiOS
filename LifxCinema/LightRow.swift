//
//  LightRow.swift
//  LifxCinema
//
//  Created by Jean-Sébastien POÜS on 06/01/2020.
//  Copyright © 2020 Jean-Sébastien POÜS. All rights reserved.
//

import SwiftUI
import CoreData

struct LightRow: View {
    
    var lightDevice : LightDevice
    
    var body: some View {
        HStack {
            Text("\(lightDevice.adresse ?? "No lights")")
            Spacer()
        }
        .padding(.horizontal)
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
