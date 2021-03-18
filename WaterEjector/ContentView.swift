//
//  ContentView.swift
//  WaterEjector
//
//  Created by Sheikh Bayazid on 12/23/20.
//

import SwiftUI

struct ContentView: View {
    
    private let soundManager = SoundManager()
    @State private var frequencyLevel: Double = 200
    @State private var isEjectOn = false
    @State private var ejectingMessage = ""
    
    private let screen = UIScreen.main.bounds.size
    
    private let backgroundColor = Color(UIColor(named: "backgroundColor")!)
    //private let circleColor = Color(UIColor(named: "circleColor")!)
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                //MARK: - Heading
                if isEjectOn {
                    Text("\(ejectingMessage)")
                        .font(.title2)
                        .frame(width: 150, height: 40)
                        .background(Color.secondary.opacity(0.05))
                        .cornerRadius(10)
                        .padding(.top, 10)
                }
                
                Spacer()
                
                //MARK: - Circle Button
                VStack {
                    Button(action: {
                        isEjectOn.toggle()
                        
                        startEjecting(at: 440)
                        
                    }, label: {
                        
                        ZStack {
                            Circle()
                                .fill(Color.secondary.opacity(0.5))
                                .frame(width: frequencyLevel == 200 ? 230 : CGFloat(frequencyLevel) / 3.5, height: frequencyLevel == 200 ? 230 : CGFloat(frequencyLevel) / 3.5) //210
                                .shadow(radius: 10, y: 5)
                            
                            Text(isEjectOn ? "Stop" : "Eject")
                                .font(.title)
                                .foregroundColor(.black)
                                .frame(width: 170, height: 170)
                                .shadow(radius: 10, y: 5)
                                .background(Color.white.opacity(0.85))
                                .clipShape(Circle())
                                .shadow(radius: 25, y: 12.5)
                        }
                    })
                }
                
                Spacer()
                
                //MARK: - Frequency, Stepper and Slider
                VStack {
                    Stepper(value: $frequencyLevel, in: 0...1200, step: 10) {
                        Text("\(Int(frequencyLevel)) Hz")
                            .font(.title)
                            .frame(width: 120, height: 45)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    Divider()
                    
                    Slider(value: $frequencyLevel, in: 0...1200, step: 1.0) { _ in
                        startEjecting(at: frequencyLevel)
                    }
                        .padding(6.5)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                    
                }.padding(.horizontal, 10)
                
                Spacer()
                
                //MARK: - Start Button
                VStack {
                    Button(action: {
                        withAnimation {
                            isEjectOn.toggle()
                        }
                        
                        startEjecting(at: frequencyLevel)
                        
                    }, label: {
                        Text(isEjectOn ? "Stop" : "Start")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(width: screen.width / 1.4, height: 45)
                            .background(Color.blue)
                            .cornerRadius(15)
                            .padding(.vertical)
                    })
                }
            }
        }
    }
    
    
    //MARK: - Start Ejecting
    func startEjecting(at frequency: Double) {
        if isEjectOn{
            soundManager.setFrequency(freq: frequency)
            soundManager.setToneVolume(vol: Double(soundManager.currentVolume))
            soundManager.enableSpeaker()
            soundManager.setToneTime(t: frequency)
            //Animating op message
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if ejectingMessage.isEmpty {
                    withAnimation(.linear(duration: 0.4)) {
                        ejectingMessage += "Ejecting ..."
                    }
                }
            }
            
        } else {
            soundManager.stop()
            ejectingMessage = ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
