import SwiftUI

struct MenuView: View {
    
    @State private var optionsView = false
    @State private var rounds: Int = 5
    @State private var isMusicOn: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("MenuBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: optionsView ? 10 : 0)
                VStack(spacing: 100) {
                    NavigationLink(destination: GameView()) {
                        Image("PlayButton")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .blur(radius: optionsView ? 10 : 0)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        self.optionsView.toggle()
                    }) {
                        Image("MenuOptionsButton")
                            .resizable()
                            .frame(width: 230, height: 100)
                            .blur(radius: optionsView ? 10 : 0)
                    }
                }
                .padding(.top, -150)
                
                VStack(spacing: 30) {
                    Button(action: {
                        if isMusicOn == true {
                            return
                        } else {
                            SoundManager.instance.playSound()
                            isMusicOn = true
                        }
                    }) {
                        Image("MusicOnButton")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .blur(radius: optionsView ? 10 : 0)
                    }
                    Button(action: {
                        SoundManager.instance.stopSound()
                        isMusicOn = false
                        
                    }) {
                        Image("MusicOffButton")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .blur(radius: optionsView ? 10 : 0)
                    }
                }
                .position(x: 60, y: UIScreen.main.bounds.height - 150)
                
                if optionsView {
                    Color.black.opacity(0.6)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.optionsView = false
                        }
                    OptionsView(gameSettings: GameViewModel(), rounds: $rounds)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            SoundManager.instance.playSound()
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
