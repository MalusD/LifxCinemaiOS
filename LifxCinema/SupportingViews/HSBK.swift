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

/*enum PlusGreen: Int, CaseIterable, Identifiable, Hashable{
    case noPreset
    case eightPG
    case quarterPG
    case halfPG
    case fullPG
}

extension PlusGreen{
    
    var id: UUID {
        return UUID()
    }
    
    var name: String{
        switch(self){
        case .noPreset:
            return "No Preset"
        case .eightPG:
            return "1/8 +G"
        case .quarterPG:
            return "1/4 +G"
        case .halfPG:
            return "1/4 +G"
        case .fullPG:
            return "Full +G"
        }
    }
}*/

struct HSBK: View {
    
    var lightDevice: LightDevice
    
    var kelvinPresets = ["No presets", "3200", "4300", "5600", "6000"]
    var plusGreenPresets = ["No Presets", "1/8 +G", "1/4 +G", "1/2 +G", "Full +G"]
    var minusGreenPresets = ["No Presets", "1/8 -G", "1/4 -G", "1/2 -G", "Full -G"]
    
    @State private var getPreset = 0
    @State private var selectedPGPresets = 0
    @State private var selectedMGPresets = 0
   // @State private var selectedPlusGreenPreset: PlusGreen = .noPreset
    
    @State private var brightness: CGFloat = 0
    @State private var hue: CGFloat = 0
    @State private var saturation: CGFloat = 0
    @State private var kelvin: Double = 3200
    
    
    private func getInfoLight(){
        _ = LIFXClient.getLight(address: self.lightDevice.adresse!).done{
            state in
            self.brightness = CGFloat(state.state.color.brightness)/65535
            self.hue = CGFloat(state.state.color.hue)/65535
            self.saturation = CGFloat(state.state.color.saturation)/65535
            self.kelvin = Double(state.state.color.kelvin)
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
                    }), in: 0...1, step: 0.01)
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
                    }), in: 0...1, step: 0.01)
                    Image(systemName: "dial")
                        .imageScale(.large)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
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
                    }), in: 0...1, step: 0.01)
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
            VStack {
                Picker(selection: $getPreset, label: Text("CCT presets")) {
                    ForEach(0..<kelvinPresets.count) { index in
                        Text(self.kelvinPresets[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onReceive([self.getPreset].publisher.first()) { value in
                    if value != 0 {
                        self.kelvin = Double(self.kelvinPresets[value])!
                        self.changeHSBK()
                    }
                }
            }
            .padding(.horizontal)
            VStack {
                Picker(selection: $selectedPGPresets, label: Text("Plus green presets")) {
                    ForEach(0..<plusGreenPresets.count) { index in
                        Text(self.plusGreenPresets[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onReceive([self.selectedPGPresets].publisher.first()) { value in
                    if value == 1 {
                        self.hue = 114/360
                        self.saturation = 4/100
                        self.changeHSBK()
                    }
                    if value == 2 {
                        self.hue = 80/360
                        self.saturation = 10/100
                        self.changeHSBK()
                    }
                    if value == 3 {
                        self.hue = 77/360
                        self.saturation = 11/100
                        self.changeHSBK()
                    }
                    if value == 4 {
                        self.hue = 80/360
                        self.saturation = 24/100
                        self.changeHSBK()
                    }
                }
            }
            .padding(.horizontal)
            VStack {
                Picker(selection: $selectedMGPresets, label: Text("Plus green presets")) {
                    ForEach(0..<minusGreenPresets.count) { index in
                        Text(self.minusGreenPresets[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onReceive([self.selectedMGPresets].publisher.first()) { value in
                    if value == 1 {
                        self.hue = 340/360
                        self.saturation = 5/100
                        self.changeHSBK()
                    }
                    if value == 2 {
                        self.hue = 347/360
                        self.saturation = 7/100
                        self.changeHSBK()
                    }
                    if value == 3 {
                        self.hue = 356/360
                        self.saturation = 11/100
                        self.changeHSBK()
                    }
                    if value == 4 {
                        self.hue = 338/360
                        self.saturation = 22/100
                        self.changeHSBK()
                    }
                }
            }
            .padding(.horizontal)
           /* VStack{
                Picker(selection: $selectedPlusGreenPreset, label: Text("Plus Green presets")){
                    ForEach(PlusGreen.allCases) { preset in
                        Text(preset.name).tag(preset)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }*/
        }
        .onAppear{
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
