//
//  LightDetail.swift
//  LifxCinema
//
//  Created by Jean-Sébastien POÜS on 07/01/2020.
//  Copyright © 2020 Jean-Sébastien POÜS. All rights reserved.
//

import SwiftUI
import CoreData
import Network
import LIFXClient
import PromiseKit

struct LightDetail: View {
    
    var lightDevice: LightDevice
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 25)
                .frame(height: 175)
                .edgesIgnoringSafeArea(.top)
                .shadow(radius: 10)
            VStack{
                Text("Label")
            }
            Spacer()
        }
    }
}

struct LightDetail_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let lightDevice = LightDevice(context: context)
        lightDevice.adresse = "192.168.1.42"
        
        return
            //NavigationView{
            LightDetail(lightDevice: lightDevice)
            /*}
            .navigationBarItems(leading:
                Text("Lights")
                    .foregroundColor(.red)
            )*/
    }
}
