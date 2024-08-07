import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Image("GameBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: viewModel.showingOptions || viewModel.alertItem != nil ? 20 : 0) // Apply blur when alert is shown
                
                if viewModel.showingOptions {
                    Color.black.opacity(0.6)
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack {
                    HStack {
                        if viewModel.showingOptions {
                            Image("BackToMenuButton")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .opacity(0.5)
                                .disabled(true)
                        } else {
                            NavigationLink(destination: MenuView()) {
                                Image("BackToMenuButton")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                        }
                        Spacer()
                        Button(action: {
                            viewModel.showingOptions.toggle()
                            viewModel.showingPlayerLabel = viewModel.showingOptions
                        }) {
                            Image(viewModel.showingOptions ? "CancelButton" : "GameOptionsButton")
                                .resizable()
                                .frame(width: 80, height: 80)
                        }
                    }
                    .padding()
                    .offset(y: 20)
                    .navigationBarHidden(true)
                    .disabled(viewModel.showingOptions && viewModel.showingPlayerLabel == false)
                    
                    Text("\(viewModel.humanWins) : \(viewModel.computerWins)")
                        .foregroundColor(.white)
                        .font(.system(size: 50))
                        .padding(.top, 40)
                        .blur(radius: viewModel.showingOptions || viewModel.alertItem != nil ? 20 : 0) // Apply blur when alert is shown
                    
                    Spacer()
                    
                    GeometryReader { geometry in
                        VStack {
                            LazyVGrid(columns: viewModel.columns, spacing: 10) {
                                ForEach(0..<9) { i in
                                    ZStack {
                                        Image("EmptyBox")
                                            .resizable()
                                            .opacity(0.8)
                                            .frame(width: geometry.size.width / 3 - 20, height: geometry.size.width / 3 - 20)
                                        Image(viewModel.moves[i]?.indicator ?? "")
                                            .resizable()
                                            .frame(width: geometry.size.width / 3 - 20, height: geometry.size.width / 3 - 20)
                                            .disabled(viewModel.moves[i] != nil)
                                    }
                                    .onTapGesture {
                                        viewModel.processPlayerMove(for: i)
                                    }
                                }
                            }
                            .disabled(viewModel.isGameboardDisabled || viewModel.showingOptions)
                            .blur(radius: viewModel.showingOptions || viewModel.alertItem != nil ? 20 : 0) // Apply blur when alert is shown
                            .padding()
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                    Spacer()
                }
                .overlay(
                    Group {
                        if viewModel.showingPlayerLabel {
                            OptionsView(gameSettings: GameViewModel(), rounds: $viewModel.rounds)
                        }
                    }
                )
                
                // Custom Alert
                if viewModel.alertItem != nil {
                    Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                }
                CustomAlertView(alertItem: $viewModel.alertItem, onDismiss: {
                    viewModel.resetGame() // Reset game when alert is dismissed
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        NavigationLink(destination: WinView(winner: viewModel.humanWins == viewModel.rounds ? .human : .computer, humanWins: viewModel.humanWins, computerWins: viewModel.computerWins), isActive: $viewModel.showingWinView) {
            EmptyView()
        }
    }
}


enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    let indicator: String
    
    init(player: Player, boardIndex: Int) {
        self.player = player
        self.boardIndex = boardIndex
        self.indicator = player == .human ? Move.playerImages.randomElement() ?? "" : Move.computerImages.randomElement() ?? ""
    }
    static let playerImages = ["OrangeCat1", "OrangeCat2", "OrangeCat3", "OrangeCat4", "OrangeCat5", "OrangeCat6", "OrangeCat7", "OrangeCat8", "OrangeCat9", "OrangeCat10", "OrangeCat11", "OrangeCat12", "OrangeCat13"]
    
    static let computerImages = ["PurpleCat1", "PurpleCat2", "PurpleCat3", "PurpleCat4", "PurpleCat5", "PurpleCat6", "PurpleCat7", "PurpleCat8", "PurpleCat9", "PurpleCat10", "PurpleCat11", "PurpleCat12", "PurpleCat13"]
}
