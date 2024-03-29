//
//  WaterView.swift
//  Dr.Ink
//
//  Created by Ebbyy on 2022/05/03.
//

import SwiftUI

struct WaterView: View {
    @FetchRequest(
            entity: DailyWater.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \DailyWater.date, ascending: true)],
            predicate: NSPredicate(format: "date >= %@ && date <= %@", Calendar.current.startOfDay(for: Date()) as CVarArg, Calendar.current.startOfDay(for: Date() + 86400 ) as CVarArg),
            animation: .default)
    var dailyWaterList: FetchedResults<DailyWater>
    
    @State private var showingAlert = false
    @State private var challengeMessage = ""
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var userSetting: UserSetting
    
    @Binding var shouldShowModal: Bool
    let drinks: [Drink]
    
    @State var progress : CGFloat = 0.3
    @State var startAnimation : CGFloat = 0.0
    @State var ml : Int = 300
    @State var fillColor = Color("LightLightBlue")
    @State var drinkselected : Drink = .water
    
    var body: some View {
        VStack(spacing: 5) {
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    shouldShowModal = false
                }, label: {
                    Text("X")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                })
                .padding(.trailing, 35.0)
            }
            
            HStack{
                Spacer()
                WaveAnimation(progress: $progress, startAnimation: $startAnimation, fillColor: $fillColor)
                    .frame(maxWidth: UIScreen.main.bounds.width/1.5, maxHeight: UIScreen.main.bounds.height/2)
                PlusMinButton
                Spacer()
            }
            AnotherButton
            Spacer()
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 50){
                    ForEach(drinks, id: \.self){drink in
                        ChooseDrink(drink: drink)
                            .onTapGesture {
                                DispatchQueue.main.async {
                                    self.drinkselected = drink
                                    fillColor = getColor()
                                }
                            }
                    }
                }
            }
            .environment(\.layoutDirection, .rightToLeft)
            .frame(height: UIScreen.main.bounds.height/8)
            .padding(.horizontal)

            Spacer()
        }
    }
}


//MARK : PREVIEWS
struct Water_Previews: PreviewProvider {
    static var previews: some View {
        WaterView(shouldShowModal: .constant(false), drinks: [.water, .greenTea, .coffee])
    }
}

extension WaterView{
    private func ChooseDrink(drink: Drink) -> some View {
        VStack(){
            Spacer()
            Image(drink.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 61, height: 69)
                .opacity(drink == drinkselected ? 1 : 0.3)
            Text(drink.label)
                .foregroundColor(Color.black)
                .fontWeight(.semibold)
                .padding(.top, 10)
                .opacity(drink == drinkselected ? 1 : 0.3)
        }
    }
    
    var PlusMinButton : some View {
        VStack{
            Button(action: {
                if ml < 1000 {
                    progress = progress + 0.05
                    ml += 50
                }
            },label:{
                Image("PlusWaterBtn")
            })
            
            Button(action: {
                if ml > 0 {
                    progress = progress - 0.05
                    ml = ml - 50
                }
            },label:{
                Image("MinWaterBtn")
            })
        }
    }
    
    var AnotherButton : some View {
        HStack(spacing: 20){
            Text("\(ml)ml")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 125, height: 55)
                .background(Color("DarkGreen"))
                .cornerRadius(24)
            
            Button(action: {
                if userSetting.challenges.contains(.rowCaffeine) && drinkselected.caffeine && userSetting.challenges.contains(.sugarFree) && drinkselected.sugar {
                    challengeMessage = "카페인 및 설탕이 포함된 음료를 드셨네요. 금일 챌린지를 모두 실패했습니다."
                    showingAlert = true
                    do {
                        dailyWaterList.first!.setValue(false, forKey: "caffeineChallenge")
                        dailyWaterList.first!.setValue(false, forKey: "sugarChallenge")
                        try context.save()
                    } catch {
                        print(error)
                    }
                } else if userSetting.challenges.contains(.rowCaffeine) && drinkselected.caffeine {
                    challengeMessage = "카페인이 포함된 음료를 드셨네요. 금일 카페인 챌린지는 실패했습니다."
                    showingAlert = true
                    do {
                        dailyWaterList.first!.setValue(false, forKey: "caffeineChallenge")
                        try context.save()
                    } catch {
                        print(error)
                    }
                } else if userSetting.challenges.contains(.sugarFree) && drinkselected.sugar {
                    challengeMessage = "설탕이 포함된 음료를 드셨네요. 금일 설탕 챌린지는 실패했습니다."
                    showingAlert = true
                    do {
                        dailyWaterList.first!.setValue(false, forKey: "sugarChallenge")
                        try context.save()
                    } catch {
                        print(error)
                    }
                } else {
                    addButtonPressed()
                    shouldShowModal = false
                }
            }, label: {
                Text("+ 추가")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 85, height: 55)
                    .background(Color("DarkGreen"))
                    .cornerRadius(24)
            })
            .alert(challengeMessage, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    addButtonPressed()
                    shouldShowModal = false
                }
            }
        }
    }
    
    func getColor() -> Color{
        return drinkselected.color
    }
    
    func addButtonPressed() {
        dailyWaterList.first!.setValue(dailyWaterList.first!.intake + Float(ml), forKey: "intake")
        do {
            try context.save()
            progress = 0
            ml = 0
        } catch {
            print(error)
        }
    }
}
