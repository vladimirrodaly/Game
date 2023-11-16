import SwiftUI
import SpriteKit




struct ContentView: View {
    @StateObject private var gameState = GameState()
    let scene = GameScene()
    
    var body: some View {
        ZStack{
            SpriteView(scene: scene)
                .ignoresSafeArea()
            Button(action: {
                gameState.isPaused.toggle()
                scene.isPaused = gameState.isPaused
                scene.toggleTimers(isPaused: gameState.isPaused)
            }) {
                Text("Pause Button")
                    .foregroundColor(.white)
            }
            .padding(.top, -380)
            .padding(.leading, 250)
        }
    }
}
#Preview {
    ContentView()
}

