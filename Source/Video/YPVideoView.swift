//
//  YPVideoView.swift
//  YPImagePicker
//
//  Created by Nik Kov || nik-kov.com on 18.04.2018.
//  Copyright © 2018 Yummypets. All rights reserved.
//

import UIKit
import Stevia
import AVFoundation

/// A video view that contains video layer, supports play, pause and other actions.
/// Supports xib initialization.
public class YPVideoView: UIView {
    internal let playerView = UIView()
    internal let playerLayer = AVPlayerLayer()
    internal let playImageView = UIImageView(image: YPConfig.icons.playImage)
    
    public var player: AVPlayer {
        guard let p = playerLayer.player else {
            print("⚠️ YPVideoView >>> Problems with AVPlayer. Must not see this.")
            return AVPlayer()
        }
        return p
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    internal func setup() {
        let singleTapGR = UITapGestureRecognizer(target: self,
                                                 action: #selector(singleTap))
        singleTapGR.numberOfTapsRequired = 1
        addGestureRecognizer(singleTapGR)
        
        // Loop playback
        NotificationCenter.default.addObserver(self,
                         selector: #selector(playerItemDidReachEnd(_:)),
                         name: .AVPlayerItemDidPlayToEndTime,
                         object: nil)
        
        playImageView.alpha = 0.8
        playerLayer.videoGravity = .resizeAspect
        
        sv(
            playerView,
            playImageView
        )
        playImageView.centerInContainer()
        playerView.fillContainer()
        playerView.layer.addSublayer(playerLayer)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = playerView.frame
    }
    
    @objc internal func singleTap() {
        pauseUnpause()
    }
    
    @objc public func playerItemDidReachEnd(_ note: Notification) {
        player.actionAtItemEnd = .none
        player.seek(to: kCMTimeZero)
        player.play()
    }
}

// MARK: - Video handling
extension YPVideoView {
    /// The main load video method
    public func loadVideo<T>(_ item: T) {
        var player: AVPlayer
        
        switch item.self {
        case let video as YPVideo:
            player = AVPlayer(url: video.url)
        case let url as URL:
            player = AVPlayer(url: url)
        case let playerItem as AVPlayerItem:
            player = AVPlayer(playerItem: playerItem)
        default:
            return
        }
        
        playerLayer.player = player
    }
    
    /// Convenience func to pause or unpause video dependely of state
    public func pauseUnpause() {
        (player.rate == 0.0) ? play() : pause()
    }

    /// Mute or unmute the video
    public func muteUnmute() {
        player.isMuted = !player.isMuted
    }
    
    public func play() {
        player.play()
        showPlayImage(show: false)
    }
    
    public func pause() {
        player.pause()
        showPlayImage(show: true)
    }
    
    public func stop() {
        player.pause()
        player.seek(to: kCMTimeZero)
        showPlayImage(show: true)
    }
    
    /// Shows or hide the play image over the view.
    public func showPlayImage(show: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.playImageView.alpha = show ? 0.8 : 0
        }
    }
}

// MARK: - Other API
extension YPVideoView {
    /// Removes the observer for AVPlayerItemDidPlayToEndTime. Could be needed to implement own observer
    public func removeReachEndObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: nil)
    }
}
