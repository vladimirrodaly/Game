import SwiftUI
import SpriteKit



struct ContentView: View {

    let scene = GameScene()

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}


#Preview {
    ContentView()
}
