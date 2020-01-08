//
//  HSBK.swift
//  LifxCinema
//
//  Created by Jean-Sébastien POÜS on 07/01/2020.
//  Copyright © 2020 Jean-Sébastien POÜS. All rights reserved.
//

import SwiftUI
import LIFXClient
import PromiseKit
import Network

struct HSBK: View {
    
    var lightDevice: LightDevice
    
    @State private var brightness: CGFloat = 0
    @State private var hue: CGFloat = 0
    @State private var saturation: CGFloat = 0
    @State private var kelvin: Double = 3200
    
    
    private func getInfoLight(){
        LIFXClient.getLight(address: self.lightDevice.adresse!).done{
            state in
            self.brightness = CGFloat(state.state.color.brightness)/65535
            self.hue = CGFloat(state.state.color.hue)/65535
            self.saturation = CGFloat(state.state.color.saturation)/65535
            self.kelvin = Double(state.state.color.kelvin)
            
            print(self.brightness)
            }
        }

    
    func changeHSBK() {
        LIFXClient.connect(host: .ipv4(try!(IPv4Address(self.lightDevice.adresse!)))).then {
            client in
            return client.light.setColor(color: .init(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1), kelvin: UInt16(self.kelvin))
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("BRIGHTNESS")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding(.trailing)
                    Text("\(Int(brightness*100)) %")
                        .font(.footnote)
                    Spacer()
                }
                .padding(.leading)
            
            HStack{
                Image(systemName: "sun.min")
                Slider(value: Binding(get: {
                    self.brightness
                }, set: { (newVal) in
                    self.brightness = newVal
                    self.changeHSBK()
                }), in: 0...1, step: 0.05)
                Image(systemName: "sun.max")
                    .imageScale(.large)
            }
            .padding(.horizontal)
            }
            VStack {
                HStack {
                    Text("HUE")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding(.trailing)
                    Text("\(Int(hue*360)) °")
                        .font(.footnote)
                    Spacer()
                }
                .padding(.leading)
            
            HStack{
                Image(systemName: "dial")
                Slider(value: Binding(get: {
                    self.hue
                }, set: { (newVal) in
                    self.hue = newVal
                    self.changeHSBK()
                }), in: 0...1, step: 0.05)
                Image(systemName: "dial")
                    .imageScale(.large)
            }
            .padding(.horizontal)
            }
            .padding(.top)
            VStack {
                HStack {
                    Text("SATURATION")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding(.trailing)
                    Text("\(Int(saturation*100)) %")
                        .font(.footnote)
                    Spacer()
                }
                .padding(.leading)
            
            HStack{
                Image(systemName: "circle.lefthalf.fill")
                Slider(value: Binding(get: {
                    self.saturation
                }, set: { (newVal) in
                    self.saturation = newVal
                    self.changeHSBK()
                }), in: 0...1, step: 0.05)
                Image(systemName: "circle.righthalf.fill")
                    .imageScale(.large)
            }
            .padding(.horizontal)
            }
            .padding(.top)
            VStack {
                    HStack {
                        Text("CCT")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .padding(.trailing)
                        Text("\(Int(kelvin)) K")
                            .font(.footnote)
                            Spacer()
                           }
                           .padding(.leading)
                       
                       HStack{
                           Image(systemName: "plus.circle")
                           Slider(value: Binding(get: {
                               self.kelvin
                           }, set: { (newVal) in
                               self.kelvin = newVal
                               self.changeHSBK()
                           }), in: 2500...9000, step: 100)
                           Image(systemName: "minus.circle")
                               .imageScale(.large)
                       }
                       .padding(.horizontal)
                       }
                       .padding(.top)
        }.onAppear{
            self.getInfoLight()
        }
        
    }
}

struct HSBK_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let lightDevice = LightDevice(context: context)
        lightDevice.adresse = "192.168.1.42"
        
        return HSBK(lightDevice: lightDevice)
    }
}
