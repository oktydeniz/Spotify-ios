//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by oktay on 22.07.2023.
//

import Foundation
import UIKit
import AVFoundation

protocol PlaybackDataSource: AnyObject {
    
    var songName: String? {get}
    var subtitle:String? {get}
    var imgURL: URL?{get}
}

final class PlaybackPresenter{
    
    static let shared = PlaybackPresenter()
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if let player = self.playerQueue, !tracks.isEmpty {
            let item = player.currentItem
            let items = player.items()
            guard let index = items.firstIndex(where: { $0 == item}) else {return nil}
            return tracks[index]
        }
        return nil
    }
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
    ){
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        player = AVPlayer(url: url)
        let vc = PlayerViewController()
        player?.volume = 0.3
        
        vc.title = track.name
        self.track = track
        self.tracks = []
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true) {  [weak self] in
            self?.player?.play()
        }
        
    }
    
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]
    ){
        self.tracks = tracks
        self.track = nil
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else {
                return nil
            }
            return AVPlayerItem(url: url)
        }))
        self.playerQueue?.volume = 0.3
        self.playerQueue?.play()
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }

}


extension PlaybackPresenter: PlaybackDataSource, PlayerViewControllerDelegate {
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        } else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            player?.pause()
        } else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            playerQueue?.volume = 0.3
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        } else if let player = playerQueue {
            playerQueue?.advanceToNextItem()
        }
    }
    
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imgURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
    
    
}
