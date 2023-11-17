import SwiftUI
import SpriteKit




struct ContentView: View {
    //@StateObject private var gameState = GameState()
    let scene = GameScene()
    // @State var isPaused: Bool = false
    
    var body: some View {
        ZStack{
            SpriteView(scene: scene)
                .ignoresSafeArea()
                        Button(action: {
                            scene.isPaused.toggle()
                            scene.toggleTimers()
                        }) {
                            Text("Pause Button")
                                .foregroundColor(.white)
                        }
                        .padding(.top, -380)
                        .padding(.leading, 250)
                    }
        }
    }
//}
#Preview {
    ContentView()
}

