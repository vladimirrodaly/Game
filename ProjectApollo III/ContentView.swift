import SwiftUI
import SpriteKit




struct ContentView: View {
    @State var displayedScene = GameScene()

    
    
    var body: some View {
        ZStack {
            SpriteView(scene: displayedScene)
                .ignoresSafeArea()
            PauseButton(scene: displayedScene)
        }
    }
}
#Preview {
    ContentView(displayedScene: GameScene())
}
