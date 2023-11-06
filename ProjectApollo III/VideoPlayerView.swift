//
//  VideoPlayerView.swift
//  ProjectApollo III
//
//  Created by Luca Aguiar on 02/11/23.
//

import SwiftUI
import AVFoundation
import AVKit



struct VideoPlayerView: View {
    
    private let player = AVPlayer()
    private let videoURL: URL

    
    init(videoURL: URL) {
        self.videoURL = videoURL
        player.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
        player.actionAtItemEnd = .none
        player.play()
    }
    
    var body: some View {
        VideoPlayer(player: player)
            .ignoresSafeArea()
    }
}
