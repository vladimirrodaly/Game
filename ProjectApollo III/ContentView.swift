import SwiftUI
import SpriteKit




struct ContentView: View {
    let scene = GameScene()
    
    var body: some View {
        ZStack{
            SpriteView(scene: scene)
                .ignoresSafeArea()
            Button(action: {
                scene.background
            }) {
                Text("Clique aqui")
                    .foregroundColor(.white)
            }
            .position(x: 150, y: 200)
        }
    }
}
#Preview {
    ContentView()
}

