//
//  PauseButton.swift
//  ProjectApollo III
//
//  Created by Luca Aguiar on 16/11/23.
//
import SpriteKit
import SwiftUI



struct PauseButton: View {
    var scene: GameScene
    
    var body: some View {
        Button(action: {
            scene.isPaused.toggle()
            scene.togglePauseTimers()
        }) {
            Text("Pause Button")
                .foregroundColor(.white)
        }
        .padding(.top, -415)
        .padding(.leading, 250)
    }
}

#Preview {
    PauseButton(scene: GameScene())
}
