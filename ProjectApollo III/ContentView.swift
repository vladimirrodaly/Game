//
//  ContentView.swift
//  ProjectApollo III
//
//  Created by Luca Aguiar on 31/10/23.
//

import SwiftUI
import SpriteKit
import AVFoundation


class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        scene?.size = CGSize(width: 750, height: 1335)
    }
}

struct ContentView: View {
    
    let scene = GameScene()
    let videoURL = Bundle.main.url(forResource: "video", withExtension:  "mp4")!
    
    var body: some View {
        SpriteView(scene: scene)
            .background(VideoPlayerView(videoURL: videoURL))
            .ignoresSafeArea()
    }
}


#Preview {
    ContentView()
}
