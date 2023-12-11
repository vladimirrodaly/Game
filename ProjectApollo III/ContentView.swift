import SwiftUI
import SpriteKit




struct ContentView: View {
    @ObservedObject var displayedScene = GameScene()
    
    
    var body: some View {
        NavigationStack {
            HStack {
                ZStack {
                    SpriteView(scene: displayedScene)
                        .ignoresSafeArea()
                    PauseButton(scene: displayedScene)
                    
                    if displayedScene.isRunning == false {
                        NavigationLink {
                            ContentView().navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Text("Reiniciar o jogo")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(displayedScene: GameScene())
}
