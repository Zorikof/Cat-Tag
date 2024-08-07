import SwiftUI

struct OptionsView: View {
    @ObservedObject var gameSettings: GameViewModel
    @Binding var rounds: Int
    
    init(gameSettings: GameViewModel, rounds: Binding<Int>) {
        self.gameSettings = gameSettings
        self._rounds = rounds
    }
    
    var body: some View {
        VStack(spacing: 50) {
            Image("PlayerLabel")
                .resizable()
                .frame(width: 100, height: 30)
            
            HStack(spacing: 30) {
                Image("CatsTurn")
                Image("PlayersTurn")
            }
            Image("RoundsLabel")
                .resizable()
                .frame(width: 100, height: 30)
            
            HStack(spacing: 20) {
                Button(action: {
                    if rounds > 1 {
                        rounds -= 1
                    }
                }) {
                    Image("MinusButton")
                        .resizable()
                        .frame(width: 30, height: 10)
                        .padding(20)
                }
                .contentShape(Rectangle())
                
                Text("\(rounds)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Button(action: {
                    if rounds < 10 {
                        rounds += 1
                    }
                }) {
                    Image("PlusButton")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(10)
                }
                .contentShape(Rectangle())
            }
        }
        .offset(y: -100)
        .onAppear {
            if let savedRounds = UserDefaults.standard.value(forKey: "rounds") as? Int {
                self.rounds = savedRounds
            }
        }
        .onChange(of: rounds) { newRounds in
            UserDefaults.standard.setValue(newRounds, forKey: "rounds")
        }
    }
}
