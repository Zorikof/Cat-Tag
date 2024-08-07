import SwiftUI

struct WinView: View {
    let winner: Player
    let humanWins: Int
    let computerWins: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("GameBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        NavigationLink(destination: MenuView()) {
                            Image("BackToMenuButton")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .disabled(true)
                        }
                        .position(x: 60, y: 70)
                    }
                    Spacer()
                }
                VStack {
                    Spacer()
                        .frame(height: 50)
                    HStack(spacing: 50) {
                        Image("LeftWin")
                            .resizable()
                            .frame(width: 150, height: 150)
                        Image("RightWin")
                            .resizable()
                            .frame(width: 150, height: 150)
                    }
                    HStack(spacing: 20) {
                        Image("PlayersTurn")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Image("CatsTurn")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    Text("\(humanWins) : \(computerWins)")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                    ZStack {
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width, height: 100)
                        Text("WINNER")
                            .font(.system(size: 50, design: .serif))
                            .foregroundColor(.white)
                    }
                    
                    if winner == .human {
                        Image("HumanWin")
                            .resizable()
                            .frame(width: 150, height: 200)
                    } else {
                        Image("ComputerWin")
                            .resizable()
                            .frame(width: 150, height: 200)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct WinViews: PreviewProvider {
    static var previews: some View {
        WinView(winner: .human, humanWins: 5, computerWins: 3)
    }
}
