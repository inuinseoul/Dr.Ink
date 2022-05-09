//
//  MainTabBar.swift
//  Dr.Ink
//
//  Created by Inwoo Park on 2022/05/09.
//

import SwiftUI

struct MainTabBar: View {
    let tabBarImageNames = ["Plant","Calendar","Water","Challenge","Settings"]
    
    @State var selectedIndex = 0
    @State var shouldShowWaterFullScreen = false
    @State var shouldShowMainModal = false
    @State var modalContent: ModalContent?
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Spacer().fullScreenCover(isPresented: $shouldShowWaterFullScreen, content: {
                            Water(shouldShowModal: $shouldShowWaterFullScreen, drinks: [.water, .greenTea, .coffee])
                    })
                    
                    switch selectedIndex {
                    case 0:
                        Plant()
                    case 1:
                        Calendar()
                    case 3:
                        Challenge(showModal: $shouldShowMainModal, modalContent: $modalContent)
                    case 4:
                        Setting()
                    default:
                        Text("Error")
                    }
                }
                
                Spacer()
                
                HStack {
                    ForEach(0..<5) { idx in
                        Button(action: {
                            if idx == 2 {
                                shouldShowWaterFullScreen.toggle()
                            } else {
                                selectedIndex = idx
                            }
                        }, label: {
                            Spacer()
                            if idx == 2 {
                                ZStack{
                                    Circle()
                                        .foregroundColor(Color("DarkBlue"))
                                        .frame(width: 70)
                                    Image(tabBarImageNames[idx])
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 12.0)
                                .offset(y: -10)
                            } else {
                                Image(tabBarImageNames[idx])
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                        })
                    }
                }.frame(width: UIScreen.main.bounds.width)
            }
            
            MainModal(isShowing: $shouldShowMainModal, content: $modalContent)
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBar()
    }
}