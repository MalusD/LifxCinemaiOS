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
    
    @State private var labelEditing: Bool = false
    @State private var labelEditField: String = "Label"
    @State private var power: Bool = false
    @State private var hue: Double = 0
    @State private var saturation: Double = 0
    //@State private var brightness: Float = 0
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    /*func changeBrightness() {
        print("SLider value changed to \(brightness)")
        LIFXClient.connect(host: .ipv4(try!(IPv4Address(self.lightDevice.adresse!)))).then {
            client in
            return client.light.setColor(color: .init(red: CGFloat(self.brightness), green: CGFloat(self.brightness), blue: CGFloat(self.brightness), alpha: CGFloat(self.brightness)))
        }
    }*/
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 25)
                .frame(height: 175)
                .edgesIgnoringSafeArea(.top)
                .shadow(radius: 10)
                .foregroundColor(Color(hue: hue, saturation: saturation, brightness: 1))
            HStack {
                VStack(alignment: .leading){
                    HStack {
                        Button(action: {
                            self.labelEditing.toggle()
                        }){
                        Image(systemName: "pencil.tip.crop.circle")
                        .imageScale(.medium)
                            .padding(.trailing, 10)
                            .foregroundColor(.primary)
                        }
                        if labelEditing {
                            TextField("Label", text: $labelEditField){
                                self.endEditing()
                                self.labelEditing.toggle()
                            }
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        }else {
                        Text(labelEditField)
                            .font(.title)
                            .fontWeight(.bold)
                        }
                    }
                    Text(lightDevice.adresse!)
                        .font(.footnote)
                }
                Spacer()
                Button(action: {
                    self.power.toggle()
                    LIFXClient.connect(host: .ipv4(try!(IPv4Address(self.lightDevice.adresse!)))).then {
                        client in
                        return client.light.setPower(on: self.power)
                    }
                }) {
                    if power{
                        Text("Power ON")
                            .foregroundColor(.yellow)
                            .font(.footnote)
                        Image(systemName: "lightbulb")
                            .foregroundColor(.yellow)
                            .imageScale(.large)
                    } else {
                        Text("Power OFF")
                            .foregroundColor(.primary)
                            .font(.footnote)
                        Image(systemName: "lightbulb.slash")
                            .foregroundColor(.primary)
                            .imageScale(.large)
                    }
                    
                }
            }
            .padding(.horizontal)
            
            VStack {
                HSBK(lightDevice: lightDevice)
            }
            .padding(.top)
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
